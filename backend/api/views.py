### File: backend/api/views.py
from datetime import timedelta
from django.db.models import Sum, Count
from django.utils import timezone
from rest_framework import filters, viewsets
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.exceptions import PermissionDenied
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from .models import ChitPlan, Customer, Employee, HomeAddress, Subscription, CurrentAddress, WorkAddress, CustomerEditRequest, CustomerDeleteRequest
from .permissions import (
    IsAdminEmployee, IsAdminOrFieldAgent, IsAdminOrOwnCustomer,
    IsAdminOrOwnCustomerAddress, IsAdminOrOwnCustomerSubscription,
    employee_permissions, get_employee, is_admin_or_subadmin
)
from .serializers import (
    ChitPlanSerializer, CustomTokenObtainPairSerializer, CustomerSerializer,
    DashboardRecentCustomerSerializer, DashboardRecentSubscriptionSerializer,
    EmployeeSerializer, HomeAddressSerializer, SubscriptionSerializer,
    CurrentAddressSerializer, WorkAddressSerializer, CustomerEditRequestSerializer,
    CustomerDeleteRequestSerializer
)

class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer
    permission_classes = [AllowAny]

class CustomTokenRefreshView(TokenRefreshView):
    permission_classes = [AllowAny]

def _scoped_customers_queryset(user):
    """
    Returns all customers accessible to active employees.
    """
    queryset = Customer.objects.all()
    employee = get_employee(user)
    if not employee:
        return queryset.none()
    return queryset

def _scoped_subscriptions_queryset(user):
    """
    Returns all subscriptions accessible to active employees.
    """
    queryset = Subscription.objects.all()
    employee = get_employee(user)
    if not employee:
        return queryset.none()
    return queryset

class DashboardStatsAPIView(APIView):
    permission_classes = employee_permissions(IsAdminOrFieldAgent)

    def get(self, request):
        employee = get_employee(request.user)
        if not employee:
            return Response({
                'total_customers': 0, 'active_subscriptions': 0,
                'monthly_collections_total': 0, 'pending_payments': 0,
                'active_chit_plans': 0, 'recent_onboardings': 0,
            })

        customers_qs = _scoped_customers_queryset(request.user)
        subscriptions_qs = _scoped_subscriptions_queryset(request.user)
        active_subscriptions_qs = subscriptions_qs.filter(subscription_status=Subscription.SubscriptionStatus.ACTIVE)

        monthly_collections = active_subscriptions_qs.aggregate(total=Sum('chit_plan__monthly_payment'))['total'] or 0
        pending_payments = subscriptions_qs.filter(payment_status__in=[Subscription.PaymentStatus.PENDING, Subscription.PaymentStatus.OVERDUE]).count()
        seven_days_ago = timezone.now() - timedelta(days=7)
        recent_onboardings = customers_qs.filter(created_at__gte=seven_days_ago).count()

        return Response({
            'total_customers': customers_qs.filter(approval_status='Approved').count(),
            'active_subscriptions': active_subscriptions_qs.count(),
            'monthly_collections_total': float(monthly_collections),
            'pending_payments': pending_payments,
            'active_chit_plans': ChitPlan.objects.filter(is_active=True).count(),
            'recent_onboardings': recent_onboardings,
        })

class DashboardRecentCustomersAPIView(APIView):
    permission_classes = employee_permissions(IsAdminOrFieldAgent)

    def get(self, request):
        customers = _scoped_customers_queryset(request.user).filter(approval_status='Approved').order_by('-created_at')[:5]
        serializer = CustomerSerializer(customers, many=True, context={'request': request})
        return Response(serializer.data)

class DashboardRecentSubscriptionsAPIView(APIView):
    permission_classes = employee_permissions(IsAdminOrFieldAgent)

    def get(self, request):
        subscriptions = (_scoped_subscriptions_queryset(request.user)
                         .filter(subscription_status=Subscription.SubscriptionStatus.ACTIVE)
                         .select_related('customer', 'chit_plan')
                         .order_by('-joined_date')[:5])
        serializer = DashboardRecentSubscriptionSerializer(subscriptions, many=True)
        return Response(serializer.data)

class EmployeeViewSet(viewsets.ModelViewSet):
    queryset = Employee.objects.select_related('user').all()
    serializer_class = EmployeeSerializer
    permission_classes = employee_permissions(IsAdminEmployee)
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['employee_id', 'user__username', 'user__first_name', 'user__last_name']
    ordering_fields = ['employee_id', 'role']

    @action(detail=True, methods=['post'])
    def toggle_status(self, request, pk=None):
        employee = self.get_object()
        employee.user.is_active = not employee.user.is_active
        employee.user.save()
        return Response({'success': True, 'is_active': employee.user.is_active})

class CustomerViewSet(viewsets.ModelViewSet):
    serializer_class = CustomerSerializer
    permission_classes = employee_permissions(IsAdminOrFieldAgent, IsAdminOrOwnCustomer)
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['customer_id', 'full_name', 'mobile_number']
    ordering_fields = ['created_at', 'customer_id', 'full_name']

    def get_queryset(self):
        queryset = Customer.objects.select_related('created_by', 'created_by__user', 'home_address', 'current_address', 'work_address').prefetch_related('subscriptions__chit_plan')
        employee = get_employee(self.request.user)
        print(f"=== [CUSTOMER QUERYSET] Request User: {self.request.user} (Employee: {employee}) ===")
        if not employee: 
            print("=== [CUSTOMER QUERYSET] No employee profile found! Returning empty. ===")
            return queryset.none()

        chit_plan = self.request.query_params.get('chit_plan')
        if chit_plan: queryset = queryset.filter(subscriptions__chit_plan_id=chit_plan)

        chit_plan_code = self.request.query_params.get('chit_plan_code')
        if chit_plan_code: queryset = queryset.filter(subscriptions__chit_plan__plan_code__icontains=chit_plan_code)

        approval_status = self.request.query_params.get('approval_status')
        if approval_status: queryset = queryset.filter(approval_status=approval_status)

        res = queryset.distinct()
        print(f"=== [CUSTOMER QUERYSET] Total count returned: {res.count()} ===")
        return res

    def perform_create(self, serializer):
        """Create a new Customer.

        - Admin / Sub‑admin → auto‑approved and editing disabled.
        - Field Agent → pending approval, editing enabled (edit_enabled=True) during pending onboarding.
        """
        employee = get_employee(self.request.user)
        if not employee:
            raise PermissionDenied("Only employees can create customers.")

        privileged = employee.role in (Employee.Role.ADMIN, Employee.Role.SUBADMIN)
        approval_status = "Approved" if privileged else "Pending"
        edit_enabled = not privileged  # True while onboarding/pending, False if auto-approved by admin

        serializer.save(
            created_by=employee,
            approval_status=approval_status,
            edit_enabled=edit_enabled,
        )
    
    def perform_update(self, serializer):
        """Update a Customer. All authenticated employees can update any customer."""
        serializer.save()
    
    @action(detail=True, methods=['post'])
    def approve(self, request, pk=None):
        """
        Authorization gate allowing Subadmins and root Admins to authorize a pending profile.
        """
        if not is_admin_or_subadmin(request.user):
            raise PermissionDenied("Only administrative or sub-administrative profiles have approval rights.")
        customer = self.get_object()
        employee = get_employee(request.user)
        customer.approval_status = "Approved"
        customer.edit_enabled = False
        customer.save()

        CustomerEditRequest.objects.filter(customer=customer, status='Pending').update(
            status='Approved',
            resolved_by=employee,
            resolved_at=timezone.now()
        )
        return Response({"message": "Customer onboarding finalized successfully."})

class HomeAddressViewSet(viewsets.ModelViewSet):
    serializer_class = HomeAddressSerializer
    permission_classes = employee_permissions(IsAdminOrOwnCustomerAddress)

    def get_queryset(self):
        queryset = HomeAddress.objects.select_related('customer', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee: return queryset.none()
        return queryset

class CurrentAddressViewSet(viewsets.ModelViewSet):
    serializer_class = CurrentAddressSerializer
    permission_classes = employee_permissions(IsAdminOrOwnCustomerAddress)

    def get_queryset(self):
        queryset = CurrentAddress.objects.select_related('customer', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee: return queryset.none()
        return queryset

class WorkAddressViewSet(viewsets.ModelViewSet):
    serializer_class = WorkAddressSerializer
    permission_classes = employee_permissions(IsAdminOrOwnCustomerAddress)

    def get_queryset(self):
        queryset = WorkAddress.objects.select_related('customer', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee: return queryset.none()
        return queryset

class ChitPlanViewSet(viewsets.ModelViewSet):
    serializer_class = ChitPlanSerializer

    def get_permissions(self):
        if self.action in ('create', 'update', 'partial_update', 'destroy'):
            return [permission() for permission in employee_permissions(IsAdminEmployee)]
        return [permission() for permission in employee_permissions()]

    def get_queryset(self):
        queryset = ChitPlan.objects.all()
        if not is_admin_or_subadmin(self.request.user):
            queryset = queryset.filter(is_active=True)
        return queryset

class SubscriptionViewSet(viewsets.ModelViewSet):
    serializer_class = SubscriptionSerializer
    permission_classes = employee_permissions(IsAdminOrFieldAgent, IsAdminOrOwnCustomerSubscription)

    def get_queryset(self):
        queryset = Subscription.objects.select_related('customer', 'chit_plan', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee: return queryset.none()
        
        customer_id = self.request.query_params.get('customer')
        if customer_id:
            queryset = queryset.filter(customer_id=customer_id)

        return queryset

from datetime import datetime, date, timedelta

def _get_date_range(request):
    period = request.GET.get('period', 'this_month')
    start_date_param = request.GET.get('start_date')
    end_date_param = request.GET.get('end_date')

    today = timezone.now().date()

    if start_date_param and end_date_param:
        try:
            start_date = datetime.strptime(start_date_param, '%Y-%m-%d').date()
            end_date = datetime.strptime(end_date_param, '%Y-%m-%d').date()
            return start_date, end_date
        except ValueError:
            pass

    if period == 'this_month':
        start_date = today.replace(day=1)
        end_date = today
    elif period == 'last_month':
        first_of_this_month = today.replace(day=1)
        end_of_last_month = first_of_this_month - timedelta(days=1)
        start_date = end_of_last_month.replace(day=1)
        end_date = end_of_last_month
    elif period == '3_months':
        start_date = today - timedelta(days=90)
        end_date = today
    elif period == 'this_year':
        start_date = today.replace(month=1, day=1)
        end_date = today
    else:
        start_date = date(2020, 1, 1)
        end_date = today

    return start_date, end_date

@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def reports_summary(request):
    start_date, end_date = _get_date_range(request)

    customers = _scoped_customers_queryset(request.user)
    subscriptions = _scoped_subscriptions_queryset(request.user)

    new_customers = customers.filter(created_at__date__gte=start_date, created_at__date__lte=end_date).count()

    total_collections = subscriptions.filter(payment_status=Subscription.PaymentStatus.PAID).aggregate(total=Sum('chit_plan__monthly_payment'))['total'] or 0
    active_chitties = subscriptions.filter(subscription_status=Subscription.SubscriptionStatus.ACTIVE).count()
    pending_payments = subscriptions.filter(payment_status=Subscription.PaymentStatus.PENDING).count()

    return Response({
        "total_collections": float(total_collections),
        "new_customers": new_customers,
        "active_chitties": active_chitties,
        "pending_payments": pending_payments,
        "start_date": str(start_date),
        "end_date": str(end_date),
    })

@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def monthly_collections(request):
    # Calculate live monthly collections from paid subscriptions
    subscriptions = _scoped_subscriptions_queryset(request.user).filter(payment_status=Subscription.PaymentStatus.PAID)
    total = subscriptions.aggregate(total=Sum('chit_plan__monthly_payment'))['total'] or 0
    
    return Response([
        {"month": "Jul", "amount": float(total)},
        {"month": "Aug", "amount": 0},
    ])

@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def plan_distribution(request):
    plans = ChitPlan.objects.annotate(customer_count=Count('subscriptions'))
    return Response([{"plan": plan.chit_name, "customers": plan.customer_count} for plan in plans])

@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def payment_overview(request):
    subscriptions = _scoped_subscriptions_queryset(request.user)
    paid_count = subscriptions.filter(payment_status=Subscription.PaymentStatus.PAID).count()
    pending_count = subscriptions.filter(payment_status=Subscription.PaymentStatus.PENDING).count()
    overdue_count = subscriptions.filter(payment_status=Subscription.PaymentStatus.OVERDUE).count()
    upcoming_count = subscriptions.filter(subscription_status=Subscription.SubscriptionStatus.ACTIVE).count() - (paid_count + pending_count + overdue_count)
    if upcoming_count < 0:
        upcoming_count = 0

    return Response({
        "paid": paid_count,
        "upcoming": upcoming_count,
        "pending": pending_count,
        "overdue": overdue_count
    })

class AgentDashboardAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        employee = Employee.objects.get(user=request.user)
        all_customers = Customer.objects.all()
        approved_customers = Customer.objects.filter(approval_status='Approved').select_related(
            'created_by', 'created_by__user', 'home_address', 'current_address', 'work_address'
        ).prefetch_related('subscriptions__chit_plan').order_by('-created_at')[:5]

        subscriptions = Subscription.objects.filter(
            subscription_status='active',
        )

        recent_customers_data = CustomerSerializer(approved_customers, many=True, context={'request': request}).data

        return Response({
            'total_customers': all_customers.filter(approval_status='Approved').count(),
            'active_subscriptions': subscriptions.count(),
            'recent_customers': recent_customers_data,
        })


class CustomerEditRequestViewSet(viewsets.ModelViewSet):
    serializer_class = CustomerEditRequestSerializer
    permission_classes = employee_permissions()

    def get_queryset(self):
        queryset = CustomerEditRequest.objects.select_related('customer', 'requested_by')
        employee = get_employee(self.request.user)
        if not employee:
            return queryset.none()
        if not is_admin_or_subadmin(self.request.user):
            queryset = queryset.filter(requested_by=employee)
        
        customer_id = self.request.query_params.get('customer')
        if customer_id:
            queryset = queryset.filter(customer_id=customer_id)
            
        status = self.request.query_params.get('status')
        if status:
            queryset = queryset.filter(status=status)
            
        return queryset

    def perform_create(self, serializer):
        employee = get_employee(self.request.user)
        customer = serializer.validated_data['customer']
        
        if customer.edit_enabled:
            raise PermissionDenied("This customer profile is not locked. No edit request is necessary.")
            
        existing_pending = CustomerEditRequest.objects.filter(customer=customer, status='Pending').exists()
        if existing_pending:
            raise PermissionDenied("An edit request is already pending for this customer.")

        serializer.save(requested_by=employee)

    @action(detail=True, methods=['post'])
    def approve(self, request, pk=None):
        if not is_admin_or_subadmin(request.user):
            raise PermissionDenied("Only admins or subadmins can approve edit requests.")
        
        edit_request = self.get_object()
        if edit_request.status != 'Pending':
            raise PermissionDenied("This request has already been resolved.")

        employee = get_employee(request.user)
        edit_request.status = 'Approved'
        edit_request.resolved_by = employee
        edit_request.resolved_at = timezone.now()
        edit_request.save()

        # Unlock the customer
        customer = edit_request.customer
        customer.edit_enabled = True
        customer.save()

        return Response({"message": "Edit request approved. Customer profile unlocked."})

    @action(detail=True, methods=['post'])
    def reject(self, request, pk=None):
        if not is_admin_or_subadmin(request.user):
            raise PermissionDenied("Only admins or subadmins can reject edit requests.")
        
        edit_request = self.get_object()
        if edit_request.status != 'Pending':
            raise PermissionDenied("This request has already been resolved.")

        employee = get_employee(request.user)
        edit_request.status = 'Rejected'
        edit_request.resolved_by = employee
        edit_request.resolved_at = timezone.now()
        edit_request.save()

        return Response({"message": "Edit request rejected."})


class CustomerDeleteRequestViewSet(viewsets.ModelViewSet):
    serializer_class = CustomerDeleteRequestSerializer
    permission_classes = employee_permissions()

    def get_queryset(self):
        queryset = CustomerDeleteRequest.objects.select_related('customer', 'requested_by')
        employee = get_employee(self.request.user)
        if not employee:
            return queryset.none()
        if not is_admin_or_subadmin(self.request.user):
            queryset = queryset.filter(requested_by=employee)
        
        customer_id = self.request.query_params.get('customer')
        if customer_id:
            queryset = queryset.filter(customer_id=customer_id)
            
        status = self.request.query_params.get('status')
        if status:
            queryset = queryset.filter(status=status)
            
        return queryset

    def perform_create(self, serializer):
        employee = get_employee(self.request.user)
        serializer.save(requested_by=employee)

    @action(detail=True, methods=['post'])
    def approve(self, request, pk=None):
        if not is_admin_or_subadmin(request.user):
            raise PermissionDenied("Only admins or subadmins can approve delete requests.")
        
        delete_request = self.get_object()
        if delete_request.status != 'Pending':
            raise PermissionDenied("This request has already been resolved.")

        employee = get_employee(request.user)
        delete_request.status = 'Approved'
        delete_request.resolved_by = employee
        delete_request.resolved_at = timezone.now()
        delete_request.save()

        # Delete the customer profile
        customer = delete_request.customer
        customer.delete()

        return Response({"message": "Delete request approved. Customer deleted successfully."})

    @action(detail=True, methods=['post'])
    def reject(self, request, pk=None):
        if not is_admin_or_subadmin(request.user):
            raise PermissionDenied("Only admins or subadmins can reject delete requests.")
        
        delete_request = self.get_object()
        if delete_request.status != 'Pending':
            raise PermissionDenied("This request has already been resolved.")

        employee = get_employee(request.user)
        delete_request.status = 'Rejected'
        delete_request.resolved_by = employee
        delete_request.resolved_at = timezone.now()
        delete_request.save()

        return Response({"message": "Delete request rejected."})
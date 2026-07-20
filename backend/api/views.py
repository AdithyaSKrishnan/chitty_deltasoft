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

from .models import ChitPlan, Customer, Employee, HomeAddress, Subscription, CurrentAddress, WorkAddress, CustomerEditRequest
from .permissions import (
    IsAdminEmployee, IsAdminOrFieldAgent, IsAdminOrOwnCustomer,
    IsAdminOrOwnCustomerAddress, IsAdminOrOwnCustomerSubscription,
    employee_permissions, get_employee, is_admin_or_subadmin
)
from .serializers import (
    ChitPlanSerializer, CustomTokenObtainPairSerializer, CustomerSerializer,
    DashboardRecentCustomerSerializer, DashboardRecentSubscriptionSerializer,
    EmployeeSerializer, HomeAddressSerializer, SubscriptionSerializer,
    CurrentAddressSerializer, WorkAddressSerializer, CustomerEditRequestSerializer
)

class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer
    permission_classes = [AllowAny]

class CustomTokenRefreshView(TokenRefreshView):
    permission_classes = [AllowAny]

def _scoped_customers_queryset(user):
    """
    Enforces active role separation. Admins and Subadmins query the comprehensive 
    database natively, while field agents access only self-created records.
    """
    queryset = Customer.objects.all()
    employee = get_employee(user)
    if not employee:
        return queryset.none()
    if not is_admin_or_subadmin(user):
        queryset = queryset.filter(created_by=employee)
    return queryset

def _scoped_subscriptions_queryset(user):
    queryset = Subscription.objects.all()
    employee = get_employee(user)
    if not employee:
        return queryset.none()
    if not is_admin_or_subadmin(user):
        queryset = queryset.filter(customer__created_by=employee)
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
        active_subscriptions_qs = subscriptions_qs.filter(
            subscription_status=Subscription.SubscriptionStatus.ACTIVE,
            customer__approval_status='Approved'
        )

        monthly_collections = active_subscriptions_qs.aggregate(total=Sum('chit_plan__monthly_payment'))['total'] or 0
        pending_payments = subscriptions_qs.filter(payment_status__in=[Subscription.PaymentStatus.PENDING, Subscription.PaymentStatus.OVERDUE]).count()
        seven_days_ago = timezone.now() - timedelta(days=7)
        recent_onboardings = customers_qs.filter(approval_status='Approved', created_at__gte=seven_days_ago).count()

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
        serializer = DashboardRecentCustomerSerializer(customers, many=True, context={'request': request})
        return Response(serializer.data)

class DashboardRecentSubscriptionsAPIView(APIView):
    permission_classes = employee_permissions(IsAdminOrFieldAgent)

    def get(self, request):
        subscriptions = (_scoped_subscriptions_queryset(request.user)
                         .filter(subscription_status=Subscription.SubscriptionStatus.ACTIVE, customer__approval_status='Approved')
                         .select_related('customer', 'chit_plan')
                         .order_by('-joined_date')[:5])
        serializer = DashboardRecentSubscriptionSerializer(subscriptions, many=True, context={'request': request})
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
        if not employee: return queryset.none()
        if not is_admin_or_subadmin(self.request.user):
            queryset = queryset.filter(created_by=employee)

        chit_plan = self.request.query_params.get('chit_plan')
        if chit_plan: queryset = queryset.filter(subscriptions__chit_plan_id=chit_plan)

        chit_plan_code = self.request.query_params.get('chit_plan_code')
        if chit_plan_code: queryset = queryset.filter(subscriptions__chit_plan__plan_code__icontains=chit_plan_code)

        approval_status = self.request.query_params.get('approval_status')
        if approval_status: queryset = queryset.filter(approval_status=approval_status)

        return queryset.distinct()

    def perform_create(self, serializer):
        serializer.save(created_by=get_employee(self.request.user))
    
    @action(detail=True, methods=['post'])
    def approve(self, request, pk=None):
        """
        Authorization gate allowing Subadmins and root Admins to authorize a pending profile, 
        permanently locking field agent modifications.
        """
        if not is_admin_or_subadmin(request.user):
            raise PermissionDenied("Only administrative or sub-administrative profiles have approval rights.")
        customer = self.get_object()
        customer.approval_status = "Approved"
        customer.edit_enabled = False
        customer.save()
        return Response({"message": "Customer onboarding finalized successfully."})

class HomeAddressViewSet(viewsets.ModelViewSet):
    serializer_class = HomeAddressSerializer
    permission_classes = employee_permissions(IsAdminOrOwnCustomerAddress)

    def get_queryset(self):
        queryset = HomeAddress.objects.select_related('customer', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee: return queryset.none()
        if not is_admin_or_subadmin(self.request.user):
            queryset = queryset.filter(customer__created_by=employee)
        return queryset

class CurrentAddressViewSet(viewsets.ModelViewSet):
    serializer_class = CurrentAddressSerializer
    permission_classes = employee_permissions(IsAdminOrOwnCustomerAddress)

    def get_queryset(self):
        queryset = CurrentAddress.objects.select_related('customer', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee: return queryset.none()
        if not is_admin_or_subadmin(self.request.user):
            queryset = queryset.filter(customer__created_by=employee)
        return queryset

class WorkAddressViewSet(viewsets.ModelViewSet):
    serializer_class = WorkAddressSerializer
    permission_classes = employee_permissions(IsAdminOrOwnCustomerAddress)

    def get_queryset(self):
        queryset = WorkAddress.objects.select_related('customer', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee: return queryset.none()
        if not is_admin_or_subadmin(self.request.user):
            queryset = queryset.filter(customer__created_by=employee)
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
        if not is_admin_or_subadmin(self.request.user):
            queryset = queryset.filter(customer__created_by=employee)
        return queryset

@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def reports_summary(request):
    subscriptions = _scoped_subscriptions_queryset(request.user)
    total_collections = subscriptions.filter(payment_status=Subscription.PaymentStatus.PAID).aggregate(total=Sum('chit_plan__monthly_payment'))['total'] or 0
    new_customers = _scoped_customers_queryset(request.user).count()
    active_chitties = subscriptions.filter(subscription_status=Subscription.SubscriptionStatus.ACTIVE).count()
    pending_payments = subscriptions.filter(payment_status=Subscription.PaymentStatus.PENDING).count()

    return Response({
        "total_collections": float(total_collections), "new_customers": new_customers,
        "active_chitties": active_chitties, "pending_payments": pending_payments,
    })

@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def monthly_collections(request):
    return Response([
        {"month": "Jan", "amount": 12000}, {"month": "Feb", "amount": 18000},
        {"month": "Mar", "amount": 25000}, {"month": "Apr", "amount": 21000},
        {"month": "May", "amount": 30000}, {"month": "Jun", "amount": 28000},
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
    return Response({
        "paid": subscriptions.filter(payment_status=Subscription.PaymentStatus.PAID).count(),
        "pending": subscriptions.filter(payment_status=Subscription.PaymentStatus.PENDING).count(),
        "overdue": subscriptions.filter(payment_status=Subscription.PaymentStatus.OVERDUE).count()
    })

class AgentDashboardAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        employee = Employee.objects.get(user=request.user)
        customers = Customer.objects.filter(created_by=employee)
        subscriptions = Subscription.objects.filter(
            customer__created_by=employee,
            subscription_status='active',
            customer__approval_status='Approved',
        )
        recent_customers = customers.filter(approval_status='Approved').order_by('-created_at')[:5]

        recent_data = []
        for customer in recent_customers:
            latest_sub = customer.subscriptions.first()
            recent_data.append({
                'name': customer.full_name, 'phone': customer.mobile_number,
                'plan': latest_sub.chit_plan.chit_name if latest_sub else '-',
            })

        return Response({
            'total_customers': customers.count(),
            'active_subscriptions': subscriptions.count(),
            'recent_customers': recent_data,
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
        if not is_admin_or_subadmin(self.request.user) and customer.created_by_id != employee.id:
            raise PermissionDenied("You do not have permission to request an edit for this customer.")
        
        if customer.approval_status != "Approved" or customer.edit_enabled:
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
        customer.approval_status = 'Pending'
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
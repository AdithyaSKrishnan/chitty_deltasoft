from datetime import timedelta
from rest_framework.decorators import action
from rest_framework.response import Response
from django.db.models import Sum, Count
from django.utils import timezone
from rest_framework import filters, viewsets
from rest_framework.exceptions import PermissionDenied
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response

from rest_framework.decorators import action
from rest_framework.response import Response
from .models import (
    ChitPlan,
    Customer,
    Employee,
    HomeAddress,
    Subscription,
    CurrentAddress,
    WorkAddress,
)
from .permissions import (
    IsAdminEmployee,
    IsAdminOrFieldAgent,
    IsAdminOrOwnCustomer,
    IsAdminOrOwnCustomerAddress,
    IsAdminOrOwnCustomerSubscription,
    employee_permissions,
    get_employee,
    is_admin,
)
from .serializers import (
    ChitPlanSerializer,
    CustomTokenObtainPairSerializer,
    CustomerSerializer,
    DashboardRecentCustomerSerializer,
    DashboardRecentSubscriptionSerializer,
    EmployeeSerializer,
    HomeAddressSerializer,
    SubscriptionSerializer,
    CurrentAddressSerializer,
    WorkAddressSerializer,
)


class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer
    permission_classes = [AllowAny]


class CustomTokenRefreshView(TokenRefreshView):
    permission_classes = [AllowAny]


def _scoped_customers_queryset(user):
    queryset = Customer.objects.all()
    employee = get_employee(user)
    if not employee:
        return queryset.none()
    if not is_admin(user):
        queryset = queryset.filter(created_by=employee)
    return queryset


def _scoped_subscriptions_queryset(user):
    queryset = Subscription.objects.all()
    employee = get_employee(user)
    if not employee:
        return queryset.none()
    if not is_admin(user):
        queryset = queryset.filter(customer__created_by=employee)
    return queryset


class DashboardStatsAPIView(APIView):
    permission_classes = employee_permissions(IsAdminOrFieldAgent)

    def get(self, request):
        employee = get_employee(request.user)
        if not employee:
            return Response({
                'total_customers': 0,
                'active_subscriptions': 0,
                'monthly_collections_total': 0,
                'pending_payments': 0,
                'active_chit_plans': 0,
                'recent_onboardings': 0,
            })

        customers_qs = _scoped_customers_queryset(request.user)
        subscriptions_qs = _scoped_subscriptions_queryset(request.user)

        active_subscriptions_qs = subscriptions_qs.filter(
            subscription_status=Subscription.SubscriptionStatus.ACTIVE,
        )

        monthly_collections = active_subscriptions_qs.aggregate(
            total=Sum('chit_plan__monthly_payment'),
        )['total'] or 0

        pending_payments = subscriptions_qs.filter(
            payment_status__in=[
                Subscription.PaymentStatus.PENDING,
                Subscription.PaymentStatus.OVERDUE,
            ],
        ).count()

        seven_days_ago = timezone.now() - timedelta(days=7)
        recent_onboardings = customers_qs.filter(created_at__gte=seven_days_ago).count()

        return Response({
            'total_customers': customers_qs.count(),
            'active_subscriptions': active_subscriptions_qs.count(),
            'monthly_collections_total': float(monthly_collections),
            'pending_payments': pending_payments,
            'active_chit_plans': ChitPlan.objects.filter(is_active=True).count(),
            'recent_onboardings': recent_onboardings,
        })


class DashboardRecentCustomersAPIView(APIView):
    permission_classes = employee_permissions(IsAdminOrFieldAgent)

    def get(self, request):
        customers = _scoped_customers_queryset(request.user).order_by('-created_at')[:5]
        serializer = DashboardRecentCustomerSerializer(customers, many=True)
        return Response(serializer.data)


class DashboardRecentSubscriptionsAPIView(APIView):
    permission_classes = employee_permissions(IsAdminOrFieldAgent)

    def get(self, request):
        subscriptions = (
            _scoped_subscriptions_queryset(request.user)
            .filter(subscription_status=Subscription.SubscriptionStatus.ACTIVE)
            .select_related('customer', 'chit_plan')
            .order_by('-joined_date')[:5]
        )
        serializer = DashboardRecentSubscriptionSerializer(subscriptions, many=True)
        return Response(serializer.data)


class EmployeeViewSet(viewsets.ModelViewSet):
    queryset = Employee.objects.select_related('user').all()
    serializer_class = EmployeeSerializer
    permission_classes = employee_permissions(IsAdminEmployee)
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = [
        'employee_id',
        'user__username',
        'user__first_name',
        'user__last_name'
    ]
    ordering_fields = ['employee_id', 'role']

    @action(detail=True, methods=['post'])
    def toggle_status(self, request, pk=None):

        employee = self.get_object()

        employee.user.is_active = (
            not employee.user.is_active
        )

        employee.user.save()

        return Response({
            'success': True,
            'is_active': employee.user.is_active,
        })


class CustomerViewSet(viewsets.ModelViewSet):
    serializer_class = CustomerSerializer
    permission_classes = employee_permissions(IsAdminOrFieldAgent, IsAdminOrOwnCustomer)
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['customer_id', 'full_name', 'mobile_number']
    ordering_fields = ['created_at', 'customer_id', 'full_name']

    def get_queryset(self):
        queryset = Customer.objects.select_related(
    'created_by',
    'created_by__user',
    'home_address',
    'current_address',
    'work_address',
).prefetch_related(
    'subscriptions__chit_plan',
)

        employee = get_employee(self.request.user)
        if not employee:
            return queryset.none()
        if not is_admin(self.request.user):
            queryset = queryset.filter(created_by=employee)

        chit_plan = self.request.query_params.get('chit_plan')
        if chit_plan:
            queryset = queryset.filter(subscriptions__chit_plan_id=chit_plan)

        chit_plan_code = self.request.query_params.get('chit_plan_code')
        if chit_plan_code:
            queryset = queryset.filter(
                subscriptions__chit_plan__plan_code__icontains=chit_plan_code
            )

        return queryset.distinct()

    def perform_create(self, serializer):
        serializer.save(created_by=get_employee(self.request.user))
    
    @action(detail=True, methods=['post'])
    def approve(self, request, pk=None):

        customer = self.get_object()

        customer.approval_status = "Approved"
        customer.edit_enabled = False

        customer.save()

        return Response({
            "message": "Customer approved successfully"
    })

class HomeAddressViewSet(viewsets.ModelViewSet):
    serializer_class = HomeAddressSerializer
    permission_classes = employee_permissions(IsAdminOrOwnCustomerAddress)
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = [
        'customer__customer_id',
        'customer__full_name',
        'village',
        'district',
        'pincode',
    ]

    def get_queryset(self):
        queryset = HomeAddress.objects.select_related('customer', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee:
            return queryset.none()
        if not is_admin(self.request.user):
            queryset = queryset.filter(customer__created_by=employee)

        customer_id = self.request.query_params.get('customer')
        if customer_id:
            queryset = queryset.filter(customer_id=customer_id)

        return queryset

    def perform_create(self, serializer):
        customer = serializer.validated_data['customer']
        employee = get_employee(self.request.user)
        if not is_admin(self.request.user) and customer.created_by_id != employee.id:
            raise PermissionDenied('You can only add addresses for your own customers.')
        serializer.save()

class CurrentAddressViewSet(viewsets.ModelViewSet):
    serializer_class = CurrentAddressSerializer
    permission_classes = employee_permissions(IsAdminOrOwnCustomerAddress)
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = [
        'customer__customer_id',
        'customer__full_name',
        'village',
        'district',
        'pincode',
    ]

    def get_queryset(self):
        queryset = CurrentAddress.objects.select_related('customer', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee:
            return queryset.none()
        if not is_admin(self.request.user):
            queryset = queryset.filter(customer__created_by=employee)

        customer_id = self.request.query_params.get('customer')
        if customer_id:
            queryset = queryset.filter(customer_id=customer_id)

        return queryset

    def perform_create(self, serializer):
        customer = serializer.validated_data['customer']
        employee = get_employee(self.request.user)
        if not is_admin(self.request.user) and customer.created_by_id != employee.id:
            raise PermissionDenied('You can only add addresses for your own customers.')
        serializer.save()

class WorkAddressViewSet(viewsets.ModelViewSet):
    serializer_class = WorkAddressSerializer
    permission_classes = employee_permissions(IsAdminOrOwnCustomerAddress)
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = [
        'customer__customer_id',
        'customer__full_name',
        'village',
        'district',
        'pincode',
    ]

    def get_queryset(self):
        queryset = WorkAddress.objects.select_related('customer', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee:
            return queryset.none()
        if not is_admin(self.request.user):
            queryset = queryset.filter(customer__created_by=employee)

        customer_id = self.request.query_params.get('customer')
        if customer_id:
            queryset = queryset.filter(customer_id=customer_id)

        return queryset

    def perform_create(self, serializer):
        customer = serializer.validated_data['customer']
        employee = get_employee(self.request.user)
        if not is_admin(self.request.user) and customer.created_by_id != employee.id:
            raise PermissionDenied('You can only add addresses for your own customers.')
        serializer.save()


class ChitPlanViewSet(viewsets.ModelViewSet):
    serializer_class = ChitPlanSerializer
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['plan_code', 'chit_name']
    ordering_fields = ['plan_code', 'created_at', 'total_amount']

    def get_permissions(self):
        if self.action in ('create', 'update', 'partial_update', 'destroy'):
            return [permission() for permission in employee_permissions(IsAdminEmployee)]
        return [permission() for permission in employee_permissions()]

    def get_queryset(self):
        queryset = ChitPlan.objects.all()
        if not is_admin(self.request.user):
            queryset = queryset.filter(is_active=True)

        is_active = self.request.query_params.get('is_active')
        if is_active is not None and is_admin(self.request.user):
            queryset = queryset.filter(is_active=is_active.lower() in ('true', '1', 'yes'))

        return queryset


class SubscriptionViewSet(viewsets.ModelViewSet):
    serializer_class = SubscriptionSerializer
    permission_classes = employee_permissions(
        IsAdminOrFieldAgent,
        IsAdminOrOwnCustomerSubscription,
    )
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = [
        'customer__customer_id',
        'customer__full_name',
        'customer__mobile_number',
        'chit_plan__plan_code',
        'chit_plan__chit_name',
    ]
    ordering_fields = ['joined_date', 'payment_status', 'subscription_status']

    def get_queryset(self):
        queryset = Subscription.objects.select_related(
            'customer',
            'chit_plan',
            'customer__created_by',
        )

        employee = get_employee(self.request.user)
        if not employee:
            return queryset.none()
        if not is_admin(self.request.user):
            queryset = queryset.filter(customer__created_by=employee)

        customer = self.request.query_params.get('customer')
        if customer:
            queryset = queryset.filter(customer_id=customer)

        chit_plan = self.request.query_params.get('chit_plan')
        if chit_plan:
            queryset = queryset.filter(chit_plan_id=chit_plan)

        chit_plan_code = self.request.query_params.get('chit_plan_code')
        if chit_plan_code:
            queryset = queryset.filter(chit_plan__plan_code__icontains=chit_plan_code)

        payment_status = self.request.query_params.get('payment_status')
        if payment_status:
            queryset = queryset.filter(payment_status=payment_status)

        subscription_status = self.request.query_params.get('subscription_status')
        if subscription_status:
            queryset = queryset.filter(subscription_status=subscription_status)

        return queryset
    
@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def reports_summary(request):

    subscriptions = _scoped_subscriptions_queryset(request.user)

    total_collections = subscriptions.filter(
        payment_status=Subscription.PaymentStatus.PAID
    ).aggregate(
        total=Sum('chit_plan__monthly_payment')
    )['total'] or 0

    new_customers = _scoped_customers_queryset(request.user).count()

    active_chitties = subscriptions.filter(
        subscription_status=Subscription.SubscriptionStatus.ACTIVE
    ).count()

    pending_payments = subscriptions.filter(
        payment_status=Subscription.PaymentStatus.PENDING
    ).count()

    return Response({
        "total_collections": float(total_collections),
        "new_customers": new_customers,
        "active_chitties": active_chitties,
        "pending_payments": pending_payments,
    })


@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def monthly_collections(request):

    data = [
        {"month": "Jan", "amount": 12000},
        {"month": "Feb", "amount": 18000},
        {"month": "Mar", "amount": 25000},
        {"month": "Apr", "amount": 21000},
        {"month": "May", "amount": 30000},
        {"month": "Jun", "amount": 28000},
    ]

    return Response(data)


@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def plan_distribution(request):

    plans = ChitPlan.objects.annotate(
        customer_count=Count('subscriptions')
    )

    result = []

    for plan in plans:
        result.append({
            "plan": plan.chit_name,
            "customers": plan.customer_count
        })

    return Response(result)


@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def payment_overview(request):

    subscriptions = _scoped_subscriptions_queryset(request.user)

    paid = subscriptions.filter(
        payment_status=Subscription.PaymentStatus.PAID
    ).count()

    pending = subscriptions.filter(
        payment_status=Subscription.PaymentStatus.PENDING
    ).count()

    overdue = subscriptions.filter(
        payment_status=Subscription.PaymentStatus.OVERDUE
    ).count()

    return Response({
        "paid": paid,
        "pending": pending,
        "overdue": overdue
    })
class AgentDashboardAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        employee = Employee.objects.get(
            user=request.user,
        )

        customers = Customer.objects.filter(
            created_by=employee
        )

        subscriptions = Subscription.objects.filter(
            customer__created_by=employee,
            subscription_status='active',
        )

        recent_customers = customers.order_by(
            '-created_at'
        )[:5]


        recent_data = []

        for customer in recent_customers:
            latest_sub = customer.subscriptions.first()

            recent_data.append({
                'name': customer.full_name,
                'phone': customer.mobile_number,
                'plan': (
                    latest_sub.chit_plan.chit_name
                    if latest_sub
                    else '-'
                ),
            })

        return Response({
            'total_customers': customers.count(),
            'active_subscriptions':
                subscriptions.count(),
            'recent_customers':
                recent_data,
        })
from django.urls import include, path
from rest_framework.routers import DefaultRouter
from .views import (
    ChitPlanViewSet,
    CustomTokenObtainPairView,
    CustomTokenRefreshView,
    CustomerViewSet,
    DashboardRecentCustomersAPIView,
    DashboardRecentSubscriptionsAPIView,
    DashboardStatsAPIView,
    EmployeeViewSet,
    HomeAddressViewSet,
    SubscriptionViewSet,
    CurrentAddressViewSet,
    WorkAddressViewSet,
    AgentDashboardAPIView,
    reports_summary,
    monthly_collections,
    plan_distribution,
    payment_overview,
)

    


router = DefaultRouter()
router.register('employees', EmployeeViewSet, basename='employee')
router.register('customers', CustomerViewSet, basename='customer')
router.register('home-addresses', HomeAddressViewSet, basename='home-address')
router.register(
    'current-addresses',
    CurrentAddressViewSet,
    basename='current-address',
)
router.register('work-addresses', WorkAddressViewSet, basename='work-address')
router.register('chit-plans', ChitPlanViewSet, basename='chit-plan')
router.register('subscriptions', SubscriptionViewSet, basename='subscription')

urlpatterns = [
    path('token/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', CustomTokenRefreshView.as_view(), name='token_refresh'),
    path('dashboard/stats/', DashboardStatsAPIView.as_view(), name='dashboard-stats'),
    path(
    'agent-dashboard/',
    AgentDashboardAPIView.as_view(),
    name='agent-dashboard',
),
    path(
        'dashboard/recent-customers/',
        DashboardRecentCustomersAPIView.as_view(),
        name='dashboard-recent-customers',
    ),
    path(
        'dashboard/recent-subscriptions/',
        DashboardRecentSubscriptionsAPIView.as_view(),
        name='dashboard-recent-subscriptions',
    ),
    path('reports/summary/', reports_summary),

    path('reports/monthly-collections/', monthly_collections),

    path('reports/plan-distribution/', plan_distribution),

    path('reports/payment-overview/', payment_overview),

    path('', include(router.urls)),
]

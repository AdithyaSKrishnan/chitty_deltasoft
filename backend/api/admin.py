from django.contrib import admin

from .models import (
    ChitPlan,
    Customer,
    Employee,
    HomeAddress,
    Subscription,
    WorkAddress,
)


@admin.register(Employee)
class EmployeeAdmin(admin.ModelAdmin):
    list_display = ('employee_id', 'user', 'role')
    list_filter = ('role',)
    search_fields = ('employee_id', 'user__username', 'user__first_name', 'user__last_name')


@admin.register(Customer)
class CustomerAdmin(admin.ModelAdmin):
    list_display = ('customer_id', 'full_name', 'mobile_number', 'created_by', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('customer_id', 'full_name', 'mobile_number', 'email')


class AddressAdmin(admin.ModelAdmin):
    list_display = ('customer', 'village', 'district', 'pincode')
    search_fields = ('customer__customer_id', 'customer__full_name', 'village', 'district')


@admin.register(HomeAddress)
class HomeAddressAdmin(AddressAdmin):
    pass


@admin.register(WorkAddress)
class WorkAddressAdmin(AddressAdmin):
    pass


@admin.register(ChitPlan)
class ChitPlanAdmin(admin.ModelAdmin):
    list_display = (
        'plan_code',
        'chit_name',
        'total_amount',
        'monthly_payment',
        'is_active',
        'created_at',
    )
    list_filter = ('is_active',)
    search_fields = ('plan_code', 'chit_name')


@admin.register(Subscription)
class SubscriptionAdmin(admin.ModelAdmin):
    list_display = (
        'customer',
        'chit_plan',
        'payment_status',
        'subscription_status',
        'joined_date',
    )
    list_filter = ('payment_status', 'subscription_status', 'joined_date')
    search_fields = ('customer__customer_id', 'customer__full_name', 'chit_plan__plan_code')

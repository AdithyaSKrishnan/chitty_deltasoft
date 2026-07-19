### File: backend/api/permissions.py
from rest_framework.permissions import SAFE_METHODS, BasePermission, IsAuthenticated
from .models import Employee


def employee_permissions(*extra):
    return [IsAuthenticated, IsActiveUser, IsEmployee, *extra]


def get_employee(user):
    if not user or not user.is_authenticated:
        return None
    return getattr(user, 'employee_profile', None)


def is_admin_or_subadmin(user):
    employee = get_employee(user)
    return employee is not None and employee.role in (Employee.Role.ADMIN, Employee.Role.SUBADMIN)


class IsActiveUser(BasePermission):
    message = 'User account is disabled.'

    def has_permission(self, request, view):
        return bool(request.user and request.user.is_authenticated and request.user.is_active)


class IsAdminEmployee(BasePermission):
    """Allows Admin or Subadmin to access employee management workspace fields."""
    message = 'Administrative access required.'

    def has_permission(self, request, view):
        return is_admin_or_subadmin(request.user)


class IsEmployee(BasePermission):
    message = 'Employee profile required.'

    def has_permission(self, request, view):
        return get_employee(request.user) is not None


class IsAdminOrFieldAgent(BasePermission):
    message = 'Employee access required.'

    def has_permission(self, request, view):
        employee = get_employee(request.user)
        return employee is not None and employee.role in (
            Employee.Role.ADMIN,
            Employee.Role.SUBADMIN,
            Employee.Role.FIELD_AGENT,
        )


class IsAdminOrOwnCustomer(BasePermission):
    message = 'You do not have permission to access this customer.'

    def has_permission(self, request, view):
        if not get_employee(request.user):
            return False
        return True

    def has_object_permission(self, request, view, obj):
        if is_admin_or_subadmin(request.user):
            return True
        
        employee = get_employee(request.user)
        if employee is not None and obj.created_by_id == employee.id:
            # Post-approval fallback lockout validation rules for Agents
            if request.method not in SAFE_METHODS and (obj.approval_status == "Approved" and not obj.edit_enabled):
                return False
            return True
        return False


class IsAdminOrOwnCustomerAddress(BasePermission):
    message = 'You do not have permission to access this address.'

    def has_permission(self, request, view):
        return get_employee(request.user) is not None

    def has_object_permission(self, request, view, obj):
        if is_admin_or_subadmin(request.user):
            return True
        employee = get_employee(request.user)
        if employee is not None and obj.customer.created_by_id == employee.id:
            if request.method not in SAFE_METHODS and (obj.customer.approval_status == "Approved" and not obj.customer.edit_enabled):
                return False
            return True
        return False


class IsAdminOrOwnCustomerSubscription(BasePermission):
    message = 'You do not have permission to access this subscription.'

    def has_permission(self, request, view):
        employee = get_employee(request.user)
        if not employee:
            return False
        return True

    def has_object_permission(self, request, view, obj):
        if is_admin_or_subadmin(request.user):
            return True
        employee = get_employee(request.user)
        return employee is not None and obj.customer.created_by_id == employee.id
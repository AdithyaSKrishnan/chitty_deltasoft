from rest_framework.permissions import SAFE_METHODS, BasePermission, IsAuthenticated

from .models import Employee


def employee_permissions(*extra):
    """Base API permissions: authenticated, active user with employee profile."""
    return [IsAuthenticated, IsActiveUser, IsEmployee, *extra]


def get_employee(user):
    if not user or not user.is_authenticated:
        return None
    return getattr(user, 'employee_profile', None)


def is_admin(user):
    employee = get_employee(user)
    return employee is not None and employee.role == Employee.Role.ADMIN


class IsActiveUser(BasePermission):
    """Deny API access to inactive Django users."""

    message = 'User account is disabled.'

    def has_permission(self, request, view):
        return (
            request.user
            and request.user.is_authenticated
            and request.user.is_active
        )


class IsAdminEmployee(BasePermission):
    """Only Admin role employees."""

    message = 'Admin access required.'

    def has_permission(self, request, view):
        return is_admin(request.user)


class IsEmployee(BasePermission):
    """User must have a linked Employee profile."""

    message = 'Employee profile required.'

    def has_permission(self, request, view):
        return get_employee(request.user) is not None


class IsAdminOrFieldAgent(BasePermission):
    """Admin or Field Agent employees."""

    message = 'Employee access required.'

    def has_permission(self, request, view):
        employee = get_employee(request.user)
        return employee is not None and employee.role in (
            Employee.Role.ADMIN,
            Employee.Role.FIELD_AGENT,
        )


class IsAdminOrOwnCustomer(BasePermission):
    """
    Admins: full access.
    Field Agents: create allowed; object access only for customers they created.
    """

    message = 'You do not have permission to access this customer.'

    def has_permission(self, request, view):
        if not get_employee(request.user):
            return False
        if request.method in SAFE_METHODS or request.method == 'POST':
            return is_admin(request.user) or get_employee(request.user).role == Employee.Role.FIELD_AGENT
        return True

    def has_object_permission(self, request, view, obj):
        if is_admin(request.user):
            return True
        employee = get_employee(request.user)
        return employee is not None and obj.created_by_id == employee.id


class IsAdminOrOwnCustomerAddress(BasePermission):
    """Address access follows parent customer ownership."""

    message = 'You do not have permission to access this address.'

    def has_permission(self, request, view):
        return get_employee(request.user) is not None

    def has_object_permission(self, request, view, obj):
        if is_admin(request.user):
            return True
        employee = get_employee(request.user)
        return employee is not None and obj.customer.created_by_id == employee.id


class IsAdminOrOwnCustomerSubscription(BasePermission):
    """Subscription access follows customer ownership for Field Agents."""

    message = 'You do not have permission to access this subscription.'

    def has_permission(self, request, view):
        employee = get_employee(request.user)
        if not employee:
            return False
        if request.method == 'POST':
            return employee.role in (Employee.Role.ADMIN, Employee.Role.FIELD_AGENT)
        return True

    def has_object_permission(self, request, view, obj):
        if is_admin(request.user):
            return True
        employee = get_employee(request.user)
        return employee is not None and obj.customer.created_by_id == employee.id

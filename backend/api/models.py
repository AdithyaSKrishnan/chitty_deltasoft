from django.conf import settings
from django.db import models


def _next_sequential_code(prefix, model, field_name, start=1001):
    """Generate the next ID like CUST-1001 or EMP-1001."""
    codes = model.objects.values_list(field_name, flat=True)
    max_num = start - 1
    for code in codes:
        if not code or not code.startswith(f'{prefix}-'):
            continue
        try:
            max_num = max(max_num, int(code.split('-', 1)[1]))
        except (IndexError, ValueError):
            continue
    return f'{prefix}-{max_num + 1}'


class Employee(models.Model):
    class Role(models.TextChoices):
        ADMIN = 'admin', 'Admin'
        FIELD_AGENT = 'field_agent', 'Field Agent'

    employee_id = models.CharField(max_length=20, unique=True, editable=False)
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='employee_profile',
    )
    role = models.CharField(max_length=20, choices=Role.choices)

    phone_number = models.CharField(
        max_length=15,
        blank=True,
    )

    class Meta:
        ordering = ['employee_id']

    def __str__(self):
        return f'{self.employee_id} — {self.user.get_full_name() or self.user.username} ({self.get_role_display()})'

    def save(self, *args, **kwargs):
        if not self.employee_id:
            self.employee_id = _next_sequential_code('EMP', Employee, 'employee_id')
        super().save(*args, **kwargs)


class Customer(models.Model):
    
    customer_id = models.CharField(max_length=20, unique=True, editable=False)
    full_name = models.CharField(max_length=255)
    mobile_number = models.CharField(max_length=15)
    alternate_number = models.CharField(max_length=15, blank=True)
    email = models.EmailField(blank=True)
    customer_type = models.CharField(
    max_length=100,
    default="Customer",
)
    approval_status = models.CharField(
    max_length=20,
    default="Pending",
)

    edit_enabled = models.BooleanField(
    default=True,
)
    created_by = models.ForeignKey(
        Employee,
        on_delete=models.PROTECT,
        related_name='customers_created',
    )
    created_at = models.DateTimeField(auto_now_add=True)
    customer_photo = models.ImageField(
    upload_to='customers/',
    blank=True,
    null=True
)
    address_proof = models.ImageField(
    upload_to='customers/',
    blank=True,
    null=True
)
    id_proof = models.ImageField(
    upload_to='customers/',
    blank=True,
    null=True
)
    @property
    def kyc_status(self):
        if (
            self.customer_photo and
            self.address_proof and
            self.id_proof
        ):
            return "Completed"

        return "Pending"

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.customer_id} — {self.full_name}'

    def save(self, *args, **kwargs):
        if not self.customer_id:
            self.customer_id = _next_sequential_code('CUST', Customer, 'customer_id')
        super().save(*args, **kwargs)


class AddressMixin(models.Model):
    house_name = models.CharField(max_length=255, blank=True)
    building_name = models.CharField(max_length=255, blank=True)
    landmark = models.CharField(max_length=255, blank=True)
    village = models.CharField(max_length=255, blank=True)
    taluk = models.CharField(max_length=255, blank=True)
    district = models.CharField(max_length=255, blank=True)
    state = models.CharField(max_length=255, blank=True)
    pincode = models.CharField(max_length=10, blank=True)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    google_maps_link = models.URLField(max_length=500, blank=True)
    address_photo = models.ImageField(upload_to='addresses/', blank=True)

    class Meta:
        abstract = True

    def _build_google_maps_link(self):
        if self.latitude is not None and self.longitude is not None:
            return f'https://www.google.com/maps?q={self.latitude},{self.longitude}'
        return ''

    def save(self, *args, **kwargs):
        self.google_maps_link = self._build_google_maps_link()
        super().save(*args, **kwargs)


class HomeAddress(AddressMixin):
    customer = models.OneToOneField(
        Customer,
        on_delete=models.CASCADE,
        related_name='home_address',
    )

    def __str__(self):
        parts = [p for p in (self.house_name, self.village, self.district) if p]
        label = ', '.join(parts) if parts else 'No address details'
        return f'Home — {self.customer.customer_id}: {label}'
class CurrentAddress(AddressMixin):
    customer = models.OneToOneField(
        Customer,
        on_delete=models.CASCADE,
        related_name='current_address',
    )

    def __str__(self):
        parts = [
            p for p in (
                self.house_name,
                self.village,
                self.district,
            ) if p
        ]
        label = ', '.join(parts) if parts else 'No address details'
        return f'Current — {self.customer.customer_id}: {label}'


class WorkAddress(AddressMixin):
    customer = models.OneToOneField(
        Customer,
        on_delete=models.CASCADE,
        related_name='work_address',
    )

    def __str__(self):
        parts = [p for p in (self.building_name, self.village, self.district) if p]
        label = ', '.join(parts) if parts else 'No address details'
        return f'Work — {self.customer.customer_id}: {label}'


class ChitPlan(models.Model):
    plan_code = models.CharField(max_length=50, unique=True)
    chit_name = models.CharField(max_length=255)
    total_amount = models.DecimalField(max_digits=12, decimal_places=2)
    number_of_installments = models.PositiveIntegerField()
    monthly_payment = models.DecimalField(max_digits=12, decimal_places=2)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['plan_code']

    def __str__(self):
        return f'{self.plan_code} — {self.chit_name}'


class Subscription(models.Model):
    class PaymentStatus(models.TextChoices):
        PENDING = 'pending', 'Pending'
        PARTIAL = 'partial', 'Partial'
        PAID = 'paid', 'Paid'
        OVERDUE = 'overdue', 'Overdue'

    class SubscriptionStatus(models.TextChoices):
        ACTIVE = 'active', 'Active'
        COMPLETED = 'completed', 'Completed'
        CANCELLED = 'cancelled', 'Cancelled'
        SUSPENDED = 'suspended', 'Suspended'

    customer = models.ForeignKey(
        Customer,
        on_delete=models.CASCADE,
        related_name='subscriptions',
    )
    chit_plan = models.ForeignKey(
        ChitPlan,
        on_delete=models.PROTECT,
        related_name='subscriptions',
    )
    payment_status = models.CharField(
        max_length=20,
        choices=PaymentStatus.choices,
        default=PaymentStatus.PENDING,
    )
    subscription_status = models.CharField(
        max_length=20,
        choices=SubscriptionStatus.choices,
        default=SubscriptionStatus.ACTIVE,
    )
    joined_date = models.DateField()

    class Meta:
        ordering = ['-joined_date']
        constraints = [
            models.UniqueConstraint(
                fields=['customer', 'chit_plan'],
                name='unique_customer_chit_plan',
            ),
        ]

    def __str__(self):
        return f'{self.customer.customer_id} → {self.chit_plan.plan_code} ({self.get_subscription_status_display()})'

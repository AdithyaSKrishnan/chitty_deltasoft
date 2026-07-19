### File: backend/api/models.py
from django.conf import settings
from django.db import models


def _next_sequential_code(prefix, model, field_name, start=1001):
    """
    Utility helper to compute and return the next sequential alphanumeric identifier
    for tracking records natively (e.g., CUST-1001, EMP-1001)[cite: 334, 360].
    
    Iterates through existing db column records to safely extract and increment 
    the numerical suffix independently[cite: 334].
    """
    codes = model.objects.values_list(field_name, flat=True)
    max_num = start - 1
    for code in codes:
        if not code or not code.startswith(f'{prefix}-'):
            continue
        try:
            # Split off the prefix string to isolate and parse the trailing integer
            max_num = max(max_num, int(code.split('-', 1)[1]))
        except (IndexError, ValueError):
            continue
    return f'{prefix}-{max_num + 1}'


class Employee(models.Model):
    """
    Core human resource profile linking a standard Django Auth User to an operational 
    internal corporate access tier role matrix[cite: 335, 351, 355].
    """
    class Role(models.TextChoices):
        ADMIN = 'admin', 'Admin'
        SUBADMIN = 'subadmin', 'Subadmin'  # Added role for functional admin equivalence 
        FIELD_AGENT = 'field_agent', 'Field Agent'

    # Alphanumeric primary tracking key generated programmatically on initial save
    employee_id = models.CharField(max_length=20, unique=True, editable=False)
    
    # One-to-One strict bridge to the root authenticated django user configuration model
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='employee_profile',
    )
    
    # RBAC context choice selector determining global permission boundaries
    role = models.CharField(max_length=20, choices=Role.choices)
    phone_number = models.CharField(max_length=15, blank=True)

    class Meta:
        ordering = ['employee_id']

    def __str__(self):
        return f'{self.employee_id} — {self.user.get_full_name() or self.user.username} ({self.get_role_display()})'

    def save(self, *args, **kwargs):
        # Programmatically assign an EMP identification string sequence if absent
        if not self.employee_id:
            self.employee_id = _next_sequential_code('EMP', Employee, 'employee_id')
        super().save(*args, **kwargs)


class Customer(models.Model):
    """
    Master business client table containing KYC metadata hooks, creation tracking metrics, 
    and systemic operational state block states[cite: 336, 337, 350].
    """
    customer_id = models.CharField(max_length=20, unique=True, editable=False)
    full_name = models.CharField(max_length=255)
    mobile_number = models.CharField(max_length=15)
    alternate_number = models.CharField(max_length=15, blank=True)
    email = models.EmailField(blank=True)
    
    # Categorization classification metric (e.g., Customer, Agent, Guarantor)
    customer_type = models.CharField(max_length=100, default="Customer")
    
    # Operational workflow control state verifying administrative authorization
    approval_status = models.CharField(max_length=20, default="Pending")

    # Safety structural flag toggled to False post-approval to lockout Agent mutations
    edit_enabled = models.BooleanField(default=True)
    
    # Linked tracking pointer mapping who originally onboarded the client
    created_by = models.ForeignKey(
        Employee,
        on_delete=models.PROTECT,
        related_name='customers_created',
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    # Binary/Image document asset verification storage locations
    customer_photo = models.ImageField(upload_to='customers/', blank=True, null=True)
    address_proof = models.ImageField(upload_to='customers/', blank=True, null=True)
    id_proof = models.ImageField(upload_to='customers/', blank=True, null=True)

    @property
    def kyc_status(self):
        """
        Evaluates presence of physical file documents to return structural state status[cite: 337, 338].
        """
        if self.customer_photo and self.address_proof and self.id_proof:
            return "Completed"
        return "Pending"

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.customer_id} — {self.full_name}'

    def save(self, *args, **kwargs):
        # Auto capitalize the first letter of each name word
        if self.full_name:
            self.full_name = ' '.join(word[0].upper() + word[1:] if word else '' for word in self.full_name.split())
        
        # Programmatically assign a CUST identification string sequence if absent
        if not self.customer_id:
            self.customer_id = _next_sequential_code('CUST', Customer, 'customer_id')
        super().save(*args, **kwargs)


class AddressMixin(models.Model):
    """
    Polymorphic structural base abstract class encapsulating spatial mapping coordinates 
    and geographic address descriptor parameter definitions[cite: 339, 341, 358].
    """
    house_name = models.CharField(max_length=255, blank=True)
    building_name = models.CharField(max_length=255, blank=True)
    landmark = models.CharField(max_length=255, blank=True)
    village = models.CharField(max_length=255, blank=True)
    taluk = models.CharField(max_length=255, blank=True)
    district = models.CharField(max_length=255, blank=True)
    state = models.CharField(max_length=255, blank=True)
    pincode = models.CharField(max_length=10, blank=True)
    
    # High-precision hardware GPS coordinates mapping vectors
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    
    # Custom computed url query link string pointing into the Google Maps rendering portal
    google_maps_link = models.URLField(max_length=500, blank=True)
    address_photo = models.ImageField(upload_to='addresses/', blank=True)

    class Meta:
        abstract = True

    def _build_google_maps_link(self):
        """
        Natively constructs an external redirect coordinate map tracking string[cite: 341, 359].
        """
        if self.latitude is not None and self.longitude is not None:
            return f'https://www.google.com/maps?q={self.latitude},{self.longitude}'
        return ''

    def save(self, *args, **kwargs):
        # Automate web client redirect formatting computations before commit pipelines execute
        self.google_maps_link = self._build_google_maps_link()
        super().save(*args, **kwargs)


class HomeAddress(AddressMixin):
    """
    One-to-One linked sub-table mapping the client's domestic primary residential address[cite: 341, 358].
    """
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
    """
    One-to-One linked sub-table mapping the client's contemporary localized temporary stay[cite: 342, 358].
    """
    customer = models.OneToOneField(
        Customer,
        on_delete=models.CASCADE,
        related_name='current_address',
    )

    def __str__(self):
        parts = [p for p in (self.house_name, self.village, self.district) if p]
        label = ', '.join(parts) if parts else 'No address details'
        return f'Current — {self.customer.customer_id}: {label}'


class WorkAddress(AddressMixin):
    """
    One-to-One linked sub-table mapping the client's employment facility geographic location[cite: 344, 358].
    """
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
    """
    Chit fund product master sheet defining capital amounts, tenure durations, 
    and installment metric configurations[cite: 344, 350, 360].
    """
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
    """
    Relational junction mapping instance context connecting a specific Customer 
    to an active investment saving ChitPlan structure[cite: 345, 346, 360].
    """
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
        
        # Enforce uniqueness constraints to block duplicate plan subscriptions per user
        constraints = [
            models.UniqueConstraint(
                fields=['customer', 'chit_plan'],
                name='unique_customer_chit_plan',
            ),
        ]

    def __str__(self):
        return f'{self.customer.customer_id} → {self.chit_plan.plan_code} ({self.get_subscription_status_display()})'


class CustomerEditRequest(models.Model):
    class RequestStatus(models.TextChoices):
        PENDING = 'Pending', 'Pending'
        APPROVED = 'Approved', 'Approved'
        REJECTED = 'Rejected', 'Rejected'

    customer = models.ForeignKey(
        Customer,
        on_delete=models.CASCADE,
        related_name='edit_requests',
    )
    requested_by = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        related_name='edit_requests_created',
    )
    reason = models.TextField()
    status = models.CharField(
        max_length=20,
        choices=RequestStatus.choices,
        default=RequestStatus.PENDING,
    )
    created_at = models.DateTimeField(auto_now_add=True)
    
    resolved_by = models.ForeignKey(
        Employee,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='edit_requests_resolved',
    )
    resolved_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Request for {self.customer.full_name} by {self.requested_by.employee_id} ({self.status})"
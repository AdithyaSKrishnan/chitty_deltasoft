### File: backend/api/serializers.py
import json
from django.contrib.auth import get_user_model
from rest_framework import serializers
from rest_framework.exceptions import AuthenticationFailed
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import (
    ChitPlan, Customer, Employee, HomeAddress, Subscription, WorkAddress, CurrentAddress, CustomerEditRequest
)
from .permissions import get_employee, is_admin_or_subadmin

User = get_user_model()

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    """
    Intercepts standard login authorization routines to append role tracking properties 
    and employee mapping structures directly onto Token response data envelopes.
    """
    def validate(self, attrs):
        data = super().validate(attrs)
        user = self.user

        if not user.is_active:
            raise AuthenticationFailed('User account is disabled.')

        employee = get_employee(user)
        if employee is None:
            raise AuthenticationFailed('No corporate employee profile associated with this account.')

        # Extract context parameter payloads natively
        data['employee_id'] = employee.employee_id
        data['role'] = employee.role
        data['role_display'] = employee.get_role_display()
        return data

    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        employee = get_employee(user)
        if employee:
            token['employee_id'] = employee.employee_id
            token['role'] = employee.role
        return token

class EmployeeSerializer(serializers.ModelSerializer):
    """
    Converts and sanitizes Employee and core operational User records.
    Explicitly drops requests provisioning new absolute 'admin' profiles.
    """
    username = serializers.CharField(write_only=True, required=False)
    password = serializers.CharField(write_only=True, required=False)
    email = serializers.EmailField(write_only=True, required=False)
    full_name = serializers.CharField(write_only=True, required=False)
    phone_number = serializers.CharField(required=False, allow_blank=True)
    username_display = serializers.CharField(source='user.username', read_only=True)
    email_display = serializers.EmailField(source='user.email', read_only=True)
    customer_count = serializers.SerializerMethodField()
    is_active = serializers.BooleanField(source='user.is_active', read_only=True)
    full_name_display = serializers.SerializerMethodField()

    class Meta:
        model = Employee
        fields = [
            'id', 'employee_id', 'full_name', 'username', 'email', 'password',
            'phone_number', 'role', 'username_display', 'email_display',
            'customer_count', 'is_active', 'full_name_display',
        ]
        read_only_fields = ['employee_id']

    def validate_role(self, value):
        """
        Structural safety blocker ensuring new profiles cannot assume 
        absolute root 'admin' access level privileges.
        """
        if value == Employee.Role.ADMIN:
            raise serializers.ValidationError("Creating new root Admin profiles is disabled.")
        return value

    def create(self, validated_data):
        username = validated_data.pop('username')
        password = validated_data.pop('password')
        email = validated_data.pop('email')
        full_name = validated_data.pop('full_name')
        phone_number = validated_data.pop('phone_number', '')
        
        names = full_name.split(' ', 1)
        first_name = names[0]
        last_name = names[1] if len(names) > 1 else ''

        user = User.objects.create_user(
            username=username, email=email, password=password,
            first_name=first_name, last_name=last_name,
        )
        return Employee.objects.create(user=user, phone_number=phone_number, **validated_data)

    def get_customer_count(self, obj):
        return obj.customers_created.count()

    def get_full_name_display(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}".strip()

    def update(self, instance, validated_data):
        full_name = validated_data.pop('full_name', None)
        email = validated_data.pop('email', None)
        phone_number = validated_data.pop('phone_number', None)

        if full_name:
            names = full_name.split(' ', 1)
            instance.user.first_name = names[0]
            instance.user.last_name = names[1] if len(names) > 1 else ''

        if email:
            instance.user.email = email
        instance.user.save()
 
        if phone_number is not None:
            instance.phone_number = phone_number

        instance.role = validated_data.get('role', instance.role)
        instance.save()
        return instance

class RoundingDecimalField(serializers.DecimalField):
    """
    Custom DecimalField that automatically rounds float or string inputs to 
    the defined decimal_places before validation runs, preventing 
    "Ensure that there are no more than X digits in total" errors.
    """
    def to_internal_value(self, data):
        try:
            if data is not None and data != '':
                rounded_val = round(float(data), self.decimal_places)
                data = f"{rounded_val:.{self.decimal_places}f}"
        except (ValueError, TypeError):
            pass
        return super().to_internal_value(data)

class HomeAddressSerializer(serializers.ModelSerializer):
    google_maps_link = serializers.URLField(read_only=True)
    latitude = RoundingDecimalField(max_digits=9, decimal_places=6, required=False, allow_null=True)
    longitude = RoundingDecimalField(max_digits=9, decimal_places=6, required=False, allow_null=True)
    class Meta:
        model = HomeAddress
        fields = ['customer', 'house_name', 'building_name', 'landmark', 'village', 'taluk', 'district', 'state', 'pincode', 'latitude', 'longitude', 'google_maps_link', 'address_photo']

class CurrentAddressSerializer(serializers.ModelSerializer):
    google_maps_link = serializers.URLField(read_only=True)
    latitude = RoundingDecimalField(max_digits=9, decimal_places=6, required=False, allow_null=True)
    longitude = RoundingDecimalField(max_digits=9, decimal_places=6, required=False, allow_null=True)
    class Meta:
        model = CurrentAddress
        fields = ['customer', 'house_name', 'building_name', 'landmark', 'village', 'taluk', 'district', 'state', 'pincode', 'latitude', 'longitude', 'google_maps_link', 'address_photo']

class WorkAddressSerializer(serializers.ModelSerializer):
    google_maps_link = serializers.URLField(read_only=True)
    latitude = RoundingDecimalField(max_digits=9, decimal_places=6, required=False, allow_null=True)
    longitude = RoundingDecimalField(max_digits=9, decimal_places=6, required=False, allow_null=True)
    class Meta:
        model = WorkAddress
        fields = ['customer', 'house_name', 'building_name', 'landmark', 'village', 'taluk', 'district', 'state', 'pincode', 'latitude', 'longitude', 'google_maps_link', 'address_photo']



class CustomerSerializer(serializers.ModelSerializer):
    created_by_name = serializers.CharField(source='created_by.__str__', read_only=True)
    kyc_status = serializers.ReadOnlyField()
    home_address = HomeAddressSerializer(required=False)
    current_address = CurrentAddressSerializer(required=False)
    work_address = WorkAddressSerializer(required=False)
    is_edit_unlocked = serializers.SerializerMethodField()

    class Meta:
        model = Customer
        fields = [
            'id', 'customer_id', 'full_name', 'mobile_number', 'alternate_number', 'email',
            'customer_type', 'approval_status', 'edit_enabled', 'is_edit_unlocked', 'created_by', 
            'created_by_name', 'created_at', 'updated_at', 'home_address', 'current_address', 'work_address', 
            'customer_photo', 'address_proof', 'id_proof', 'kyc_status',
        ]
        read_only_fields = ['customer_id', 'created_by', 'created_at', 'updated_at']

    def get_is_edit_unlocked(self, obj):
        # Profile is edit-unlocked if status is Pending, edit_enabled is True, and it has an approved edit request
        return obj.approval_status == 'Pending' and obj.edit_enabled and obj.edit_requests.filter(status='Approved').exists()

    def to_representation(self, instance):
        data = super().to_representation(instance)
        if 'full_name' in data and data['full_name']:
            data['full_name'] = ' '.join(word[0].upper() + word[1:] if word else '' for word in data['full_name'].split())
        return data

    def create(self, validated_data):
        request = self.context.get('request')
        home_address_data = None
        current_address_data = None
        work_address_data = None

        if request:
            home_raw = request.data.get('home_address')
            current_raw = request.data.get('current_address')
            work_raw = request.data.get('work_address')

            if home_raw: home_address_data = json.loads(home_raw)
            if current_raw: current_address_data = json.loads(current_raw)
            if work_raw: work_address_data = json.loads(work_raw)

        customer = Customer.objects.create(**validated_data)

        if home_address_data:
            home = HomeAddress.objects.create(customer=customer, **home_address_data)
            if request.FILES.get("home_address_proof"):
                home.address_photo = request.FILES["home_address_proof"]
                home.save()

        if current_address_data:
            current = CurrentAddress.objects.create(customer=customer, **current_address_data)
            if request.FILES.get("current_address_proof"):
                current.address_photo = request.FILES["current_address_proof"]
                current.save()

        if work_address_data:
            work = WorkAddress.objects.create(customer=customer, **work_address_data)
            if request.FILES.get("work_address_proof"):
                work.address_photo = request.FILES["work_address_proof"]
                work.save()

        return customer

    def update(self, instance, validated_data):
        # Validate that unprivileged Agents do not submit patch queries against approved records
        request = self.context.get('request')
        if request and not is_admin_or_subadmin(request.user) and (instance.approval_status == "Approved" and not instance.edit_enabled):
            raise serializers.ValidationError("Approved customer profile updates are locked for field agents.")

        home_data = validated_data.pop('home_address', None)
        current_data = validated_data.pop('current_address', None)
        work_data = validated_data.pop('work_address', None)

        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        if home_data:
            home, _ = HomeAddress.objects.get_or_create(customer=instance)
            for attr, value in home_data.items(): setattr(home, attr, value)
            if self.context['request'].FILES.get("home_address_proof"):
               home.address_photo = self.context['request'].FILES["home_address_proof"]
            home.save()

        if current_data:
            current, _ = CurrentAddress.objects.get_or_create(customer=instance)
            for attr, value in current_data.items(): setattr(current, attr, value)
            if self.context['request'].FILES.get("current_address_proof"):
               current.address_photo = self.context['request'].FILES["current_address_proof"]
            current.save()

        if work_data:
            work, _ = WorkAddress.objects.get_or_create(customer=instance)
            for attr, value in work_data.items(): setattr(work, attr, value)
            if self.context['request'].FILES.get("work_address_proof"):
               work.address_photo = self.context['request'].FILES["work_address_proof"]
            work.save()

        return instance

class ChitPlanSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChitPlan
        fields = ['id', 'plan_code', 'chit_name', 'total_amount', 'number_of_installments', 'monthly_payment', 'is_active', 'created_at']
        read_only_fields = ['created_at']

class SubscriptionSerializer(serializers.ModelSerializer):
    customer_name = serializers.CharField(source='customer.full_name', read_only=True)
    customer_id_display = serializers.CharField(source='customer.customer_id', read_only=True)
    chit_plan_name = serializers.CharField(source='chit_plan.chit_name', read_only=True)
    chit_plan_code = serializers.CharField(source='chit_plan.plan_code', read_only=True)

    class Meta:
        model = Subscription
        fields = ['id', 'customer', 'customer_id_display', 'customer_name', 'chit_plan', 'chit_plan_code', 'chit_plan_name', 'payment_status', 'subscription_status', 'joined_date']

    def validate_customer(self, customer):
        return customer

    def validate_chit_plan(self, chit_plan):
        if not chit_plan.is_active and not is_admin_or_subadmin(self.context['request'].user):
            raise serializers.ValidationError('This chit plan is not active.')
        return chit_plan

class DashboardRecentCustomerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Customer
        fields = ['id', 'customer_id', 'full_name', 'created_at', 'kyc_status']

class DashboardRecentSubscriptionSerializer(serializers.ModelSerializer):
    customer_name = serializers.CharField(source='customer.full_name', read_only=True)
    chit_plan_name = serializers.CharField(source='chit_plan.chit_name', read_only=True)
    monthly_payment = serializers.DecimalField(source='chit_plan.monthly_payment', max_digits=12, decimal_places=2, read_only=True)
    class Meta:
        model = Subscription
        fields = ['id', 'customer_name', 'chit_plan_name', 'monthly_payment', 'payment_status']


class CustomerEditRequestSerializer(serializers.ModelSerializer):
    customer_name = serializers.CharField(source='customer.full_name', read_only=True)
    customer_code = serializers.CharField(source='customer.customer_id', read_only=True)
    requested_by_name = serializers.CharField(source='requested_by.user.username', read_only=True)
    
    class Meta:
        model = CustomerEditRequest
        fields = [
            'id', 'customer', 'customer_name', 'customer_code', 'reason', 
            'status', 'created_at', 'requested_by', 'requested_by_name',
            'resolved_by', 'resolved_at'
        ]
        read_only_fields = ['requested_by', 'status', 'resolved_by', 'resolved_at']
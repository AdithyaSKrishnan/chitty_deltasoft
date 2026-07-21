import axios from 'axios';

// 🔴 LOCAL DEVELOPMENT BACKEND
const API_BASE_URL = 'http://localhost:8000/api/';

// 🟢 LIVE PRODUCTION BACKEND (Uncomment when deploying live)
// const API_BASE_URL = 'https://chittyapi.orianacare.com/api/';

const ACCESS_TOKEN_KEY = 'chitty_access_token';
const REFRESH_TOKEN_KEY = 'chitty_refresh_token';
const USER_KEY = 'chitty_user';

let isRefreshing = false;
let refreshSubscribers = [];

function subscribeTokenRefresh(callback) {
  refreshSubscribers.push(callback);
}

function onTokenRefreshed(token) {
  refreshSubscribers.forEach((callback) => callback(token));
  refreshSubscribers = [];
}

export function getAccessToken() {
  return localStorage.getItem(ACCESS_TOKEN_KEY);
}

export function getRefreshToken() {
  return localStorage.getItem(REFRESH_TOKEN_KEY);
}

export function getStoredUser() {
  const raw = localStorage.getItem(USER_KEY);
  return raw ? JSON.parse(raw) : null;
}

export function setAuthData({ access, refresh, user }) {
  localStorage.setItem(ACCESS_TOKEN_KEY, access);
  localStorage.setItem(REFRESH_TOKEN_KEY, refresh);
  localStorage.setItem(USER_KEY, JSON.stringify(user));
}

export function clearAuthData() {
  localStorage.removeItem(ACCESS_TOKEN_KEY);
  localStorage.removeItem(REFRESH_TOKEN_KEY);
  localStorage.removeItem(USER_KEY);
}

export function mapBackendRole(role) {
  if (role === 'admin') return 'admin';
  if (role === 'subadmin') return 'subadmin';
  return 'agent';
}

export function mapApiError(error) {
  if (!error.response) {
    return 'Network error. Please check your connection and try again.';
  }

  const { status, data } = error.response;

  if (typeof data === 'string') {
    return data;
  }

  if (data?.detail) {
    return data.detail;
  }

  if (typeof data === 'object' && data !== null) {
    const messages = [];
    Object.entries(data).forEach(([field, value]) => {
      const label = field === 'non_field_errors' ? '' : `${field}: `;
      if (Array.isArray(value)) {
        messages.push(`${label}${value.join(', ')}`);
      } else if (typeof value === 'string') {
        messages.push(`${label}${value}`);
      }
    });
    if (messages.length > 0) {
      return messages.join(' ');
    }
  }

  const defaults = {
    400: 'Invalid request. Please check your input.',
    401: 'Invalid credentials or session expired.',
    403: 'You do not have permission to perform this action.',
    404: 'The requested resource was not found.',
    500: 'Server error. Please try again later.',
  };

  return defaults[status] || 'Something went wrong. Please try again.';
}

function emptyAddress(type) {
  return {
    id: '',
    type,
    houseOrBuildingName: '',
    landmark: '',
    village: '',
    taluk: '',
    district: '',
    state: '',
    pinCode: '',
    latitude: null,
    longitude: null,
    mapUrl: '',
  };
}

export function mapAddressFromApi(address, type) {
  if (!address) {
    return emptyAddress(type);
  }

  const houseOrBuildingName = [address.house_name, address.building_name]
    .filter(Boolean)
    .join(', ');

  return {
    id: String(address.id),
    type,
    houseOrBuildingName,
    landmark: address.landmark || '',
    village: address.village || '',
    taluk: address.taluk || '',
    district: address.district || '',
    state: address.state || '',
    pinCode: address.pincode || '',
    latitude: address.latitude != null ? Number(address.latitude) : null,
    longitude: address.longitude != null ? Number(address.longitude) : null,
    mapUrl: address.google_maps_link || '',
  };
}

export function mapCustomerFromApi(customer) {
  const photos = [];
  if (customer.customer_photo) {
    photos.push({ type: 'customer', url: customer.customer_photo });
  }
  if (customer.address_proof) {
    photos.push({ type: 'addressProof', url: customer.address_proof });
  }
  if (customer.id_proof) {
    photos.push({ type: 'idProof', url: customer.id_proof });
  }
  if (customer.home_address?.address_photo) {
    photos.push({ type: 'homeAddressProof', url: customer.home_address.address_photo });
  }
  if (customer.current_address?.address_photo) {
    photos.push({ type: 'currentAddressProof', url: customer.current_address.address_photo });
  }
  if (customer.work_address?.address_photo) {
    photos.push({ type: 'workAddressProof', url: customer.work_address.address_photo });
  }

  return {
    id: String(customer.id),
    customerId: customer.customer_id,
    name: customer.full_name,
    primaryMobile: customer.mobile_number,
    alternateMobile: customer.alternate_number || '',
    email: customer.email || '',
    homeAddress: mapAddressFromApi(customer.home_address, 'home'),
    currentAddress: customer.current_address
      ? mapAddressFromApi(customer.current_address, 'current')
      : undefined,
    workAddress: customer.work_address
      ? mapAddressFromApi(customer.work_address, 'work')
      : undefined,
    customerPhoto: customer.customer_photo || undefined,
    photos,
    createdBy: String(customer.created_by),
    createdByName: customer.created_by_name || 'Agent',
    createdAt: customer.created_at,
    updatedAt: customer.updated_at || customer.created_at,
    approvalStatus: customer.approval_status || 'Pending',
    editEnabled: customer.edit_enabled ?? true,
    isEditUnlocked: customer.is_edit_unlocked ?? false,
  };
}

export function mapChitPlanFromApi(plan) {
  return {
    id: String(plan.id),
    planName: plan.chit_name,
    planCode: plan.plan_code,
    totalAmount: Number(plan.total_amount),
    numberOfInstallments: plan.number_of_installments,
    monthlyPayment: Number(plan.monthly_payment),
    isActive: plan.is_active,
    createdAt: plan.created_at,
  };
}

export function mapSubscriptionFromApi(subscription) {
  const statusMap = {
    cancelled: 'paused',
    suspended: 'paused',
  };

  return {
    id: String(subscription.id),
    customerId: String(subscription.customer),
    customerName: subscription.customer_name || subscription.customer_id_display || '',
    customerPhoto: subscription.customer_photo || undefined,
    chitPlanId: String(subscription.chit_plan),
    chitPlanName: subscription.chit_plan_name || subscription.chit_plan_code || '',
    joinedDate: subscription.joined_date,
    status: statusMap[subscription.subscription_status] || subscription.subscription_status,
    paymentStatus: subscription.payment_status,
    totalPaid: 0,
    remainingAmount: 0,
  };
}

export function mapAddressToApi(address, type) {
  const payload = {
    landmark: address.landmark || '',
    village: address.village || '',
    taluk: address.taluk || '',
    district: address.district || '',
    state: address.state || '',
    pincode: address.pinCode || '',
  };

  if (address.latitude != null) {
    payload.latitude = address.latitude;
  }
  if (address.longitude != null) {
    payload.longitude = address.longitude;
  }

  if (type === 'home') {
    payload.house_name = address.houseOrBuildingName || '';
    payload.building_name = '';
  } else {
    payload.building_name = address.houseOrBuildingName || '';
    payload.house_name = '';
  }

  return payload;
}

function dataUrlToFile(dataUrl, filename) {
  if (!dataUrl || !dataUrl.startsWith('data:')) {
    return null;
  }

  const [header, base64] = dataUrl.split(',');
  const mime = header.match(/:(.*?);/)?.[1] || 'image/jpeg';
  const binary = atob(base64);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i += 1) {
    bytes[i] = binary.charCodeAt(i);
  }
  return new File([bytes], filename, { type: mime });
}

async function createAddress(endpoint, customerId, address, type, photoDataUrl) {
  const file = dataUrlToFile(photoDataUrl, `${type}-address.jpg`);
  const payload = {
    customer: customerId,
    ...mapAddressToApi(address, type),
  };

  if (file) {
    const formData = new FormData();
    Object.entries(payload).forEach(([key, value]) => {
      if (value !== '' && value != null) {
        formData.append(key, value);
      }
    });
    formData.append('address_photo', file);
    await api.post(endpoint, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return;
  }

  await api.post(endpoint, payload);
}

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

api.interceptors.request.use((config) => {
  const token = getAccessToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    if (
      error.response?.status === 401 &&
      originalRequest &&
      !originalRequest._retry &&
      !originalRequest.url?.includes('token/')
    ) {
      const refreshToken = getRefreshToken();
      if (!refreshToken) {
        clearAuthData();
        window.location.href = '/login';
        return Promise.reject(error);
      }

      if (isRefreshing) {
        return new Promise((resolve) => {
          subscribeTokenRefresh((token) => {
            originalRequest.headers.Authorization = `Bearer ${token}`;
            resolve(api(originalRequest));
          });
        });
      }

      originalRequest._retry = true;
      isRefreshing = true;

      try {
        const response = await axios.post(`${API_BASE_URL}token/refresh/`, {
          refresh: refreshToken,
        });
        const newAccess = response.data.access;
        localStorage.setItem(ACCESS_TOKEN_KEY, newAccess);
        onTokenRefreshed(newAccess);
        originalRequest.headers.Authorization = `Bearer ${newAccess}`;
        return api(originalRequest);
      } catch (refreshError) {
        clearAuthData();
        window.location.href = '/login';
        return Promise.reject(refreshError);
      } finally {
        isRefreshing = false;
      }
    }

    return Promise.reject(error);
  },
);

export async function login(username, password) {
  const response = await api.post('token/', { username, password });
  const { access, refresh, employee_id, role, role_display } = response.data;

  const user = {
    id: employee_id,
    username,
    email: '',
    role: mapBackendRole(role),
    name: role_display || username,
    employeeId: employee_id,
    isActive: true,
    createdAt: new Date().toISOString(),
  };

  setAuthData({ access, refresh, user });
  return user;
}

export async function fetchCustomers(params = {}) {
  const response = await api.get('customers/', { params });
  const items = Array.isArray(response.data) ? response.data : response.data.results || [];
  return items.map(mapCustomerFromApi);
}

export async function fetchCustomer(id) {
  const response = await api.get(`customers/${id}/`);
  return mapCustomerFromApi(response.data);
}

export async function approveCustomer(id) {
  const response = await api.post(`customers/${id}/approve/`);
  return response.data;
}

export async function createCustomerWithDetails({
  customer,
  homeAddress,
  workAddress,
  photos = {},
  subscription,
}) {
  const customerResponse = await api.post('customers/', {
    full_name: customer.name,
    mobile_number: customer.primaryMobile,
    alternate_number: customer.alternateMobile || '',
    email: customer.email || '',
  });

  const createdCustomer = customerResponse.data;

  await createAddress(
    'home-addresses/',
    createdCustomer.id,
    homeAddress,
    'home',
    photos.addressProof,
  );

  if (workAddress) {
    await createAddress(
      'work-addresses/',
      createdCustomer.id,
      workAddress,
      'work',
      photos.workLocation,
    );
  }

  if (photos.customer || photos.addressProof || photos.idProof) {
    await uploadCustomerPhotos(createdCustomer.id, photos);
  }

  if (subscription?.chitPlanId) {
    await api.post('subscriptions/', {
      customer: createdCustomer.id,
      chit_plan: Number(subscription.chitPlanId),
      joined_date: subscription.joinedDate || new Date().toISOString().split('T')[0],
    });
  }

  return mapCustomerFromApi(
    (await api.get(`customers/${createdCustomer.id}/`)).data,
  );
}

export async function uploadCustomerPhotos(id, photos) {
  const formData = new FormData();
  let hasPhotos = false;

  if (photos.customer && photos.customer.startsWith('data:')) {
    const file = dataUrlToFile(photos.customer, 'customer.jpg');
    if (file) {
      formData.append('customer_photo', file);
      hasPhotos = true;
    }
  }
  if (photos.addressProof && photos.addressProof.startsWith('data:')) {
    const file = dataUrlToFile(photos.addressProof, 'address_proof.jpg');
    if (file) {
      formData.append('address_proof', file);
      hasPhotos = true;
    }
  }
  if (photos.idProof && photos.idProof.startsWith('data:')) {
    const file = dataUrlToFile(photos.idProof, 'id_proof.jpg');
    if (file) {
      formData.append('id_proof', file);
      hasPhotos = true;
    }
  }

  if (hasPhotos) {
    await api.patch(`customers/${id}/`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  }
}

export async function updateCustomer(id, customer) {
  const payload = {
    full_name: customer.name,
    mobile_number: customer.primaryMobile,
    alternate_number: customer.alternateMobile || '',
    email: customer.email || '',
  };

  if (customer.homeAddress) {
    payload.home_address = mapAddressToApi(customer.homeAddress, 'home');
  }
  if (customer.currentAddress) {
    payload.current_address = mapAddressToApi(customer.currentAddress, 'current');
  }
  if (customer.workAddress) {
    payload.work_address = mapAddressToApi(customer.workAddress, 'work');
  }

  const response = await api.patch(`customers/${id}/`, payload);
  return mapCustomerFromApi(response.data);
}

export async function deleteCustomer(id) {
  await api.delete(`customers/${id}/`);
}

export async function fetchChitPlans(params = {}) {
  const response = await api.get('chit-plans/', { params });
  const items = Array.isArray(response.data) ? response.data : response.data.results || [];
  return items.map(mapChitPlanFromApi);
}

export async function createChitPlan(plan) {
  const response = await api.post('chit-plans/', {
    plan_code: plan.planCode,
    chit_name: plan.planName,
    total_amount: plan.totalAmount,
    number_of_installments: plan.numberOfInstallments,
    monthly_payment: plan.monthlyPayment,
    is_active: true,
  });
  return mapChitPlanFromApi(response.data);
}

export async function updateChitPlan(id, plan) {
  const response = await api.patch(`chit-plans/${id}/`, {
    plan_code: plan.planCode,
    chit_name: plan.planName,
    total_amount: plan.totalAmount,
    number_of_installments: plan.numberOfInstallments,
    monthly_payment: plan.monthlyPayment,
    is_active: plan.isActive,
  });
  return mapChitPlanFromApi(response.data);
}

export async function toggleChitPlanActive(id, isActive) {
  const response = await api.patch(`chit-plans/${id}/`, { is_active: isActive });
  return mapChitPlanFromApi(response.data);
}

export async function fetchSubscriptions(params = {}) {
  const response = await api.get('subscriptions/', { params });
  const items = Array.isArray(response.data) ? response.data : response.data.results || [];
  return items.map(mapSubscriptionFromApi);
}

export function mapDashboardStatsFromApi(data) {
  return {
    totalCustomers: data.total_customers,
    activeChitties: data.active_subscriptions,
    monthlyCollections: Number(data.monthly_collections_total),
    pendingPayments: data.pending_payments,
    activePlans: data.active_chit_plans,
    recentOnboardings: data.recent_onboardings ?? 0,
  };
}

export async function fetchDashboardStats() {
  const response = await api.get('dashboard/stats/');
  return mapDashboardStatsFromApi(response.data);
}

export function mapDashboardRecentCustomerFromApi(customer) {
  return {
    id: String(customer.id),
    customerId: customer.customer_id,
    name: customer.full_name,
    customerPhoto: customer.customer_photo || undefined,
    createdAt: customer.created_at,
  };
}

export async function fetchDashboardRecentCustomers() {
  const response = await api.get('dashboard/recent-customers/');
  const items = Array.isArray(response.data) ? response.data : response.data.results || [];
  return items.map(mapDashboardRecentCustomerFromApi);
}

export function mapDashboardRecentSubscriptionFromApi(subscription) {
  return {
    id: String(subscription.id),
    customerName: subscription.customer_name,
    customerPhoto: subscription.customer_photo || undefined,
    chitPlanName: subscription.chit_plan_name,
    monthlyPayment: Number(subscription.monthly_payment),
    paymentStatus: subscription.payment_status,
  };
}

export async function fetchDashboardRecentSubscriptions() {
  const response = await api.get('dashboard/recent-subscriptions/');
  const items = Array.isArray(response.data) ? response.data : response.data.results || [];
  return items.map(mapDashboardRecentSubscriptionFromApi);
}

export async function createSubscription({ customerId, chitPlanId, joinedDate }) {
  const response = await api.post('subscriptions/', {
    customer: Number(customerId),
    chit_plan: Number(chitPlanId),
    joined_date: joinedDate,
  });
  return mapSubscriptionFromApi(response.data);
}

export function mapEmployeeFromApi(emp) {
  return {
    id: String(emp.id),
    employeeId: emp.employee_id,
    userId: String(emp.id),
    username: emp.username_display || '',
    name: emp.full_name_display || '',
    email: emp.email_display || '',
    phone: emp.phone_number || '',
    role: mapBackendRole(emp.role),
    isActive: emp.is_active ?? true,
    customersCount: emp.customer_count ?? 0,
    createdAt: new Date().toISOString(),
  };
}

export async function fetchEmployees(params = {}) {
  const response = await api.get('employees/', { params });
  const items = Array.isArray(response.data) ? response.data : response.data.results || [];
  return items.map(mapEmployeeFromApi);
}

export async function createEmployee(data) {
  const response = await api.post('employees/', {
    full_name: data.name,
    username: data.username,
    email: data.email,
    password: data.password,
    phone_number: data.phone,
    role: data.role === 'agent' ? 'field_agent' : data.role,
  });
  return mapEmployeeFromApi(response.data);
}

export async function updateEmployee(id, data) {
  const response = await api.patch(`employees/${id}/`, {
    full_name: data.name,
    email: data.email,
    phone_number: data.phone,
    role: data.role === 'agent' ? 'field_agent' : data.role,
  });
  return mapEmployeeFromApi(response.data);
}

export async function toggleEmployeeStatus(id) {
  const response = await api.post(`employees/${id}/toggle_status/`);
  return response.data;
}

export async function fetchCustomerEditRequests(params = {}) {
  const response = await api.get('customer-edit-requests/', { params });
  return Array.isArray(response.data) ? response.data : response.data.results || [];
}

export async function createCustomerEditRequest(data) {
  const response = await api.post('customer-edit-requests/', {
    customer: Number(data.customerId),
    reason: data.reason,
  });
  return response.data;
}

export async function approveCustomerEditRequest(id) {
  const response = await api.post(`customer-edit-requests/${id}/approve/`);
  return response.data;
}

export async function rejectCustomerEditRequest(id) {
  const response = await api.post(`customer-edit-requests/${id}/reject/`);
  return response.data;
}

export default api;

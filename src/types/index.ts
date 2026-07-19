export type UserRole = 'admin' | 'subadmin' | 'agent';

export interface User {
  id: string;
  username: string;
  email: string;
  role: UserRole;
  name: string;
  employeeId?: string;
  phone?: string;
  isActive: boolean;
  createdAt: string;
}

export interface Address {
  id: string;
  type: 'home' | 'work';
  houseOrBuildingName: string;
  landmark: string;
  village: string;
  taluk: string;
  district: string;
  state: string;
  pinCode: string;
  latitude: number | null;
  longitude: number | null;
  mapUrl: string;
}

export interface CustomerPhoto {
  id: string;
  type: 'customer' | 'address_proof' | 'id_proof' | 'work_location';
  url: string;
  uploadedAt: string;
}

export interface Customer {
  id: string;
  customerId: string;
  name: string;
  primaryMobile: string;
  alternateMobile?: string;
  email: string;
  homeAddress: Address;
  currentAddress?: Address;
  workAddress?: Address;
  customerPhoto?: string;
  photos: CustomerPhoto[];
  createdBy: string;
  createdByName?: string;
  createdAt: string;
  updatedAt: string;
  approvalStatus: string;
  editEnabled: boolean;
  isEditUnlocked?: boolean;
}

export interface ChitPlan {
  id: string;
  planName: string;
  planCode: string;
  totalAmount: number;
  numberOfInstallments: number;
  monthlyPayment: number;
  isActive: boolean;
  createdAt: string;
}

export interface Subscription {
  id: string;
  customerId: string;
  customerName: string;
  customerPhoto?: string;
  chitPlanId: string;
  chitPlanName: string;
  joinedDate: string;
  status: 'active' | 'completed' | 'paused';
  paymentStatus: 'paid' | 'pending' | 'overdue';
  totalPaid: number;
  remainingAmount: number;
}

export interface Employee {
  id: string;
  employeeId: string;
  userId: string;
  username: string;
  name: string;
  email: string;
  phone: string;
  role: UserRole;
  isActive: boolean;
  customersCount: number;
  createdAt: string;
}

export interface DashboardStats {
  totalCustomers: number;
  activeChitties: number;
  monthlyCollections: number;
  pendingPayments: number;
  activePlans: number;
  recentOnboardings: number;
}

export interface DashboardRecentCustomer {
  id: string;
  customerId: string;
  name: string;
  createdAt: string;
}

export interface DashboardRecentSubscription {
  id: string;
  customerName: string;
  chitPlanName: string;
  monthlyPayment: number;
  paymentStatus: string;
}

import type { ChitPlan, Customer, Subscription, User } from '../types';

export function getAccessToken(): string | null;
export function getRefreshToken(): string | null;
export function getStoredUser(): User | null;
export function setAuthData(data: { access: string; refresh: string; user: User }): void;
export function clearAuthData(): void;
export function mapBackendRole(role: string): 'admin' | 'agent';
export function mapApiError(error: unknown): string;
export function mapCustomerFromApi(customer: Record<string, unknown>): Customer;
export function mapChitPlanFromApi(plan: Record<string, unknown>): ChitPlan;
export function mapSubscriptionFromApi(subscription: Record<string, unknown>): Subscription;

export function login(username: string, password: string): Promise<User>;
export function fetchCustomers(params?: Record<string, string>): Promise<Customer[]>;
export function fetchCustomer(id: string): Promise<Customer>;
export function createCustomerWithDetails(data: {
  customer: {
    name: string;
    primaryMobile: string;
    alternateMobile?: string;
    email?: string;
  };
  homeAddress: Record<string, unknown>;
  workAddress?: Record<string, unknown> | null;
  photos?: Record<string, string>;
  subscription?: { chitPlanId: string; joinedDate?: string } | null;
}): Promise<Customer>;
export function updateCustomer(
  id: string,
  customer: {
    name: string;
    primaryMobile: string;
    alternateMobile?: string;
    email?: string;
  },
): Promise<Customer>;
export function deleteCustomer(id: string): Promise<void>;
export function fetchChitPlans(params?: Record<string, string>): Promise<ChitPlan[]>;
export function createChitPlan(plan: {
  planName: string;
  planCode: string;
  totalAmount: number;
  numberOfInstallments: number;
  monthlyPayment: number;
}): Promise<ChitPlan>;
export function updateChitPlan(
  id: string,
  plan: {
    planName: string;
    planCode: string;
    totalAmount: number;
    numberOfInstallments: number;
    monthlyPayment: number;
    isActive: boolean;
  },
): Promise<ChitPlan>;
export function toggleChitPlanActive(id: string, isActive: boolean): Promise<ChitPlan>;
export function fetchSubscriptions(params?: Record<string, string>): Promise<Subscription[]>;
export function mapDashboardStatsFromApi(data: Record<string, unknown>): import('../types').DashboardStats;
export function fetchDashboardStats(): Promise<import('../types').DashboardStats>;
export function mapDashboardRecentCustomerFromApi(
  customer: Record<string, unknown>,
): import('../types').DashboardRecentCustomer;
export function fetchDashboardRecentCustomers(): Promise<
  import('../types').DashboardRecentCustomer[]
>;
export function mapDashboardRecentSubscriptionFromApi(
  subscription: Record<string, unknown>,
): import('../types').DashboardRecentSubscription;
export function fetchDashboardRecentSubscriptions(): Promise<
  import('../types').DashboardRecentSubscription[]
>;
export function createSubscription(data: {
  customerId: string;
  chitPlanId: string;
  joinedDate: string;
}): Promise<Subscription>;

declare const api: import('axios').AxiosInstance;
export default api;

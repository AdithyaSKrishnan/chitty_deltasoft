import { useCallback, useEffect, useState } from 'react';
import { StatCard, Card, PageHeader } from '../../components/ui/Card';
import {
  Users,
  CreditCard,
  IndianRupee,
  Clock,
  FileText,
  UserPlus,
  TrendingUp,
  ArrowRight,
} from 'lucide-react';
import { Link } from 'react-router-dom';
import {
  fetchDashboardRecentCustomers,
  fetchDashboardRecentSubscriptions,
  fetchDashboardStats,
  mapApiError,
} from '../../services/api';
import type {
  DashboardRecentCustomer,
  DashboardRecentSubscription,
  DashboardStats,
} from '../../types';

function formatMonthlyCollection(amount: number): string {
  if (amount >= 100000) {
    return `₹${(amount / 100000).toFixed(1)}L`;
  }
  if (amount >= 1000) {
    return `₹${(amount / 1000).toFixed(1)}K`;
  }
  return `₹${amount.toLocaleString()}`;
}

function SectionSpinner() {
  return (
    <div className="flex items-center justify-center py-8">
      <div className="w-6 h-6 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
    </div>
  );
}

export default function Dashboard() {
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [recentCustomers, setRecentCustomers] = useState<DashboardRecentCustomer[]>([]);
  const [recentSubscriptions, setRecentSubscriptions] = useState<DashboardRecentSubscription[]>([]);
  const [isLoadingStats, setIsLoadingStats] = useState(true);
  const [isLoadingCustomers, setIsLoadingCustomers] = useState(true);
  const [isLoadingSubscriptions, setIsLoadingSubscriptions] = useState(true);
  const [statsError, setStatsError] = useState('');
  const [customersError, setCustomersError] = useState('');
  const [subscriptionsError, setSubscriptionsError] = useState('');

  const loadStats = useCallback(async () => {
    setIsLoadingStats(true);
    setStatsError('');
    try {
      const statsData = await fetchDashboardStats();
      setStats(statsData);
    } catch (err) {
      setStatsError(mapApiError(err));
    } finally {
      setIsLoadingStats(false);
    }
  }, []);

  const loadRecentCustomers = useCallback(async () => {
    setIsLoadingCustomers(true);
    setCustomersError('');
    try {
      const data = await fetchDashboardRecentCustomers();
      setRecentCustomers(data);
    } catch (err) {
      setCustomersError(mapApiError(err));
    } finally {
      setIsLoadingCustomers(false);
    }
  }, []);

  const loadRecentSubscriptions = useCallback(async () => {
    setIsLoadingSubscriptions(true);
    setSubscriptionsError('');
    try {
      const data = await fetchDashboardRecentSubscriptions();
      setRecentSubscriptions(data);
    } catch (err) {
      setSubscriptionsError(mapApiError(err));
    } finally {
      setIsLoadingSubscriptions(false);
    }
  }, []);

  useEffect(() => {
    loadStats();
    loadRecentCustomers();
    loadRecentSubscriptions();
  }, [loadStats, loadRecentCustomers, loadRecentSubscriptions]);

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Dashboard"
        subtitle="Welcome back! Here's your overview."
      />

      {/* Stats Grid */}
      {isLoadingStats ? (
        <div className="flex items-center justify-center py-16">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : (
        <>
          {statsError && (
            <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
              {statsError}
            </div>
          )}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4">
            <div className="sm:col-span-2 lg:col-span-1 xl:col-span-2">
              <StatCard
                title="Total Customers"
                value={stats ? stats.totalCustomers.toLocaleString() : '—'}
                subtitle="All time"
                icon={<Users className="w-6 h-6" />}
                color="primary"
              />
            </div>
            <StatCard
              title="Active Chitties"
              value={stats ? stats.activeChitties.toLocaleString() : '—'}
              subtitle="Currently running"
              icon={<CreditCard className="w-6 h-6" />}
              color="accent"
            />
            <StatCard
              title="Monthly Collection"
              value={stats ? formatMonthlyCollection(stats.monthlyCollections) : '—'}
              subtitle="Expected this month"
              icon={<IndianRupee className="w-6 h-6" />}
              color="primary"
            />
            <StatCard
              title="Pending Payments"
              value={stats ? stats.pendingPayments.toLocaleString() : '—'}
              subtitle="Requires attention"
              icon={<Clock className="w-6 h-6" />}
              color="warning"
            />
            <StatCard
              title="Active Plans"
              value={stats ? stats.activePlans.toLocaleString() : '—'}
              subtitle="Chit plans available"
              icon={<FileText className="w-6 h-6" />}
              color="accent"
            />
            <StatCard
              title="Recent Onboardings"
              value={stats ? stats.recentOnboardings.toLocaleString() : '—'}
              subtitle="Last 7 days"
              icon={<UserPlus className="w-6 h-6" />}
              color="primary"
            />
          </div>
        </>
      )}

      {/* Quick Actions */}
      <Card>
        <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">
          Quick Actions
        </h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          <Link
            to="/admin/customers/add"
            className="flex items-center gap-3 p-4 rounded-xl bg-gradient-to-br from-primary-50 to-primary-100/50 dark:from-primary-900/20 dark:to-primary-900/10 hover:from-primary-100 hover:to-primary-200/50 dark:hover:from-primary-900/30 dark:hover:to-primary-900/20 transition-all group"
          >
            <div className="w-10 h-10 rounded-xl bg-primary-500 flex items-center justify-center text-white group-hover:scale-110 transition-transform">
              <UserPlus className="w-5 h-5" />
            </div>
            <div>
              <p className="font-medium text-slate-800 dark:text-white">Add Customer</p>
              <p className="text-xs text-slate-500 dark:text-slate-400">New onboarding</p>
            </div>
          </Link>
          <Link
            to="/admin/employees/add"
            className="flex items-center gap-3 p-4 rounded-xl bg-gradient-to-br from-accent-50 to-accent-100/50 dark:from-accent-900/20 dark:to-accent-900/10 hover:from-accent-100 hover:to-accent-200/50 dark:hover:from-accent-900/30 dark:hover:to-accent-900/20 transition-all group"
          >
            <div className="w-10 h-10 rounded-xl bg-accent-500 flex items-center justify-center text-white group-hover:scale-110 transition-transform">
              <Users className="w-5 h-5" />
            </div>
            <div>
              <p className="font-medium text-slate-800 dark:text-white">Add Employee</p>
              <p className="text-xs text-slate-500 dark:text-slate-400">Field agent</p>
            </div>
          </Link>
          <Link
            to="/admin/plans/add"
            className="flex items-center gap-3 p-4 rounded-xl bg-gradient-to-br from-blue-50 to-blue-100/50 dark:from-blue-900/20 dark:to-blue-900/10 hover:from-blue-100 hover:to-blue-200/50 dark:hover:from-blue-900/30 dark:hover:to-blue-900/20 transition-all group"
          >
            <div className="w-10 h-10 rounded-xl bg-blue-500 flex items-center justify-center text-white group-hover:scale-110 transition-transform">
              <FileText className="w-5 h-5" />
            </div>
            <div>
              <p className="font-medium text-slate-800 dark:text-white">Create Plan</p>
              <p className="text-xs text-slate-500 dark:text-slate-400">Chit scheme</p>
            </div>
          </Link>
          <Link
            to="/admin/reports"
            className="flex items-center gap-3 p-4 rounded-xl bg-gradient-to-br from-purple-50 to-purple-100/50 dark:from-purple-900/20 dark:to-purple-900/10 hover:from-purple-100 hover:to-purple-200/50 dark:hover:from-purple-900/30 dark:hover:to-purple-900/20 transition-all group"
          >
            <div className="w-10 h-10 rounded-xl bg-purple-500 flex items-center justify-center text-white group-hover:scale-110 transition-transform">
              <TrendingUp className="w-5 h-5" />
            </div>
            <div>
              <p className="font-medium text-slate-800 dark:text-white">View Reports</p>
              <p className="text-xs text-slate-500 dark:text-slate-400">Analytics</p>
            </div>
          </Link>
        </div>
      </Card>

      {/* Recent sections */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Recent Customers */}
        <Card>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
              Recent Customers
            </h2>
            <Link
              to="/admin/customers"
              className="flex items-center gap-1 text-sm text-primary-600 dark:text-primary-400 hover:underline"
            >
              View all <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
          {customersError && (
            <div className="mb-3 p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
              {customersError}
            </div>
          )}
          {isLoadingCustomers ? (
            <SectionSpinner />
          ) : recentCustomers.length === 0 ? (
            <p className="text-sm text-slate-500 dark:text-slate-400 py-4 text-center">
              No customers yet
            </p>
          ) : (
            <div className="space-y-3">
              {recentCustomers.map((customer) => (
                <Link
                  key={customer.id}
                  to={`/admin/customers/${customer.id}`}
                  className="flex items-center gap-4 p-3 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-700/50 transition-colors"
                >
                  <img
                    src={`https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff`}
                    alt={customer.name}
                    className="w-10 h-10 rounded-full"
                  />
                  <div className="flex-1 min-w-0">
                    <p className="font-medium text-slate-800 dark:text-white truncate">
                      {customer.name}
                    </p>
                    <p className="text-sm text-slate-500 dark:text-slate-400">{customer.customerId}</p>
                  </div>
                  <span className="text-sm text-slate-400 dark:text-slate-500">
                    {new Date(customer.createdAt).toLocaleDateString()}
                  </span>
                </Link>
              ))}
            </div>
          )}
        </Card>

        {/* Active Subscriptions */}
        <Card>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
              Active Subscriptions
            </h2>
            <Link
              to="/admin/subscriptions"
              className="flex items-center gap-1 text-sm text-primary-600 dark:text-primary-400 hover:underline"
            >
              View all <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
          {subscriptionsError && (
            <div className="mb-3 p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
              {subscriptionsError}
            </div>
          )}
          {isLoadingSubscriptions ? (
            <SectionSpinner />
          ) : recentSubscriptions.length === 0 ? (
            <p className="text-sm text-slate-500 dark:text-slate-400 py-4 text-center">
              No active subscriptions
            </p>
          ) : (
            <div className="space-y-3">
              {recentSubscriptions.map((sub) => (
                <div
                  key={sub.id}
                  className="flex items-center gap-4 p-3 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-700/50 transition-colors"
                >
                  <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary-400 to-primary-500 flex items-center justify-center text-white font-semibold">
                    {sub.customerName.charAt(0)}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="font-medium text-slate-800 dark:text-white truncate">
                      {sub.customerName}
                    </p>
                    <p className="text-sm text-slate-500 dark:text-slate-400">
                      {sub.chitPlanName}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-medium text-slate-800 dark:text-white">
                      ₹{sub.monthlyPayment.toLocaleString()}
                    </p>
                    <p className="text-xs text-slate-500 dark:text-slate-400 capitalize">
                      {sub.paymentStatus}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          )}
        </Card>
      </div>
    </div>
  );
}

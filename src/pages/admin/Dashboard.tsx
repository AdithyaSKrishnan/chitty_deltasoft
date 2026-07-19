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
  fetchCustomerEditRequests,
  approveCustomerEditRequest,
  rejectCustomerEditRequest,
  fetchCustomers,
  approveCustomer,
} from '../../services/api';
import type {
  DashboardRecentCustomer,
  DashboardRecentSubscription,
  DashboardStats,
  Customer,
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
  const [editRequests, setEditRequests] = useState<any[]>([]);
  const [resolvingIds, setResolvingIds] = useState<string[]>([]);
  
  const [pendingConfirmations, setPendingConfirmations] = useState<Customer[]>([]);
  const [isLoadingConfirmations, setIsLoadingConfirmations] = useState(true);
  const [confirmationsError, setConfirmationsError] = useState('');
  const [confirmingIds, setConfirmingIds] = useState<string[]>([]);
  
  const [isLoadingStats, setIsLoadingStats] = useState(true);
  const [isLoadingCustomers, setIsLoadingCustomers] = useState(true);
  const [isLoadingSubscriptions, setIsLoadingSubscriptions] = useState(true);
  const [isLoadingRequests, setIsLoadingRequests] = useState(true);
  
  const [statsError, setStatsError] = useState('');
  const [customersError, setCustomersError] = useState('');
  const [subscriptionsError, setSubscriptionsError] = useState('');
  const [requestsError, setRequestsError] = useState('');

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

  const loadEditRequests = useCallback(async () => {
    setIsLoadingRequests(true);
    setRequestsError('');
    try {
      const data = await fetchCustomerEditRequests({ status: 'Pending' });
      setEditRequests(data);
    } catch (err) {
      setRequestsError(mapApiError(err));
    } finally {
      setIsLoadingRequests(false);
    }
  }, []);

  const handleApproveRequest = async (id: string) => {
    if (resolvingIds.includes(id)) return;
    setResolvingIds((prev) => [...prev, id]);
    try {
      await approveCustomerEditRequest(id);
      setEditRequests((prev) => prev.filter((r) => r.id !== id));
      loadRecentCustomers(); // Reload customer list to reflect status updates
    } catch (err) {
      alert(mapApiError(err));
    } finally {
      setResolvingIds((prev) => prev.filter((x) => x !== id));
    }
  };

  const handleRejectRequest = async (id: string) => {
    if (resolvingIds.includes(id)) return;
    setResolvingIds((prev) => [...prev, id]);
    try {
      await rejectCustomerEditRequest(id);
      setEditRequests((prev) => prev.filter((r) => r.id !== id));
    } catch (err) {
      alert(mapApiError(err));
    } finally {
      setResolvingIds((prev) => prev.filter((x) => x !== id));
    }
  };

  const loadConfirmations = useCallback(async () => {
    setIsLoadingConfirmations(true);
    setConfirmationsError('');
    try {
      const data = await fetchCustomers({ approval_status: 'Pending' });
      setPendingConfirmations(data.filter((c: any) => c.isEditUnlocked));
    } catch (err) {
      setConfirmationsError(mapApiError(err));
    } finally {
      setIsLoadingConfirmations(false);
    }
  }, []);

  const handleConfirmChanges = async (customerId: string) => {
    if (confirmingIds.includes(customerId)) return;
    setConfirmingIds((prev) => [...prev, customerId]);
    try {
      await approveCustomer(customerId);
      setPendingConfirmations((prev) => prev.filter((c) => c.id !== customerId));
      loadRecentCustomers();
      loadStats();
    } catch (err) {
      alert(mapApiError(err));
    } finally {
      setConfirmingIds((prev) => prev.filter((x) => x !== customerId));
    }
  };

  useEffect(() => {
    loadStats();
    loadRecentCustomers();
    loadRecentSubscriptions();
    loadEditRequests();
    loadConfirmations();
  }, [loadStats, loadRecentCustomers, loadRecentSubscriptions, loadEditRequests, loadConfirmations]);

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
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            <StatCard
              title="Total Customers"
              value={stats ? stats.totalCustomers.toLocaleString() : '—'}
              subtitle="All time"
              icon={<Users className="w-6 h-6" />}
              color="primary"
            />
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

      {/* Pending Edit Requests */}
      {editRequests.length > 0 && (
        <Card className="border-warning-500/20 bg-warning-50/5 dark:bg-warning-950/5">
          <div className="flex items-center gap-2 mb-4">
            <Clock className="w-5 h-5 text-warning-500 animate-pulse" />
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
              Pending Edit Requests ({editRequests.length})
            </h2>
          </div>
          {requestsError && (
            <div className="mb-3 p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
              {requestsError}
            </div>
          )}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {editRequests.map((req) => (
              <div
                key={req.id}
                className="p-4 rounded-xl bg-white dark:bg-slate-800 border border-slate-200/50 dark:border-slate-700/50 shadow-sm flex flex-col justify-between gap-3"
              >
                <div>
                  <div className="flex justify-between items-start gap-2 mb-1">
                    <p className="font-semibold text-slate-800 dark:text-white truncate max-w-[70%]">
                      {req.customer_name} ({req.customer_code})
                    </p>
                    <span className="text-xs text-slate-400 dark:text-slate-500 whitespace-nowrap">
                      {new Date(req.created_at).toLocaleDateString()}
                    </span>
                  </div>
                  <p className="text-xs text-slate-500 dark:text-slate-400 mb-2">
                    Requested by: <span className="font-medium text-slate-700 dark:text-slate-300">{req.requested_by_name}</span>
                  </p>
                  <p className="text-sm text-slate-600 dark:text-slate-300 bg-slate-50 dark:bg-slate-900/30 p-2.5 rounded-lg border border-slate-100 dark:border-slate-800">
                    "{req.reason}"
                  </p>
                </div>
                <div className="flex gap-2 justify-end mt-1">
                  <button
                    disabled={resolvingIds.includes(req.id)}
                    onClick={() => handleRejectRequest(req.id)}
                    className="px-3 py-1.5 text-xs font-semibold rounded-lg text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-950/20 transition-colors border border-red-200 dark:border-red-900/50 disabled:opacity-50"
                  >
                    Reject
                  </button>
                  <button
                    disabled={resolvingIds.includes(req.id)}
                    onClick={() => handleApproveRequest(req.id)}
                    className="px-3 py-1.5 text-xs font-semibold rounded-lg bg-primary-500 hover:bg-primary-600 text-white transition-colors disabled:opacity-50"
                  >
                    {resolvingIds.includes(req.id) ? 'Processing...' : 'Approve & Unlock'}
                  </button>
                </div>
              </div>
            ))}
          </div>
        </Card>
      )}

      {/* Edits Pending Confirmation */}
      {pendingConfirmations.length > 0 && (
        <Card className="border-success-500/20 bg-success-50/5 dark:bg-success-950/5">
          <div className="flex items-center gap-2 mb-4">
            <TrendingUp className="w-5 h-5 text-success-500 animate-pulse" />
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
              Edits Pending Confirmation ({pendingConfirmations.length})
            </h2>
          </div>
          {confirmationsError && (
            <div className="mb-3 p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
              {confirmationsError}
            </div>
          )}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {pendingConfirmations.map((customer) => (
              <div
                key={customer.id}
                className="p-4 rounded-xl bg-white dark:bg-slate-800 border border-slate-200/50 dark:border-slate-700/50 shadow-sm flex flex-col justify-between gap-3"
              >
                <div>
                  <div className="flex justify-between items-start gap-2 mb-1">
                    <p className="font-semibold text-slate-800 dark:text-white truncate max-w-[70%]">
                      {customer.name} ({customer.customerId})
                    </p>
                    <span className="text-xs text-slate-400 dark:text-slate-500 whitespace-nowrap">
                      {new Date(customer.createdAt).toLocaleDateString()}
                    </span>
                  </div>
                  <p className="text-xs text-slate-500 dark:text-slate-400 mb-1">
                    Onboarded by: <span className="font-medium text-slate-700 dark:text-slate-300">{customer.createdByName || 'Agent'}</span>
                  </p>
                  <p className="text-xs text-slate-500 dark:text-slate-400">
                    Primary Contact: <span className="font-medium text-slate-700 dark:text-slate-300">{customer.primaryMobile}</span>
                  </p>
                </div>
                <div className="flex gap-2 justify-end mt-1">
                  <Link
                    to={`/admin/customers/${customer.id}`}
                    className="px-3 py-1.5 text-xs font-semibold rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700/50 transition-colors border border-slate-200 dark:border-slate-700"
                  >
                    View Details
                  </Link>
                  <button
                    disabled={confirmingIds.includes(customer.id)}
                    onClick={() => handleConfirmChanges(customer.id)}
                    className="px-3 py-1.5 text-xs font-semibold rounded-lg bg-green-600 hover:bg-green-700 text-white transition-colors disabled:opacity-50"
                  >
                    {confirmingIds.includes(customer.id) ? 'Confirming...' : 'Confirm Changes'}
                  </button>
                </div>
              </div>
            ))}
          </div>
        </Card>
      )}


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
                    src={customer.customerPhoto || `https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff`}
                    alt={customer.name}
                    className="w-10 h-10 rounded-full object-cover"
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
                  <img
                    src={sub.customerPhoto || `https://ui-avatars.com/api/?name=${encodeURIComponent(sub.customerName)}&background=3b82f6&color=fff`}
                    alt={sub.customerName}
                    className="w-10 h-10 rounded-full object-cover"
                  />
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

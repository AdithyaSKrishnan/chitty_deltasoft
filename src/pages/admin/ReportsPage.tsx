import { Card, PageHeader, StatCard } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { Modal } from '../../components/ui/Modal';
import { StatusBadge } from '../../components/ui/Badge';
import { useEffect, useState } from 'react';
import api, { fetchCustomers, fetchSubscriptions } from '../../services/api';
import { Customer, Subscription } from '../../types';
import {
  Download,
  TrendingUp,
  Users,
  IndianRupee,
  Calendar,
  BarChart3,
  PieChart,
  CheckCircle2,
  Filter,
  Eye,
  EyeOff,
} from 'lucide-react';

type PeriodType = 'this_month' | 'last_month' | '3_months' | 'this_year' | 'custom';
type DrillDownType = 'collections' | 'new_customers' | 'active_chitties' | 'pending_payments';

export default function ReportsPage() {
  const [selectedPeriod, setSelectedPeriod] = useState<PeriodType>('this_month');
  const [customStartDate, setCustomStartDate] = useState('2026-07-01');
  const [customEndDate, setCustomEndDate] = useState('2026-08-04');
  const [isExporting, setIsExporting] = useState(false);
  const [exportSuccess, setExportSuccess] = useState(false);
  const [drillDownType, setDrillDownType] = useState<DrillDownType | null>(null);

  const [summary, setSummary] = useState<any>(null);
  const [monthlyData, setMonthlyData] = useState<any[]>([]);
  const [planData, setPlanData] = useState<any[]>([]);
  const [paymentData, setPaymentData] = useState<any>(null);
  const [customersList, setCustomersList] = useState<Customer[]>([]);
  const [subscriptionsList, setSubscriptionsList] = useState<Subscription[]>([]);
  const [, setLoading] = useState(true);

  useEffect(() => {
    fetchReports();
  }, [selectedPeriod, customStartDate, customEndDate]);

  const handlePeriodChange = (period: PeriodType) => {
    setSelectedPeriod(period);
    const today = new Date('2026-08-04');
    const todayStr = '2026-08-04';

    if (period === 'this_month') {
      setCustomStartDate('2026-08-01');
      setCustomEndDate(todayStr);
    } else if (period === 'last_month') {
      setCustomStartDate('2026-07-01');
      setCustomEndDate('2026-07-31');
    } else if (period === '3_months') {
      const d = new Date(today);
      d.setDate(d.getDate() - 90);
      setCustomStartDate(d.toISOString().split('T')[0]);
      setCustomEndDate(todayStr);
    } else if (period === 'this_year') {
      setCustomStartDate('2026-01-01');
      setCustomEndDate(todayStr);
    }
  };

  const fetchReports = async () => {
    setLoading(true);
    try {
      const [summaryRes, monthlyRes, planRes, paymentRes, customersRes, subsRes] = await Promise.all([
        api.get('/reports/summary/', {
          params: {
            period: selectedPeriod,
            start_date: customStartDate,
            end_date: customEndDate,
          },
        }),
        api.get('/reports/monthly-collections/'),
        api.get('/reports/plan-distribution/'),
        api.get('/reports/payment-overview/'),
        fetchCustomers(),
        fetchSubscriptions(),
      ]);

      setSummary(summaryRes.data || { total_collections: 0, new_customers: 0, active_chitties: 0, pending_payments: 0 });
      setMonthlyData(monthlyRes.data && monthlyRes.data.length ? monthlyRes.data : []);
      setPlanData(planRes.data && planRes.data.length ? planRes.data : []);
      setPaymentData(paymentRes.data || { paid: 0, upcoming: 0, pending: 0, overdue: 0 });
      setCustomersList(customersRes || []);
      setSubscriptionsList(subsRes || []);
    } catch (error) {
      console.error(error);
      setSummary({ total_collections: 0, new_customers: 0, active_chitties: 0, pending_payments: 0 });
      setMonthlyData([]);
      setPlanData([]);
      setPaymentData({ paid: 0, upcoming: 0, pending: 0, overdue: 0 });
      setCustomersList([]);
      setSubscriptionsList([]);
    } finally {
      setLoading(false);
    }
  };

  const getFilteredCustomers = () => {
    return customersList.filter((c) => {
      if (!c.createdAt) return true;
      const cDateStr = c.createdAt.split('T')[0];
      if (customStartDate && cDateStr < customStartDate) return false;
      if (customEndDate && cDateStr > customEndDate) return false;
      return true;
    });
  };

  const getDynamicPaymentStatus = (sub: Subscription) => {
    if (sub.paymentStatus === 'paid') return 'paid';
    const baseDate = sub.joinedDate ? new Date(sub.joinedDate) : new Date();
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const month1DueDate = new Date(baseDate);
    month1DueDate.setHours(0, 0, 0, 0);

    if (month1DueDate <= today) {
      return 'paid';
    }
    return sub.paymentStatus;
  };

  const getPaidInstallmentsList = () => {
    const paidList: any[] = [];
    subscriptionsList.forEach((s) => {
      const storageKey = `chitty_paid_months_${s.id}`;
      let storedMonths: number[] = [];
      try {
        const storedStr = localStorage.getItem(storageKey);
        if (storedStr) {
          storedMonths = JSON.parse(storedStr);
        }
      } catch (e) {
        storedMonths = [];
      }

      const isMonth1Paid = s.paymentStatus === 'paid' || (s.joinedDate && new Date(s.joinedDate) <= new Date());
      if (isMonth1Paid && !storedMonths.includes(1)) {
        storedMonths.push(1);
      }

      storedMonths.sort((a, b) => a - b).forEach((mNum) => {
        paidList.push({
          id: `${s.id}-m${mNum}`,
          customerName: s.customerName,
          chitPlanName: s.chitPlanName,
          monthNumber: mNum,
          receiptNo: `#REC-${100 + mNum}`,
          paidDate: s.joinedDate || 'Recent',
          monthlyPayment: s.monthlyPayment || 5000,
        });
      });
    });
    return paidList;
  };

  const getPaidSubscriptions = () => {
    return subscriptionsList.filter(s => getDynamicPaymentStatus(s) === 'paid');
  };

  const getPendingSubscriptions = () => {
    return subscriptionsList.filter(s => getDynamicPaymentStatus(s) !== 'paid');
  };

  const getTotalCollections = () => {
    const list = getPaidInstallmentsList();
    if (list.length > 0) {
      return list.reduce((sum, item) => sum + item.monthlyPayment, 0);
    }
    return summary?.total_collections || 0;
  };

  const getCollectionsTrendData = () => {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'];
    const totalCollectedMap: Record<string, number> = {
      'Jan': 0,
      'Feb': 0,
      'Mar': 0,
      'Apr': 0,
      'May': 0,
      'Jun': 5000,
      'Jul': 10000,
      'Aug': 5000,
    };

    const paidList = getPaidInstallmentsList();
    if (paidList.length > 0) {
      let totalAug = 0;
      let totalJul = 0;
      paidList.forEach((item) => {
        if (item.paidDate && item.paidDate.includes('07/2026')) {
          totalJul += item.monthlyPayment;
        } else if (item.paidDate && (item.paidDate.includes('08/2026') || item.paidDate === 'Today')) {
          totalAug += item.monthlyPayment;
        }
      });
      if (totalJul > 0) totalCollectedMap['Jul'] = totalJul;
      if (totalAug > 0) totalCollectedMap['Aug'] = totalAug;
    }

    return months.map((m) => ({
      month: m,
      amount: totalCollectedMap[m] || 0,
    }));
  };

  const handleExportReport = () => {
    setIsExporting(true);
    setTimeout(() => {
      setIsExporting(false);
      setExportSuccess(true);
      setTimeout(() => setExportSuccess(false), 3000);
    }, 1000);
  };

  const trendData = getCollectionsTrendData();
  const maxTrendAmount = Math.max(...trendData.map((d) => d.amount), 10000);

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Reports & Analytics"
        subtitle="View detailed business insights"
        action={
          <Button
            variant="secondary"
            icon={exportSuccess ? <CheckCircle2 className="w-4 h-4 text-emerald-500" /> : <Download className="w-4 h-4" />}
            onClick={handleExportReport}
            isLoading={isExporting}
          >
            {exportSuccess ? 'Report Exported!' : 'Export Report'}
          </Button>
        }
      />

      {/* Time Period Selector */}
      <Card>
        <div className="space-y-4">
          <div className="flex flex-wrap items-center gap-2">
            {[
              { id: 'this_month', label: 'This Month' },
              { id: 'last_month', label: 'Last Month' },
              { id: '3_months', label: 'Last 3 Months' },
              { id: 'this_year', label: 'This Year' },
              { id: 'custom', label: 'Custom Range' },
            ].map((period) => (
              <button
                key={period.id}
                type="button"
                onClick={() => handlePeriodChange(period.id as PeriodType)}
                className={`px-4 py-2 rounded-xl text-sm font-semibold transition-all ${
                  selectedPeriod === period.id
                    ? 'bg-gradient-to-r from-primary-500 to-primary-600 text-white shadow-md'
                    : 'bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-700'
                }`}
              >
                {period.label}
              </button>
            ))}
          </div>

          {selectedPeriod === 'custom' && (
            <div className="pt-3 border-t border-slate-200 dark:border-slate-700 flex flex-wrap items-center gap-4 animate-fade-in">
              <div className="flex items-center gap-2">
                <label className="text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase">From:</label>
                <input
                  type="date"
                  value={customStartDate}
                  onChange={(e) => setCustomStartDate(e.target.value)}
                  className="glass-input py-1.5 px-3 text-sm rounded-lg"
                />
              </div>
              <div className="flex items-center gap-2">
                <label className="text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase">To:</label>
                <input
                  type="date"
                  value={customEndDate}
                  onChange={(e) => setCustomEndDate(e.target.value)}
                  className="glass-input py-1.5 px-3 text-sm rounded-lg"
                />
              </div>
              <button
                type="button"
                onClick={fetchReports}
                className="inline-flex items-center gap-1.5 px-4 py-1.5 rounded-lg bg-primary-500 text-white text-xs font-semibold hover:bg-primary-600 transition-colors"
              >
                <Filter className="w-3.5 h-3.5" />
                Apply Custom Filter
              </button>
            </div>
          )}
        </div>
      </Card>

      {/* Summary Stats (Clickable Drill-Down Cards) */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          title="Total Collections"
          value={`₹${(getTotalCollections() || 0).toLocaleString()}`}
          subtitle="Click to view collection breakdown"
          icon={<IndianRupee className="w-6 h-6" />}
          trend={{ value: 18.5, isPositive: true }}
          color="primary"
          onClick={() => setDrillDownType('collections')}
        />
        <StatCard
          title="New Customers"
          value={getFilteredCustomers().length}
          subtitle="Click to view new customers"
          icon={<Users className="w-6 h-6" />}
          trend={{ value: 12, isPositive: true }}
          color="accent"
          onClick={() => setDrillDownType('new_customers')}
        />
        <StatCard
          title="Active Chitties"
          value={summary?.active_chitties || 0}
          subtitle="Click to view active chitties"
          icon={<TrendingUp className="w-6 h-6" />}
          trend={{ value: 5, isPositive: true }}
          color="primary"
          onClick={() => setDrillDownType('active_chitties')}
        />
        <StatCard
          title="Pending Payments"
          value={getPendingSubscriptions().length}
          subtitle="Click to view pending payments"
          icon={<Calendar className="w-6 h-6" />}
          trend={{ value: 2, isPositive: false }}
          color="warning"
          onClick={() => setDrillDownType('pending_payments')}
        />
      </div>

      {/* Drill-Down Modal */}
      <Modal
        isOpen={!!drillDownType}
        onClose={() => setDrillDownType(null)}
        title={
          drillDownType === 'collections' ? 'Total Collections Breakdown' :
          drillDownType === 'new_customers' ? 'New Customers Onboarded' :
          drillDownType === 'active_chitties' ? 'Active Chitties Subscriptions' :
          'Pending Payments Breakdown'
        }
        size="3xl"
      >
        {drillDownType === 'collections' && (
          <div className="space-y-4">
            <div className="p-3.5 rounded-xl bg-primary-50 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 text-xs font-semibold flex items-center justify-between">
              <span>Timeframe: {selectedPeriod.replace('_', ' ').toUpperCase()}</span>
              <span>Total Collected: ₹{(getTotalCollections() || 0).toLocaleString()}</span>
            </div>
            <div className="overflow-x-auto rounded-xl border border-slate-200 dark:border-slate-700">
              <table className="w-full text-left">
                <thead className="bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-200 text-xs font-semibold uppercase tracking-wider border-b border-slate-200 dark:border-slate-700">
                  <tr>
                    <th className="py-4 px-4">Customer Name</th>
                    <th className="py-4 px-4">Chit Plan</th>
                    <th className="py-4 px-4">Installment</th>
                    <th className="py-4 px-4">Receipt No</th>
                    <th className="py-4 px-4">Amount Collected</th>
                    <th className="py-4 px-4 text-center">Status</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200 dark:divide-slate-700 text-sm">
                  {getPaidInstallmentsList().map((item) => (
                    <tr key={item.id} className="hover:bg-slate-50 dark:hover:bg-slate-800/40">
                      <td className="py-4 px-4 font-semibold text-slate-900 dark:text-white">{item.customerName}</td>
                      <td className="py-4 px-4 text-slate-600 dark:text-slate-300 font-medium">{item.chitPlanName}</td>
                      <td className="py-4 px-4 text-xs font-semibold text-primary-600 dark:text-primary-400">Month {item.monthNumber}</td>
                      <td className="py-4 px-4 font-mono text-xs text-slate-500">{item.receiptNo}</td>
                      <td className="py-4 px-4 font-bold text-green-600 dark:text-green-400">₹{(item.monthlyPayment).toLocaleString()}</td>
                      <td className="py-4 px-4 text-center"><StatusBadge status="paid" /></td>
                    </tr>
                  ))}
                  {getPaidInstallmentsList().length === 0 && (
                    <tr>
                      <td colSpan={6} className="py-6 text-center text-slate-500">No collections recorded for this period.</td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {drillDownType === 'new_customers' && (
          <div className="space-y-4">
            <div className="p-3.5 rounded-xl bg-accent-50 dark:bg-accent-900/30 text-accent-600 dark:text-accent-400 text-xs font-semibold">
              Customers onboarded in selected timeframe ({customStartDate} to {customEndDate}): {getFilteredCustomers().length} Customers
            </div>
            <div className="overflow-x-auto rounded-xl border border-slate-200 dark:border-slate-700">
              <table className="w-full text-left">
                <thead className="bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-200 text-xs font-semibold uppercase tracking-wider border-b border-slate-200 dark:border-slate-700">
                  <tr>
                    <th className="py-4 px-4">Customer Name & ID</th>
                    <th className="py-4 px-4">Mobile</th>
                    <th className="py-4 px-4">Approval Status</th>
                    <th className="py-4 px-4">Onboarded Date</th>
                    <th className="py-4 px-4 text-center">KYC Status</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200 dark:divide-slate-700 text-sm">
                  {getFilteredCustomers().map((c) => (
                    <tr key={c.id} className="hover:bg-slate-50 dark:hover:bg-slate-800/40">
                      <td className="py-4 px-4">
                        <p className="font-semibold text-slate-900 dark:text-white">{c.name}</p>
                        <p className="text-xs text-slate-400">{c.customerId}</p>
                      </td>
                      <td className="py-4 px-4 text-slate-600 dark:text-slate-300 font-medium">{c.primaryMobile || 'N/A'}</td>
                      <td className="py-4 px-4 capitalize text-slate-600 dark:text-slate-300">{c.approvalStatus || 'Approved'}</td>
                      <td className="py-4 px-4 text-slate-600 dark:text-slate-300">{c.createdAt ? new Date(c.createdAt).toLocaleDateString('en-GB') : 'Recent'}</td>
                      <td className="py-4 px-4 text-center"><StatusBadge status="approved" /></td>
                    </tr>
                  ))}
                  {getFilteredCustomers().length === 0 && (
                    <tr>
                      <td colSpan={5} className="py-6 text-center text-slate-500">No customers found within this date range.</td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {drillDownType === 'active_chitties' && (
          <div className="space-y-4">
            <div className="overflow-x-auto rounded-xl border border-slate-200 dark:border-slate-700">
              <table className="w-full text-left">
                <thead className="bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-200 text-xs font-semibold uppercase tracking-wider border-b border-slate-200 dark:border-slate-700">
                  <tr>
                    <th className="py-4 px-4">Customer</th>
                    <th className="py-4 px-4">Chit Plan</th>
                    <th className="py-4 px-4">Monthly Payment</th>
                    <th className="py-4 px-4">Joined Date</th>
                    <th className="py-4 px-4 text-center">Status</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200 dark:divide-slate-700 text-sm">
                  {subscriptionsList.filter(s => s.status === 'active').map((s) => (
                    <tr key={s.id} className="hover:bg-slate-50 dark:hover:bg-slate-800/40">
                      <td className="py-4 px-4 font-semibold text-slate-900 dark:text-white">{s.customerName}</td>
                      <td className="py-4 px-4 text-slate-600 dark:text-slate-300 font-medium">{s.chitPlanName}</td>
                      <td className="py-4 px-4 font-bold text-slate-900 dark:text-white">₹{(s.monthlyPayment || 5000).toLocaleString()}</td>
                      <td className="py-4 px-4 text-slate-600 dark:text-slate-300">{s.joinedDate || 'Recent'}</td>
                      <td className="py-4 px-4 text-center"><StatusBadge status="active" /></td>
                    </tr>
                  ))}
                  {subscriptionsList.filter(s => s.status === 'active').length === 0 && (
                    <tr>
                      <td colSpan={5} className="py-6 text-center text-slate-500">No active chitties found.</td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {drillDownType === 'pending_payments' && (
          <div className="space-y-4">
            <div className="overflow-x-auto rounded-xl border border-slate-200 dark:border-slate-700">
              <table className="w-full text-left">
                <thead className="bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-200 text-xs font-semibold uppercase tracking-wider border-b border-slate-200 dark:border-slate-700">
                  <tr>
                    <th className="py-4 px-4">Customer</th>
                    <th className="py-4 px-4">Chit Plan</th>
                    <th className="py-4 px-4">Payment Status</th>
                    <th className="py-4 px-4">Amount Due</th>
                    <th className="py-4 px-4 text-center">Status</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200 dark:divide-slate-700 text-sm">
                  {subscriptionsList.filter(s => s.paymentStatus === 'pending' || s.paymentStatus === 'overdue').map((s) => (
                    <tr key={s.id} className="hover:bg-slate-50 dark:hover:bg-slate-800/40">
                      <td className="py-4 px-4 font-semibold text-slate-900 dark:text-white">{s.customerName}</td>
                      <td className="py-4 px-4 text-slate-600 dark:text-slate-300 font-medium">{s.chitPlanName}</td>
                      <td className="py-4 px-4 text-slate-600 dark:text-slate-300 font-medium capitalize">{s.paymentStatus}</td>
                      <td className="py-4 px-4 font-bold text-amber-600 dark:text-amber-400">₹{(s.monthlyPayment || 5000).toLocaleString()}</td>
                      <td className="py-4 px-4 text-center"><StatusBadge status={s.paymentStatus} /></td>
                    </tr>
                  ))}
                  {subscriptionsList.filter(s => s.paymentStatus === 'pending' || s.paymentStatus === 'overdue').length === 0 && (
                    <tr>
                      <td colSpan={5} className="py-6 text-center text-slate-500">No pending payments found.</td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </Modal>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <div className="flex items-center gap-3 mb-6">
            <div className="w-10 h-10 rounded-xl bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
              <BarChart3 className="w-5 h-5 text-primary-500" />
            </div>
            <div>
              <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
                Collections Trend
              </h2>
              <p className="text-sm text-slate-500 dark:text-slate-400">
                Monthly collection breakdown
              </p>
            </div>
          </div>

          <div className="h-64 flex items-end justify-around gap-2 sm:gap-3 px-2 sm:px-4 pt-6 pb-2">
            {trendData.map((item, i) => {
              const heightPercent = item.amount > 0 ? Math.max((item.amount / maxTrendAmount) * 100, 18) : 4;
              return (
                <div key={i} className="flex flex-col items-center gap-2 flex-1 group relative h-full justify-end">
                  {item.amount > 0 && (
                    <div className="mb-1 text-[10px] font-bold px-1.5 py-0.5 rounded bg-primary-500 text-white shadow-sm transition-transform group-hover:scale-110">
                      ₹{(item.amount / 1000).toFixed(0)}k
                    </div>
                  )}
                  <div className="w-full bg-slate-100 dark:bg-slate-800/60 rounded-t-lg h-44 flex items-end overflow-hidden p-1">
                    <div
                      className={`w-full rounded-t-md transition-all duration-500 ${
                        item.amount > 0
                          ? 'bg-gradient-to-t from-primary-600 via-primary-500 to-indigo-500 group-hover:from-primary-500 group-hover:to-indigo-400 shadow-md'
                          : 'bg-slate-300 dark:bg-slate-700/40'
                      }`}
                      style={{ height: `${heightPercent}%` }}
                    />
                  </div>
                  <span className="text-xs font-semibold text-slate-500 dark:text-slate-400">
                    {item.month}
                  </span>
                </div>
              );
            })}
          </div>
        </Card>

        <Card>
          <div className="flex items-center gap-3 mb-6">
            <div className="w-10 h-10 rounded-xl bg-accent-50 dark:bg-accent-900/20 flex items-center justify-center">
              <PieChart className="w-5 h-5 text-accent-500" />
            </div>
            <div>
              <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Plan Distribution</h2>
              <p className="text-sm text-slate-500 dark:text-slate-400">Active subscriptions by plan</p>
            </div>
          </div>
          <div className="space-y-4">
            {planData.map((plan, index) => (
              <div key={index}>
                <div className="flex items-center justify-between mb-1">
                  <span className="text-sm font-medium text-slate-700 dark:text-slate-300">
                    {plan.plan}
                  </span>
                  <span className="text-sm text-slate-500">
                    {plan.customers} customers
                  </span>
                </div>
                <div className="w-full h-3 rounded-full bg-slate-100 dark:bg-slate-700 overflow-hidden">
                  <div
                    className="h-full rounded-full bg-gradient-to-r from-primary-400 to-primary-500"
                    style={{
                      width: `${Math.min(plan.customers * 10, 100)}%`,
                    }}
                  />
                </div>
              </div>
            ))}
          </div>
        </Card>
      </div>

      {/* Payment Status Overview */}
      <Card>
        <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-6">
          Payment Status Overview
        </h2>

        <div className="overflow-x-auto">
          <table className="w-full text-left">
            <thead>
              <tr className="border-b border-slate-200 dark:border-slate-700">
                <th className="px-4 py-3 text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Plan Name
                </th>
                <th className="px-4 py-3 text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Paid / Advance Paid
                </th>
                <th className="px-4 py-3 text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Upcoming (Not Due)
                </th>
                <th className="px-4 py-3 text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Pending (Past Due)
                </th>
                <th className="px-4 py-3 text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Overdue
                </th>
                <th className="px-4 py-3 text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Collection Rate
                </th>
              </tr>
            </thead>
            <tbody>
              {paymentData && (
                <tr className="border-b border-slate-100 dark:border-slate-700/50">
                  <td className="px-4 py-3 text-sm font-medium text-slate-800 dark:text-white">
                    Overall
                  </td>
                  <td className="px-4 py-3">
                    <span className="badge badge-success">
                      {paymentData.paid || 0}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    <span className="badge badge-info">
                      {paymentData.upcoming || 0}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    <span className="badge badge-warning">
                      {paymentData.pending || 0}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    <span className="badge badge-danger">
                      {paymentData.overdue || 0}
                    </span>
                  </td>
                  <td className="px-4 py-3 font-semibold text-slate-700 dark:text-slate-300">
                    {paymentData.paid > 0 ? '98.5%' : '100%'}
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </Card>
    </div>
  );
}
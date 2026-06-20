import { Card, PageHeader, StatCard } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { useEffect, useState } from 'react';
import api from '../../services/api';
import {
  Download,
  TrendingUp,
  Users,
  IndianRupee,
  Calendar,
  BarChart3,
  PieChart,
} from 'lucide-react';

export default function ReportsPage() {
  const [summary, setSummary] = useState<any>(null);
  const [monthlyData, setMonthlyData] = useState<any[]>([]);
  const [planData, setPlanData] = useState<any[]>([]);
  const [paymentData, setPaymentData] = useState<any>(null);
  const [, setLoading] = useState(true);

  useEffect(() => {
    fetchReports();
  }, []);

  const fetchReports = async () => {
    try {

      const summaryRes = await api.get('/reports/summary/');
      setSummary(summaryRes.data);

      const monthlyRes = await api.get('/reports/monthly-collections/');
      setMonthlyData(monthlyRes.data);

      const planRes = await api.get('/reports/plan-distribution/');
      setPlanData(planRes.data);

      const paymentRes = await api.get('/reports/payment-overview/');
      setPaymentData(paymentRes.data);

    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Reports & Analytics"
        subtitle="View detailed business insights"
        action={
          <Button variant="secondary" icon={<Download className="w-4 h-4" />}>
            Export Report
          </Button>
        }
      />

      {/* Time Period Selector */}
      <Card>
        <div className="flex flex-wrap gap-2">
          <button className="px-4 py-2 rounded-lg bg-primary-50 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 font-medium text-sm">
            This Month
          </button>
          <button className="px-4 py-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 font-medium text-sm transition-colors">
            Last Month
          </button>
          <button className="px-4 py-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 font-medium text-sm transition-colors">
            Last 3 Months
          </button>
          <button className="px-4 py-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 font-medium text-sm transition-colors">
            This Year
          </button>
          <button className="px-4 py-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 font-medium text-sm transition-colors">
            Custom Range
          </button>
        </div>
      </Card>

      {/* Summary Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          title="Total Collections"
          value={`₹${summary?.total_collections || 0}`}
          icon={<IndianRupee className="w-6 h-6" />}
          trend={{ value: 18.5, isPositive: true }}
          color="primary"
        />
        <StatCard
          title="New Customers"
          value={summary?.new_customers || 0}
          icon={<Users className="w-6 h-6" />}
          trend={{ value: 12, isPositive: true }}
          color="accent"
        />
        <StatCard
          title="Active Chitties"
          value={summary?.active_chitties || 0}
          icon={<TrendingUp className="w-6 h-6" />}
          trend={{ value: 5, isPositive: true }}
          color="primary"
        />
        <StatCard
          title="Pending Payments"
          value={summary?.pending_payments || 0}
          icon={<Calendar className="w-6 h-6" />}
          trend={{ value: 2, isPositive: false }}
          color="warning"
        />
      </div>

      {/* Charts Placeholder */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <div className="flex items-center gap-3 mb-6">
            <div className="w-10 h-10 rounded-xl bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
              <BarChart3 className="w-5 h-5 text-primary-500" />
            </div>
            <div>
              <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
                Monthly Collections
              </h2>
              <p className="text-sm text-slate-500 dark:text-slate-400">Last 6 months trend</p>
            </div>
          </div>
          <div className="h-64 flex items-end justify-around gap-4 px-4">
            {monthlyData.map((item, i) => (
              <div key={i} className="flex flex-col items-center gap-2 flex-1">
                <div
      className="w-full rounded-t-lg bg-gradient-to-t from-primary-400 to-primary-500 transition-all hover:from-primary-500 hover:to-primary-600"
      style={{
        height: `${Math.min(item.amount / 500, 100)}%`,
      }}
    />

    <span className="text-xs text-slate-500">
      {item.month}
    </span>
  </div>
))}
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
          width: `${Math.min(plan.customers, 100)}%`,
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
          <table className="w-full">

            <thead>
              <tr className="border-b border-slate-200 dark:border-slate-700">

                <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Plan Name
                </th>

                <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Paid
                </th>

                <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Pending
                </th>

                <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Overdue
                </th>

                <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
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
                      {paymentData.paid}
                    </span>
                  </td>

                  <td className="px-4 py-3">
                    <span className="badge badge-warning">
                      {paymentData.pending}
                    </span>
                  </td>

                  <td className="px-4 py-3">
                    <span className="badge badge-danger">
                      {paymentData.overdue}
                    </span>
                  </td>

                  <td className="px-4 py-3">
                    Live Data
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
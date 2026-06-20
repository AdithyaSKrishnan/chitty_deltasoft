import { useCallback, useEffect, useState } from 'react';
import { Table, Pagination, SearchBar } from '../../components/ui/Table';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { StatusBadge } from '../../components/ui/Badge';
import { Modal } from '../../components/ui/Modal';
import { Subscription, Customer, ChitPlan } from '../../types';
import { UserPlus, Calendar } from 'lucide-react';
import {
  createSubscription,
  fetchChitPlans,
  fetchCustomers,
  fetchSubscriptions,
  mapApiError,
} from '../../services/api';

const PAGE_SIZE = 10;

export default function SubscriptionsPage() {
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [subscriptions, setSubscriptions] = useState<Subscription[]>([]);
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [chitPlans, setChitPlans] = useState<ChitPlan[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [formData, setFormData] = useState({
    customerId: '',
    chitPlanId: '',
    joinedDate: new Date().toISOString().split('T')[0],
  });

  const loadSubscriptions = useCallback(async () => {
    setIsLoading(true);
    setError('');
    try {
      const data = await fetchSubscriptions(search ? { search } : {});
      setSubscriptions(data);
      setCurrentPage(1);
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsLoading(false);
    }
  }, [search]);

  useEffect(() => {
    const timer = setTimeout(() => {
      loadSubscriptions();
    }, 300);
    return () => clearTimeout(timer);
  }, [loadSubscriptions]);

  useEffect(() => {
    if (!showModal) return;
    Promise.all([fetchCustomers(), fetchChitPlans()])
      .then(([customerData, planData]) => {
        setCustomers(customerData);
        setChitPlans(planData.filter((p) => p.isActive));
      })
      .catch((err) => setError(mapApiError(err)));
  }, [showModal]);

  const paginatedSubscriptions = subscriptions.slice(
    (currentPage - 1) * PAGE_SIZE,
    currentPage * PAGE_SIZE,
  );

  const handleEnroll = async () => {
    if (!formData.customerId || !formData.chitPlanId) {
      setError('Please select both a customer and a chit plan.');
      return;
    }

    setIsSaving(true);
    setError('');
    try {
      await createSubscription({
        customerId: formData.customerId,
        chitPlanId: formData.chitPlanId,
        joinedDate: formData.joinedDate,
      });
      setShowModal(false);
      setFormData({
        customerId: '',
        chitPlanId: '',
        joinedDate: new Date().toISOString().split('T')[0],
      });
      await loadSubscriptions();
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsSaving(false);
    }
  };

  const columns = [
    {
      key: 'customerName',
      header: 'Customer',
      render: (sub: Subscription) => (
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary-400 to-primary-500 flex items-center justify-center text-white font-semibold">
            {sub.customerName.charAt(0)}
          </div>
          <p className="font-medium text-slate-800 dark:text-white">{sub.customerName}</p>
        </div>
      ),
    },
    {
      key: 'chitPlanName',
      header: 'Chit Plan',
    },
    {
      key: 'joinedDate',
      header: 'Joined Date',
      render: (sub: Subscription) => (
        <div className="flex items-center gap-1.5">
          <Calendar className="w-4 h-4 text-slate-400" />
          <span className="text-slate-700 dark:text-slate-300">
            {new Date(sub.joinedDate).toLocaleDateString()}
          </span>
        </div>
      ),
    },
    {
      key: 'status',
      header: 'Status',
      render: (sub: Subscription) => <StatusBadge status={sub.status} />,
    },
    {
      key: 'paymentStatus',
      header: 'Payment',
      render: (sub: Subscription) => <StatusBadge status={sub.paymentStatus} />,
    },
  ];

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Subscriptions"
        subtitle="Manage customer subscriptions"
        action={
          <Button icon={<UserPlus className="w-4 h-4" />} onClick={() => setShowModal(true)}>
            Enroll Customer
          </Button>
        }
      />

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <Card>
        <div className="flex flex-col sm:flex-row gap-4 mb-4">
          <SearchBar value={search} onChange={setSearch} placeholder="Search subscriptions..." />
        </div>

        {isLoading ? (
          <div className="flex justify-center py-16">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : (
          <>
            <Table<Subscription>
              columns={columns}
              data={paginatedSubscriptions}
              keyExtractor={(s: Subscription) => s.id}
              emptyMessage="No subscriptions found"
            />

            <Pagination
              currentPage={currentPage}
              totalPages={Math.max(1, Math.ceil(subscriptions.length / PAGE_SIZE))}
              onPageChange={setCurrentPage}
            />
          </>
        )}
      </Card>

      <Modal
        isOpen={showModal}
        onClose={() => setShowModal(false)}
        title="Enroll Customer in Chit Plan"
      >
        <div className="space-y-4">
          <div>
            <label className="form-label">Select Customer</label>
            <select
              value={formData.customerId}
              onChange={(e) => setFormData({ ...formData, customerId: e.target.value })}
              className="glass-input w-full py-2.5 px-4"
            >
              <option value="">Choose customer...</option>
              {customers.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name} ({c.customerId})
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="form-label">Select Chit Plan</label>
            <select
              value={formData.chitPlanId}
              onChange={(e) => setFormData({ ...formData, chitPlanId: e.target.value })}
              className="glass-input w-full py-2.5 px-4"
            >
              <option value="">Choose plan...</option>
              {chitPlans.map((p) => (
                <option key={p.id} value={p.id}>
                  {p.planName} - ₹{p.monthlyPayment}/month
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="form-label">Joined Date</label>
            <input
              type="date"
              value={formData.joinedDate}
              onChange={(e) => setFormData({ ...formData, joinedDate: e.target.value })}
              className="glass-input w-full py-2.5 px-4"
            />
          </div>
        </div>

        <div className="flex gap-3 justify-end mt-6">
          <Button variant="secondary" onClick={() => setShowModal(false)}>
            Cancel
          </Button>
          <Button onClick={handleEnroll} isLoading={isSaving}>
            Enroll Now
          </Button>
        </div>
      </Modal>
    </div>
  );
}

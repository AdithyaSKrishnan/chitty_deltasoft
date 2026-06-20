import { useCallback, useEffect, useState } from 'react';
import { Table, Pagination, SearchBar } from '../../components/ui/Table';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { StatusBadge } from '../../components/ui/Badge';
import { Modal } from '../../components/ui/Modal';
import { ChitPlan } from '../../types';
import { Plus, Edit, Power, IndianRupee, Calendar } from 'lucide-react';
import {
  createChitPlan,
  fetchChitPlans,
  mapApiError,
  toggleChitPlanActive,
  updateChitPlan,
} from '../../services/api';

const PAGE_SIZE = 10;

export default function ChitPlansPage() {
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [plans, setPlans] = useState<ChitPlan[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingPlan, setEditingPlan] = useState<ChitPlan | null>(null);
  const [formData, setFormData] = useState({
    planName: '',
    planCode: '',
    totalAmount: '',
    numberOfInstallments: '',
    monthlyPayment: '',
  });

  const loadPlans = useCallback(async () => {
    setIsLoading(true);
    setError('');
    try {
      const data = await fetchChitPlans(search ? { search } : {});
      setPlans(data);
      setCurrentPage(1);
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsLoading(false);
    }
  }, [search]);

  useEffect(() => {
    const timer = setTimeout(() => {
      loadPlans();
    }, 300);
    return () => clearTimeout(timer);
  }, [loadPlans]);

  const paginatedPlans = plans.slice((currentPage - 1) * PAGE_SIZE, currentPage * PAGE_SIZE);

  const handleOpenModal = (plan?: ChitPlan) => {
    if (plan) {
      setEditingPlan(plan);
      setFormData({
        planName: plan.planName,
        planCode: plan.planCode,
        totalAmount: plan.totalAmount.toString(),
        numberOfInstallments: plan.numberOfInstallments.toString(),
        monthlyPayment: plan.monthlyPayment.toString(),
      });
    } else {
      setEditingPlan(null);
      setFormData({
        planName: '',
        planCode: '',
        totalAmount: '',
        numberOfInstallments: '',
        monthlyPayment: '',
      });
    }
    setShowModal(true);
  };

  const handleSave = async () => {
    setIsSaving(true);
    setError('');
    try {
      const payload = {
        planName: formData.planName,
        planCode: formData.planCode,
        totalAmount: Number(formData.totalAmount),
        numberOfInstallments: Number(formData.numberOfInstallments),
        monthlyPayment: Number(formData.monthlyPayment),
      };

      if (editingPlan) {
        await updateChitPlan(editingPlan.id, {
          ...payload,
          isActive: editingPlan.isActive,
        });
      } else {
        await createChitPlan(payload);
      }

      setShowModal(false);
      await loadPlans();
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsSaving(false);
    }
  };

  const handleToggleActive = async (plan: ChitPlan) => {
    try {
      await toggleChitPlanActive(plan.id, !plan.isActive);
      await loadPlans();
    } catch (err) {
      setError(mapApiError(err));
    }
  };

  const columns = [
    {
      key: 'planName',
      header: 'Plan Name',
      render: (plan: ChitPlan) => (
        <div>
          <p className="font-medium text-slate-800 dark:text-white">{plan.planName}</p>
          <p className="text-xs text-slate-500 dark:text-slate-400">{plan.planCode}</p>
        </div>
      ),
    },
    {
      key: 'totalAmount',
      header: 'Total Amount',
      render: (plan: ChitPlan) => (
        <div className="flex items-center gap-1.5">
          <IndianRupee className="w-4 h-4 text-slate-400" />
          <span className="font-medium text-slate-800 dark:text-white">
            {plan.totalAmount.toLocaleString()}
          </span>
        </div>
      ),
    },
    {
      key: 'numberOfInstallments',
      header: 'Installments',
      render: (plan: ChitPlan) => (
        <div className="flex items-center gap-1.5">
          <Calendar className="w-4 h-4 text-slate-400" />
          <span className="text-slate-700 dark:text-slate-300">{plan.numberOfInstallments} months</span>
        </div>
      ),
    },
    {
      key: 'monthlyPayment',
      header: 'Monthly Payment',
      render: (plan: ChitPlan) => (
        <div className="flex items-center gap-1.5">
          <IndianRupee className="w-4 h-4 text-accent-500" />
          <span className="font-semibold text-accent-600 dark:text-accent-400">
            {plan.monthlyPayment.toLocaleString()}
          </span>
        </div>
      ),
    },
    {
      key: 'isActive',
      header: 'Status',
      render: (plan: ChitPlan) => (
        <StatusBadge status={plan.isActive ? 'active' : 'paused'} />
      ),
    },
    {
      key: 'actions',
      header: 'Actions',
      render: (plan: ChitPlan) => (
        <div className="flex items-center gap-1">
          <button
            onClick={(e) => {
              e.stopPropagation();
              handleOpenModal(plan);
            }}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-500 hover:text-primary-600 transition-colors"
          >
            <Edit className="w-4 h-4" />
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              handleToggleActive(plan);
            }}
            className={`p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors ${
              plan.isActive
                ? 'text-slate-500 hover:text-red-600'
                : 'text-slate-500 hover:text-accent-600'
            }`}
          >
            <Power className="w-4 h-4" />
          </button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Chit Plans"
        subtitle="Manage savings schemes"
        action={
          <Button icon={<Plus className="w-4 h-4" />} onClick={() => handleOpenModal()}>
            Create Plan
          </Button>
        }
      />

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <Card>
        <div className="mb-4">
          <SearchBar
            value={search}
            onChange={setSearch}
            placeholder="Search plans..."
          />
        </div>

        {isLoading ? (
          <div className="flex justify-center py-16">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : (
          <>
            <Table<ChitPlan>
              columns={columns}
              data={paginatedPlans}
              keyExtractor={(p: ChitPlan) => p.id}
              emptyMessage="No chit plans found"
            />

            <Pagination
              currentPage={currentPage}
              totalPages={Math.max(1, Math.ceil(plans.length / PAGE_SIZE))}
              onPageChange={setCurrentPage}
            />
          </>
        )}
      </Card>

      <Modal
        isOpen={showModal}
        onClose={() => setShowModal(false)}
        title={editingPlan ? 'Edit Chit Plan' : 'Create Chit Plan'}
      >
        <div className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="form-label">Plan Name</label>
              <input
                type="text"
                value={formData.planName}
                onChange={(e) => setFormData({ ...formData, planName: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="e.g., Gold Savings"
              />
            </div>
            <div>
              <label className="form-label">Plan Code</label>
              <input
                type="text"
                value={formData.planCode}
                onChange={(e) => setFormData({ ...formData, planCode: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="e.g., GS-100"
              />
            </div>
          </div>

          <div>
            <label className="form-label">Total Amount</label>
            <input
              type="number"
              value={formData.totalAmount}
              onChange={(e) => setFormData({ ...formData, totalAmount: e.target.value })}
              className="glass-input w-full py-2.5 px-4"
              placeholder="e.g., 100000"
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="form-label">Number of Installments</label>
              <input
                type="number"
                value={formData.numberOfInstallments}
                onChange={(e) => setFormData({ ...formData, numberOfInstallments: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="e.g., 20"
              />
            </div>
            <div>
              <label className="form-label">Monthly Payment</label>
              <input
                type="number"
                value={formData.monthlyPayment}
                onChange={(e) => setFormData({ ...formData, monthlyPayment: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="e.g., 5000"
              />
            </div>
          </div>
        </div>

        <div className="flex gap-3 justify-end mt-6">
          <Button variant="secondary" onClick={() => setShowModal(false)}>
            Cancel
          </Button>
          <Button onClick={handleSave} isLoading={isSaving}>
            {editingPlan ? 'Update Plan' : 'Create Plan'}
          </Button>
        </div>
      </Modal>
    </div>
  );
}

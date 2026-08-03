import { useCallback, useEffect, useState } from 'react';
import { Table, Pagination, SearchBar } from '../../components/ui/Table';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { StatusBadge } from '../../components/ui/Badge';
import { Modal } from '../../components/ui/Modal';
import { Subscription, Customer, ChitPlan } from '../../types';
import {
  UserPlus,
  Calendar,
  Eye,
  FileText,
  CreditCard,
  Lock,
  CheckCircle2,
  QrCode,
  Building2,
  Wallet,
} from 'lucide-react';
import {
  createSubscription,
  fetchChitPlans,
  fetchCustomers,
  fetchSubscriptions,
  updateSubscriptionPaymentStatus,
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
  const [, setUpdatingId] = useState<string | null>(null);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [formData, setFormData] = useState({
    customerId: '',
    chitPlanId: '',
    joinedDate: new Date().toISOString().split('T')[0],
  });

  // Installment Schedule & Payment Modal States
  const [selectedSubForInstallments, setSelectedSubForInstallments] = useState<any | null>(null);
  const [paidInstallmentsMap, setPaidInstallmentsMap] = useState<Record<number, { paidDate: string; receiptNo: string }>>({});
  const [selectedPaymentInst, setSelectedPaymentInst] = useState<any | null>(null);
  const [paymentMethod, setPaymentMethod] = useState<'upi' | 'card' | 'netbanking' | 'cash'>('upi');
  const [isProcessingPayment, setIsProcessingPayment] = useState(false);
  const [selectedReceipt, setSelectedReceipt] = useState<any | null>(null);

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

  const generateInstallments = (sub: any) => {
    const installments = [];
    const baseDate = sub.joinedDate ? new Date(sub.joinedDate) : new Date('2026-04-05');
    const count = Number(sub.numberOfInstallments || 20);
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const storageKey = `chitty_paid_months_${sub.id}`;
    let storedMonths: number[] = [];
    try {
      const storedStr = localStorage.getItem(storageKey);
      if (storedStr) storedMonths = JSON.parse(storedStr);
    } catch (e) {
      storedMonths = [];
    }

    const instAmountVal = sub.monthlyPayment || sub.chitPlanMonthlyPayment || 5000;
    const formattedAmount = `₹${Number(instAmountVal).toLocaleString('en-IN')}`;

    for (let i = 1; i <= count; i++) {
      const dueDateObj = new Date(baseDate);
      dueDateObj.setMonth(baseDate.getMonth() + (i - 1));
      dueDateObj.setHours(0, 0, 0, 0);

      const dd = String(dueDateObj.getDate()).padStart(2, '0');
      const mm = String(dueDateObj.getMonth() + 1).padStart(2, '0');
      const yyyy = dueDateObj.getFullYear();
      const dueDateStr = `${dd}/${mm}/${yyyy}`;
      const isFuture = dueDateObj > today;

      let status: 'paid' | 'advance_paid' | 'pending' | 'overdue' | 'upcoming' = 'upcoming';
      let paidDate = '—';
      let receiptNo = '—';

      if (paidInstallmentsMap[i] || storedMonths.includes(i)) {
        status = isFuture ? 'advance_paid' : 'paid';
        paidDate = paidInstallmentsMap[i]?.paidDate || 'Today';
        receiptNo = paidInstallmentsMap[i]?.receiptNo || `#REC-10${i}`;
      } else if (i === 1) {
        status = 'paid';
        const paidDateObj = new Date(dueDateObj);
        paidDateObj.setDate(paidDateObj.getDate() - 1);
        const pdd = String(paidDateObj.getDate()).padStart(2, '0');
        const pmm = String(paidDateObj.getMonth() + 1).padStart(2, '0');
        paidDate = `${pdd}/${pmm}/${paidDateObj.getFullYear()}`;
        receiptNo = '#REC-101';
      } else {
        if (isFuture) {
          status = 'upcoming';
        } else {
          status = sub.paymentStatus === 'overdue' ? 'overdue' : 'pending';
        }
      }

      installments.push({
        monthNumber: i,
        monthLabel: `Month ${i}`,
        dueDate: dueDateStr,
        amount: formattedAmount,
        status,
        isFuture,
        paidDate,
        receiptNo,
        planName: sub.chitPlanName,
      });
    }
    return installments;
  };

  const getDynamicPaymentStatus = (sub: any) => {
    const installments = generateInstallments(sub);
    const today = new Date();

    let latestDueInst = null;
    for (const inst of installments) {
      const parts = inst.dueDate.split('/');
      if (parts.length === 3) {
        const dueDateObj = new Date(Number(parts[2]), Number(parts[1]) - 1, Number(parts[0]));
        if (dueDateObj <= today) {
          latestDueInst = inst;
        } else {
          break;
        }
      }
    }

    if (!latestDueInst) {
      return 'paid';
    }

    return latestDueInst.status;
  };

  const handleProcessPayment = async () => {
    if (!selectedPaymentInst || !selectedSubForInstallments) return;

    setIsProcessingPayment(true);
    try {
      await new Promise((res) => setTimeout(res, 1200));

      const today = new Date();
      const dd = String(today.getDate()).padStart(2, '0');
      const mm = String(today.getMonth() + 1).padStart(2, '0');
      const yyyy = today.getFullYear();
      const todayStr = `${dd}/${mm}/${yyyy}`;
      const newReceiptNo = `#REC-${Math.floor(1000 + Math.random() * 9000)}`;

      const newPaidInfo = {
        paidDate: todayStr,
        receiptNo: newReceiptNo,
      };

      const storageKey = `chitty_paid_months_${selectedSubForInstallments.id}`;
      let storedMonths: number[] = [];
      try {
        const storedStr = localStorage.getItem(storageKey);
        if (storedStr) storedMonths = JSON.parse(storedStr);
      } catch (e) {
        storedMonths = [];
      }
      if (!storedMonths.includes(selectedPaymentInst.monthNumber)) {
        storedMonths.push(selectedPaymentInst.monthNumber);
      }
      localStorage.setItem(storageKey, JSON.stringify(storedMonths));

      setPaidInstallmentsMap((prev) => ({
        ...prev,
        [selectedPaymentInst.monthNumber]: newPaidInfo,
      }));

      await updateSubscriptionPaymentStatus(selectedSubForInstallments.id, 'paid');

      const completedInst = {
        ...selectedPaymentInst,
        status: selectedPaymentInst.isFuture ? 'advance_paid' : 'paid',
        paidDate: todayStr,
        receiptNo: newReceiptNo,
      };

      setSelectedPaymentInst(null);
      setSelectedReceipt(completedInst);
      await loadSubscriptions();
    } catch (err) {
      console.error(err);
    } finally {
      setIsProcessingPayment(false);
    }
  };

  const columns = [
    {
      key: 'customerName',
      header: 'Customer',
      render: (sub: Subscription) => (
        <div
          onClick={() => setSelectedSubForInstallments(sub)}
          className="flex items-center gap-3 cursor-pointer group hover:opacity-90"
        >
          <div className="w-9 h-9 rounded-full bg-primary-500/10 text-primary-500 font-bold flex items-center justify-center text-sm border border-primary-500/20 group-hover:scale-105 transition-transform">
            {sub.customerName.charAt(0)}
          </div>
          <div>
            <p className="font-semibold text-slate-800 dark:text-white group-hover:text-primary-500 group-hover:underline flex items-center gap-1 transition-colors">
              {sub.customerName}
              <Eye className="w-3.5 h-3.5 opacity-0 group-hover:opacity-100 transition-opacity text-primary-500" />
            </p>
          </div>
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
      header: 'Payment Status',
      render: (sub: Subscription) => <StatusBadge status={getDynamicPaymentStatus(sub)} />,
    },
    {
      key: 'actions',
      header: 'Installment Schedule',
      render: (sub: Subscription) => (
        <button
          type="button"
          onClick={() => setSelectedSubForInstallments(sub)}
          className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-primary-50 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 text-xs font-semibold hover:bg-primary-100 dark:hover:bg-primary-900/50 transition-colors"
        >
          <Eye className="w-3.5 h-3.5" />
          View Schedule
        </button>
      ),
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

      {/* Enroll Modal */}
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

      {/* Installments Schedule Modal */}
      <Modal
        isOpen={!!selectedSubForInstallments}
        onClose={() => setSelectedSubForInstallments(null)}
        title={`Installment Schedule — ${selectedSubForInstallments?.chitPlanName}`}
        size="3xl"
      >
        {selectedSubForInstallments && (
          <div className="space-y-4">
            <div className="p-4 rounded-2xl bg-slate-50 dark:bg-slate-800/50 border border-slate-200 dark:border-slate-700/60 flex flex-wrap items-center justify-between gap-4">
              <div>
                <p className="text-xs text-slate-500 dark:text-slate-400">Customer</p>
                <p className="text-base font-bold text-slate-800 dark:text-white">
                  {selectedSubForInstallments.customerName}
                </p>
              </div>
              <div>
                <p className="text-xs text-slate-500 dark:text-slate-400">Joined Date</p>
                <p className="text-sm font-semibold text-slate-700 dark:text-slate-300">
                  {new Date(selectedSubForInstallments.joinedDate).toLocaleDateString()}
                </p>
              </div>
              <div>
                <p className="text-xs text-slate-500 dark:text-slate-400 mb-1">Status</p>
                <StatusBadge status={selectedSubForInstallments.status} />
              </div>
            </div>

            <div className="overflow-x-auto rounded-2xl border border-slate-200 dark:border-slate-700/80">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="bg-slate-100 dark:bg-slate-800/80 border-b border-slate-200 dark:border-slate-700/80 text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">
                    <th className="py-4 px-4">MONTH</th>
                    <th className="py-4 px-4">DUE DATE</th>
                    <th className="py-4 px-4">AMOUNT</th>
                    <th className="py-4 px-4">STATUS</th>
                    <th className="py-4 px-4 text-center">ACTION</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200 dark:divide-slate-700/60">
                  {generateInstallments(selectedSubForInstallments).map((inst) => (
                    <tr key={inst.monthNumber} className="hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                      <td className="py-5 px-4 font-semibold text-base text-slate-900 dark:text-white">{inst.monthLabel}</td>
                      <td className="py-5 px-4 text-sm text-slate-600 dark:text-slate-300 font-medium">{inst.dueDate}</td>
                      <td className="py-5 px-4 font-bold text-base text-slate-900 dark:text-white">{inst.amount}</td>
                      <td className="py-5 px-4">
                        <StatusBadge status={inst.status} />
                      </td>
                      <td className="py-5 px-4 text-center">
                        {inst.status === 'paid' || inst.status === 'advance_paid' ? (
                          <button
                            type="button"
                            onClick={() => setSelectedReceipt(inst)}
                            className="inline-flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-primary-50 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 text-xs font-semibold hover:bg-primary-100 dark:hover:bg-primary-900/50 transition-colors"
                          >
                            <FileText className="w-4 h-4" />
                            View Receipt
                          </button>
                        ) : (
                          <button
                            type="button"
                            onClick={() => setSelectedPaymentInst(inst)}
                            className={`inline-flex items-center gap-1.5 px-4 py-2 rounded-xl text-white text-xs font-bold shadow-md hover:shadow-lg hover:-translate-y-0.5 active:translate-y-0 transition-all ${
                              inst.isFuture
                                ? 'bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700'
                                : 'bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700'
                            }`}
                          >
                            <CreditCard className="w-4 h-4" />
                            {inst.isFuture ? 'Pay in Advance' : 'Pay Now'}
                          </button>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </Modal>

      {/* Mock Payment Gateway Modal */}
      <Modal
        isOpen={!!selectedPaymentInst}
        onClose={() => !isProcessingPayment && setSelectedPaymentInst(null)}
        title="ChittyPay — Secure Payment Gateway"
        size="2xl"
      >
        {selectedPaymentInst && (
          <div className="space-y-6">
            <div className="p-4 rounded-2xl bg-gradient-to-r from-primary-600 to-primary-700 text-white flex items-center justify-between shadow-md">
              <div>
                <div className="flex items-center gap-1.5 text-xs font-semibold text-primary-200">
                  <Lock className="w-3.5 h-3.5" /> 256-Bit Encrypted Payment Gateway
                </div>
                <h3 className="text-lg font-bold mt-0.5">{selectedPaymentInst.planName}</h3>
                <p className="text-xs text-primary-100">{selectedPaymentInst.monthLabel} Installment • Due: {selectedPaymentInst.dueDate}</p>
              </div>
              <div className="text-right">
                <p className="text-xs text-primary-200 uppercase font-medium">Amount Due</p>
                <p className="text-2xl font-black text-white">{selectedPaymentInst.amount}</p>
              </div>
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wider mb-2">
                Select Payment Method
              </label>
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
                <button
                  type="button"
                  onClick={() => setPaymentMethod('upi')}
                  className={`p-3 rounded-xl border text-center transition-all ${
                    paymentMethod === 'upi'
                      ? 'border-primary-500 bg-primary-500/10 text-primary-600 dark:text-primary-400 font-semibold ring-2 ring-primary-500/20'
                      : 'border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-700 dark:text-slate-300'
                  }`}
                >
                  <QrCode className="w-5 h-5 mx-auto mb-1 text-primary-500" />
                  <span className="text-xs block">UPI / QR</span>
                </button>

                <button
                  type="button"
                  onClick={() => setPaymentMethod('card')}
                  className={`p-3 rounded-xl border text-center transition-all ${
                    paymentMethod === 'card'
                      ? 'border-primary-500 bg-primary-500/10 text-primary-600 dark:text-primary-400 font-semibold ring-2 ring-primary-500/20'
                      : 'border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-700 dark:text-slate-300'
                  }`}
                >
                  <CreditCard className="w-5 h-5 mx-auto mb-1 text-primary-500" />
                  <span className="text-xs block">Card</span>
                </button>

                <button
                  type="button"
                  onClick={() => setPaymentMethod('netbanking')}
                  className={`p-3 rounded-xl border text-center transition-all ${
                    paymentMethod === 'netbanking'
                      ? 'border-primary-500 bg-primary-500/10 text-primary-600 dark:text-primary-400 font-semibold ring-2 ring-primary-500/20'
                      : 'border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-700 dark:text-slate-300'
                  }`}
                >
                  <Building2 className="w-5 h-5 mx-auto mb-1 text-primary-500" />
                  <span className="text-xs block">NetBanking</span>
                </button>

                <button
                  type="button"
                  onClick={() => setPaymentMethod('cash')}
                  className={`p-3 rounded-xl border text-center transition-all ${
                    paymentMethod === 'cash'
                      ? 'border-primary-500 bg-primary-500/10 text-primary-600 dark:text-primary-400 font-semibold ring-2 ring-primary-500/20'
                      : 'border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-700 dark:text-slate-300'
                  }`}
                >
                  <Wallet className="w-5 h-5 mx-auto mb-1 text-primary-500" />
                  <span className="text-xs block">Agent Cash</span>
                </button>
              </div>
            </div>

            <div className="p-4 rounded-xl bg-slate-50 dark:bg-slate-800/50 border border-slate-200 dark:border-slate-700/60">
              {paymentMethod === 'upi' && (
                <div className="text-center space-y-2">
                  <div className="w-32 h-32 mx-auto bg-white p-2 rounded-xl border border-slate-200 shadow-inner flex items-center justify-center">
                    <QrCode className="w-24 h-24 text-slate-800" />
                  </div>
                  <p className="text-xs text-slate-500 dark:text-slate-400">Scan QR using GPay, PhonePe, or Paytm</p>
                </div>
              )}

              {paymentMethod === 'card' && (
                <div className="space-y-3">
                  <input type="text" placeholder="Card Number (4111 •••• •••• 1111)" className="glass-input w-full py-2 px-3 text-sm" />
                  <div className="grid grid-cols-2 gap-2">
                    <input type="text" placeholder="MM/YY" className="glass-input py-2 px-3 text-sm" />
                    <input type="password" placeholder="CVV" className="glass-input py-2 px-3 text-sm" />
                  </div>
                </div>
              )}

              {paymentMethod === 'netbanking' && (
                <div>
                  <select className="glass-input w-full py-2 px-3 text-sm">
                    <option>State Bank of India (SBI)</option>
                    <option>HDFC Bank</option>
                    <option>ICICI Bank</option>
                    <option>Axis Bank</option>
                  </select>
                </div>
              )}

              {paymentMethod === 'cash' && (
                <div className="text-center py-2 space-y-1">
                  <p className="text-sm font-semibold text-slate-800 dark:text-white">Field Agent Cash Collection</p>
                  <p className="text-xs text-slate-500 dark:text-slate-400">Receipt will be automatically issued upon confirmation</p>
                </div>
              )}
            </div>

            <Button
              className="w-full py-3.5 text-base font-bold bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700 text-white shadow-lg"
              onClick={handleProcessPayment}
              isLoading={isProcessingPayment}
            >
              {isProcessingPayment ? 'Processing Payment with Bank...' : `Pay ${selectedPaymentInst.amount} Now`}
            </Button>
          </div>
        )}
      </Modal>

      {/* Payment Receipt Modal */}
      <Modal
        isOpen={!!selectedReceipt}
        onClose={() => setSelectedReceipt(null)}
        title="Payment Receipt — Official Voucher"
        size="lg"
      >
        {selectedReceipt && (
          <div className="space-y-6">
            <div className="p-6 rounded-2xl bg-gradient-to-b from-slate-50 to-slate-100 dark:from-slate-800 dark:to-slate-900 border border-slate-200 dark:border-slate-700/80 space-y-4">
              <div className="flex items-center justify-between pb-4 border-b border-slate-200 dark:border-slate-700">
                <div>
                  <h3 className="text-lg font-bold text-primary-600 dark:text-primary-400">CHITTY FINANCE</h3>
                  <p className="text-xs text-slate-500 dark:text-slate-400">Official Payment Voucher</p>
                </div>
                <div className="text-right">
                  <span className="text-xs font-mono font-bold text-emerald-600 dark:text-emerald-400 bg-emerald-500/10 px-2.5 py-1 rounded-lg">
                    {selectedReceipt.receiptNo}
                  </span>
                  <p className="text-xs text-slate-400 mt-1">{selectedReceipt.paidDate}</p>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4 text-xs">
                <div>
                  <p className="text-slate-400 font-medium">Customer</p>
                  <p className="text-sm font-bold text-slate-800 dark:text-white mt-0.5">{selectedSubForInstallments?.customerName}</p>
                </div>
                <div>
                  <p className="text-slate-400 font-medium">Chit Plan</p>
                  <p className="text-sm font-bold text-slate-800 dark:text-white mt-0.5">{selectedReceipt.planName}</p>
                </div>
                <div>
                  <p className="text-slate-400 font-medium">Installment Period</p>
                  <p className="text-sm font-semibold text-slate-700 dark:text-slate-300 mt-0.5">{selectedReceipt.monthLabel} ({selectedReceipt.dueDate})</p>
                </div>
                <div>
                  <p className="text-slate-400 font-medium">Payment Status</p>
                  <div className="mt-0.5"><StatusBadge status={selectedReceipt.status} /></div>
                </div>
              </div>

              <div className="pt-4 border-t border-slate-200 dark:border-slate-700 flex items-center justify-between">
                <span className="text-xs font-bold text-slate-500 uppercase tracking-wider">Amount Paid</span>
                <span className="text-2xl font-black text-emerald-600 dark:text-emerald-400">{selectedReceipt.amount}</span>
              </div>
            </div>

            <div className="flex justify-end gap-3">
              <Button variant="secondary" onClick={() => setSelectedReceipt(null)}>
                Close
              </Button>
              <Button icon={<CheckCircle2 className="w-4 h-4" />} onClick={() => setSelectedReceipt(null)}>
                Done
              </Button>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
}

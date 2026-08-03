import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { StatusBadge } from '../../components/ui/Badge';
import { Modal } from '../../components/ui/Modal';
import { Customer } from '../../types';
import { useAuth } from '../../hooks/useAuth';
import api, { fetchCustomer, fetchSubscriptions, deleteCustomer, mapApiError } from '../../services/api';
import { ArrowLeft, Edit, MapPin, Phone, Mail, CheckCircle, Navigation, CreditCard, Calendar, Clock, Trash2, Eye, FileText, Printer, Lock, ShieldCheck, QrCode, Building2, Wallet, Loader2 } from 'lucide-react';

export default function CustomerDetailPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const [customer, setCustomer] = useState<Customer | null>(null);
  const [subscriptions, setSubscriptions] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [isDeleting, setIsDeleting] = useState(false);
  const [selectedSubForInstallments, setSelectedSubForInstallments] = useState<any | null>(null);
  const [selectedReceipt, setSelectedReceipt] = useState<any | null>(null);
  const [selectedPaymentInst, setSelectedPaymentInst] = useState<any | null>(null);
  const [paymentMethod, setPaymentMethod] = useState<'upi' | 'card' | 'netbanking' | 'cash'>('upi');
  const [isProcessingPayment, setIsProcessingPayment] = useState(false);
  const [paidInstallmentsMap, setPaidInstallmentsMap] = useState<Record<number, { paidDate: string; receiptNo: string }>>({});

  const generateInstallments = (sub: any) => {
    const installments = [];
    const baseDate = sub.joinedDate ? new Date(sub.joinedDate) : new Date('2026-04-05');
    const count = 12;
    const today = new Date();
    today.setHours(0, 0, 0, 0);

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

      if (paidInstallmentsMap[i]) {
        status = isFuture ? 'advance_paid' : 'paid';
        paidDate = paidInstallmentsMap[i].paidDate;
        receiptNo = paidInstallmentsMap[i].receiptNo;
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

      const instAmountVal = sub.monthlyPayment || sub.chitPlanMonthlyPayment || 5000;
      const formattedAmount = `₹${Number(instAmountVal).toLocaleString('en-IN')}`;

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

  const handleProcessPayment = () => {
    if (!selectedPaymentInst) return;
    setIsProcessingPayment(true);

    setTimeout(() => {
      const today = new Date();
      const dd = String(today.getDate()).padStart(2, '0');
      const mm = String(today.getMonth() + 1).padStart(2, '0');
      const yyyy = today.getFullYear();
      const todayStr = `${dd}/${mm}/${yyyy}`;
      const newReceiptNo = `#REC-${Math.floor(Math.random() * 899 + 100)}`;

      const updatedReceipt = {
        ...selectedPaymentInst,
        status: 'paid',
        paidDate: todayStr,
        receiptNo: newReceiptNo,
      };

      setPaidInstallmentsMap((prev) => ({
        ...prev,
        [selectedPaymentInst.monthNumber]: {
          paidDate: todayStr,
          receiptNo: newReceiptNo,
        },
      }));

      setIsProcessingPayment(false);
      setSelectedPaymentInst(null);
      setSelectedReceipt(updatedReceipt);
    }, 1200);
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

    if (latestDueInst.status === 'paid') {
      return 'paid';
    }

    return latestDueInst.status;
  };

  const loadData = () => {
    if (!id) return;
    setIsLoading(true);
    Promise.all([
      fetchCustomer(id),
      fetchSubscriptions({ customer: id }),
    ])
      .then(([cust, subs]) => {
        setCustomer(cust);
        const filteredSubs = subs.filter((s: any) => String(s.customerId) === String(id));
        setSubscriptions(filteredSubs);
      })
      .catch((err) => setError(mapApiError(err)))
      .finally(() => setIsLoading(false));
  };

  useEffect(() => { loadData(); }, [id]);

  const handleApprove = async () => {
    try {
      await api.post(`customers/${id}/approve/`);
      loadData();
    } catch (err) {
      setError(mapApiError(err));
    }
  };

  const handleDeleteCustomer = async () => {
    if (!id) return;
    setIsDeleting(true);
    try {
      await deleteCustomer(id);
      navigate('/admin/customers');
    } catch (err) {
      setError(mapApiError(err));
      setShowDeleteModal(false);
    } finally {
      setIsDeleting(false);
    }
  };

  if (isLoading) return <div className="flex justify-center py-24"><div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" /></div>;
  if (!customer) return <div className="text-center py-12"><p>Customer record not found</p></div>;

  return (
    <div className="space-y-6 animate-fade-in max-w-5xl mx-auto pb-12">
      {error && <div className="p-3 bg-red-50 text-red-600 text-sm rounded-xl">{error}</div>}
      <PageHeader
        title={customer.name} subtitle={`Customer ID: ${customer.customerId}`}
        action={
          <div className="flex gap-2">
            <Button variant="ghost" onClick={() => navigate(-1)} icon={<ArrowLeft className="w-4 h-4" />}>Back</Button>
            
            {/* Conditional Approve Button visible strictly to Admin and Subadmin roles */}
            {(user?.role === 'admin' || user?.role === 'subadmin') && customer.approvalStatus !== 'Approved' && (
              <Button variant="primary" onClick={handleApprove} icon={<CheckCircle className="w-4 h-4" />}>
                {customer.isEditUnlocked ? 'Confirm Changes' : 'Approve Onboarding'}
              </Button>
            )}
            
            <Button variant="secondary" onClick={() => navigate(`/admin/customers/edit/${customer.id}`)} icon={<Edit className="w-4 h-4" />}>Edit</Button>
          </div>
        }
      />
      
      {/* Pending Onboarding Approval Banner */}
      {(user?.role === 'admin' || user?.role === 'subadmin') && customer.approvalStatus !== 'Approved' && (
        <Card className="border-amber-400/50 bg-amber-500/10 dark:bg-amber-950/20">
          <div className="flex items-center gap-3">
            <Clock className="w-6 h-6 text-amber-500 shrink-0" />
            <div>
              <h3 className="font-bold text-amber-600 dark:text-amber-400 text-base">
                Pending Onboarding Approval
              </h3>
              <p className="text-sm text-slate-600 dark:text-slate-300 mt-0.5">
                This customer was onboarded by an agent and requires your approval.
              </p>
            </div>
          </div>
        </Card>
      )}
      
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">Personal Information</h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
                  <Phone className="w-5 h-5 text-primary-500" />
                </div>
                <div>
                  <p className="text-xs text-slate-500">Primary Mobile</p>
                  <a href={`tel:${customer.primaryMobile}`} className="font-medium text-slate-800 dark:text-white hover:text-primary-500 transition-colors">
                    {customer.primaryMobile}
                  </a>
                </div>
              </div>
              {customer.alternateMobile && (
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-xl bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                    <Phone className="w-5 h-5 text-slate-500" />
                  </div>
                  <div>
                    <p className="text-xs text-slate-500">Alternate Mobile</p>
                    <a href={`tel:${customer.alternateMobile}`} className="font-medium text-slate-800 dark:text-white hover:text-primary-500 transition-colors">
                      {customer.alternateMobile}
                    </a>
                  </div>
                </div>
              )}
              <div className="flex items-center gap-3 sm:col-span-2">
                <div className="w-10 h-10 rounded-xl bg-accent-50 dark:bg-accent-900/20 flex items-center justify-center">
                  <Mail className="w-5 h-5 text-accent-500" />
                </div>
                <div>
                  <p className="text-xs text-slate-500">Email</p>
                  <a href={`mailto:${customer.email}`} className="font-medium text-slate-800 dark:text-white hover:text-primary-500 transition-colors">
                    {customer.email || '—'}
                  </a>
                </div>
              </div>
            </div>
          </Card>

          <Card>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">Profile History</h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-slate-50 dark:bg-slate-800 flex items-center justify-center">
                  <Calendar className="w-5 h-5 text-slate-500" />
                </div>
                <div>
                  <p className="text-xs text-slate-500">Date Added</p>
                  <p className="font-medium text-slate-800 dark:text-white">
                    {new Date(customer.createdAt).toLocaleString()}
                  </p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-slate-50 dark:bg-slate-800 flex items-center justify-center">
                  <Clock className="w-5 h-5 text-slate-500" />
                </div>
                <div>
                  <p className="text-xs text-slate-500">Last Modified</p>
                  <p className="font-medium text-slate-800 dark:text-white">
                    {new Date(customer.updatedAt).toLocaleString()}
                  </p>
                </div>
              </div>
            </div>
          </Card>

          <Card>
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <MapPin className="w-5 h-5 text-primary-500" />
                <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Permanent Address</h2>
              </div>
              {customer.homeAddress.mapUrl && (
                <button
                  onClick={() => window.open(customer.homeAddress.mapUrl, '_blank')}
                  className="flex items-center gap-1.5 text-sm text-primary-600 dark:text-primary-400"
                >
                  <Navigation className="w-4 h-4" />
                  Navigate
                </button>
              )}
            </div>
            <p className="text-sm text-slate-700 dark:text-slate-300">
              {customer.homeAddress.houseOrBuildingName}
              {customer.homeAddress.landmark && `, ${customer.homeAddress.landmark}`}
            </p>
            <p className="text-sm text-slate-500 dark:text-slate-400">
              {customer.homeAddress.village}, {customer.homeAddress.taluk}
            </p>
            <p className="text-sm text-slate-500 dark:text-slate-400">
              {customer.homeAddress.district}, {customer.homeAddress.state} - {customer.homeAddress.pinCode}
            </p>
          </Card>

          {customer.currentAddress && (
            <Card>
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                  <MapPin className="w-5 h-5 text-primary-500" />
                  <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Current Address</h2>
                </div>
                {customer.currentAddress?.mapUrl && (
                  <button
                    onClick={() => window.open(customer.currentAddress?.mapUrl, '_blank')}
                    className="flex items-center gap-1.5 text-sm text-primary-600 dark:text-primary-400"
                  >
                    <Navigation className="w-4 h-4" />
                    Navigate
                  </button>
                )}
              </div>
              <p className="text-sm text-slate-700 dark:text-slate-300">
                {customer.currentAddress.houseOrBuildingName}
                {customer.currentAddress.landmark && `, ${customer.currentAddress.landmark}`}
              </p>
              <p className="text-sm text-slate-500 dark:text-slate-400">
                {customer.currentAddress.village}, {customer.currentAddress.taluk}
              </p>
              <p className="text-sm text-slate-500 dark:text-slate-400">
                {customer.currentAddress.district}, {customer.currentAddress.state} - {customer.currentAddress.pinCode}
              </p>
            </Card>
          )}

          {customer.workAddress && (
            <Card>
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                  <MapPin className="w-5 h-5 text-accent-500" />
                  <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Work Address</h2>
                </div>
                {customer.workAddress?.mapUrl && (
                  <button
                    onClick={() => window.open(customer.workAddress?.mapUrl, '_blank')}
                    className="flex items-center gap-1.5 text-sm text-primary-600 dark:text-primary-400"
                  >
                    <Navigation className="w-4 h-4" />
                    Navigate
                  </button>
                )}
              </div>
              <p className="text-sm text-slate-700 dark:text-slate-300">
                {customer.workAddress.houseOrBuildingName}
                {customer.workAddress.landmark && `, ${customer.workAddress.landmark}`}
              </p>
              <p className="text-sm text-slate-500 dark:text-slate-400">
                {customer.workAddress.village}, {customer.workAddress.taluk}
              </p>
              <p className="text-sm text-slate-500 dark:text-slate-400">
                {customer.workAddress.district}, {customer.workAddress.state} - {customer.workAddress.pinCode}
              </p>
            </Card>
          )}

          <Card>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">Verification Documents</h2>
            {customer.photos && customer.photos.length > 0 ? (
              <div className="grid grid-cols-3 gap-4">
                {customer.photos.map((photo, index) => (
                  <div key={index} className="space-y-1">
                    <div className="aspect-square rounded-xl overflow-hidden bg-slate-100 dark:bg-slate-700 border border-slate-200 dark:border-slate-800">
                      <img
                        src={photo.url}
                        alt={photo.type}
                        className="w-full h-full object-cover cursor-pointer hover:scale-105 transition-transform duration-200"
                        onClick={() => window.open(photo.url, '_blank')}
                      />
                    </div>
                    <p className="text-[11px] font-medium text-center text-slate-500 dark:text-slate-400">
                      {photo.type === 'customer' && 'Customer Photo'}
                      {photo.type === 'idProof' && 'ID Proof'}
                      {(photo.type === 'addressProof' || photo.type === 'currentAddressProof') && 'Current Address Proof'}
                      {photo.type === 'permanentAddressProof' && 'Permanent Address Proof'}
                      {photo.type === 'workAddressProof' && 'Work Address Proof'}
                    </p>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-sm text-slate-500 dark:text-slate-400">No documents uploaded</p>
            )}
          </Card>

          <Card>
            <div className="flex items-center gap-2 mb-4">
              <CreditCard className="w-5 h-5 text-primary-500" />
              <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Active Subscriptions</h2>
            </div>
            {subscriptions.length === 0 ? (
              <p className="text-sm text-slate-500 dark:text-slate-400">No active subscriptions found</p>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                {subscriptions.map((sub) => (
                  <div key={sub.id} className="p-4 rounded-2xl bg-slate-50 dark:bg-slate-800/50 border border-slate-100 dark:border-slate-700/50 space-y-3">
                    <div className="flex items-center justify-between">
                      <p className="font-semibold text-slate-800 dark:text-white">{sub.chitPlanName}</p>
                      <StatusBadge status={sub.status} />
                    </div>
                    <div className="flex items-center justify-between text-xs pt-2 border-t border-slate-200/50 dark:border-slate-700/50">
                      <span className="text-slate-500 dark:text-slate-400">Payment Status</span>
                      <StatusBadge status={getDynamicPaymentStatus(sub)} />
                    </div>
                    <Button
                      variant="secondary"
                      size="sm"
                      className="w-full flex items-center justify-center gap-1.5 text-xs py-2 mt-2"
                      onClick={() => setSelectedSubForInstallments(sub)}
                    >
                      <Eye className="w-3.5 h-3.5" />
                      View Installments Table
                    </Button>
                  </div>
                ))}
              </div>
            )}
          </Card>
        </div>

        <div className="space-y-6">
          <Card className="text-center">
            <img 
              src={customer.photos.find((p) => p.type === 'customer')?.url || `https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff&size=128`} 
              alt={customer.name} 
              className="w-24 h-24 rounded-full mx-auto mb-4 object-cover border border-slate-200 dark:border-slate-800" 
            />
            <h3 className="text-xl font-bold text-slate-800 dark:text-white">{customer.name}</h3>
            <div className="mt-2 flex justify-center"><StatusBadge status={customer.approvalStatus ? customer.approvalStatus.toLowerCase() : 'pending'} /></div>
          </Card>
        </div>
      </div>

      {/* Delete Customer Section at Bottom */}
      {(user?.role === 'admin' || user?.role === 'subadmin') && (
        <Card className="border-red-500/20 bg-red-500/5 dark:bg-red-950/10 mt-8">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              <h3 className="font-bold text-red-600 dark:text-red-400 text-base flex items-center gap-2">
                <Trash2 className="w-5 h-5" />
                Delete Customer Account
              </h3>
              <p className="text-sm text-slate-600 dark:text-slate-400 mt-1">
                Permanently delete this customer profile, addresses, and associated records. This action cannot be undone.
              </p>
            </div>
            <Button
              variant="danger"
              onClick={() => setShowDeleteModal(true)}
              icon={<Trash2 className="w-4 h-4" />}
              className="bg-red-600 hover:bg-red-700 text-white shrink-0 px-5 py-2.5"
            >
              Delete Customer
            </Button>
          </div>
        </Card>
      )}

      {/* Delete Confirmation Modal */}
      {showDeleteModal && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-slate-900 border border-slate-700/80 rounded-2xl p-6 max-w-md w-full shadow-2xl space-y-4 text-white">
            <div className="flex items-center gap-3 text-red-400">
              <div className="w-10 h-10 rounded-xl bg-red-500/20 flex items-center justify-center">
                <Trash2 className="w-6 h-6" />
              </div>
              <h3 className="text-lg font-bold">Delete Customer Account</h3>
            </div>
            <p className="text-sm text-slate-300">
              Are you sure you want to delete customer <strong className="text-white">{customer.name}</strong> ({customer.customerId})? This action is permanent and cannot be undone.
            </p>
            <div className="flex justify-end gap-3 pt-2">
              <Button
                variant="ghost"
                onClick={() => setShowDeleteModal(false)}
                disabled={isDeleting}
                className="text-slate-300 hover:bg-slate-800"
              >
                Cancel
              </Button>
              <Button
                variant="danger"
                onClick={handleDeleteCustomer}
                isLoading={isDeleting}
                className="bg-red-600 hover:bg-red-700 text-white px-5"
              >
                Yes, Delete Customer
              </Button>
            </div>
          </div>
        </div>
      )}

      {/* Installments Table Modal */}
      <Modal
        isOpen={!!selectedSubForInstallments}
        onClose={() => setSelectedSubForInstallments(null)}
        title={`Installment Schedule — ${selectedSubForInstallments?.chitPlanName}`}
        size="3xl"
      >
        {selectedSubForInstallments && (
          <div className="space-y-4">
            <div className="flex flex-wrap items-center justify-between gap-3 p-3 rounded-xl bg-slate-50 dark:bg-slate-800/50 text-xs border border-slate-200/50 dark:border-slate-700/50">
              <div>
                <span className="text-slate-500 dark:text-slate-400">Customer: </span>
                <span className="font-semibold text-slate-800 dark:text-white">{customer?.name}</span>
              </div>
              <div>
                <span className="text-slate-500 dark:text-slate-400">Joined Date: </span>
                <span className="font-semibold text-slate-800 dark:text-white">{new Date(selectedSubForInstallments.joinedDate).toLocaleDateString()}</span>
              </div>
              <div>
                <span className="text-slate-500 dark:text-slate-400">Status: </span>
                <StatusBadge status={selectedSubForInstallments.status} />
              </div>
            </div>

            <div className="overflow-x-auto rounded-xl border border-slate-200 dark:border-slate-700">
              <table className="w-full text-left">
                <thead className="bg-slate-100 dark:bg-slate-800/90 text-slate-700 dark:text-slate-200 font-semibold border-b border-slate-200 dark:border-slate-700">
                  <tr>
                    <th className="py-4.5 px-4 text-xs uppercase tracking-wider text-slate-500 dark:text-slate-400">Month</th>
                    <th className="py-4.5 px-4 text-xs uppercase tracking-wider text-slate-500 dark:text-slate-400">Due Date</th>
                    <th className="py-4.5 px-4 text-xs uppercase tracking-wider text-slate-500 dark:text-slate-400">Amount</th>
                    <th className="py-4.5 px-4 text-xs uppercase tracking-wider text-slate-500 dark:text-slate-400">Status</th>
                    <th className="py-4.5 px-4 text-center text-xs uppercase tracking-wider text-slate-500 dark:text-slate-400">Action</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200 dark:divide-slate-700 text-slate-800 dark:text-slate-200">
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
                            onClick={() => setSelectedReceipt(inst)}
                            className="inline-flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-primary-50 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 text-xs font-semibold hover:bg-primary-100 dark:hover:bg-primary-900/50 transition-colors"
                          >
                            <FileText className="w-4 h-4" />
                            View Receipt
                          </button>
                        ) : (
                          <button
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
            {/* Header Info */}
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

            {/* Payment Method Selector */}
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

            {/* Payment Method Details Panel */}
            <div className="p-4 rounded-xl bg-slate-50 dark:bg-slate-800/50 border border-slate-200 dark:border-slate-700 space-y-3">
              {paymentMethod === 'upi' && (
                <div className="space-y-3">
                  <div className="flex items-center gap-3 p-3 rounded-lg bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700">
                    <div className="w-12 h-12 bg-primary-50 dark:bg-primary-900/40 rounded-lg flex items-center justify-center text-primary-600 dark:text-primary-400 font-bold text-lg">
                      QR
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-slate-800 dark:text-white">Scan & Pay via GPay / PhonePe / Paytm</p>
                      <p className="text-xs text-slate-500 dark:text-slate-400">UPI ID: chittyfinance@upi</p>
                    </div>
                  </div>
                  <div>
                    <label className="form-label text-xs">Enter VPA / UPI Handle</label>
                    <input
                      type="text"
                      placeholder="customer@okaxis / customer@ybl"
                      defaultValue={`${customer?.name.toLowerCase().replace(/\s+/g, '')}@upi`}
                      className="glass-input w-full py-2 px-3 text-sm"
                    />
                  </div>
                </div>
              )}

              {paymentMethod === 'card' && (
                <div className="space-y-3">
                  <div>
                    <label className="form-label text-xs">Card Number</label>
                    <input
                      type="text"
                      placeholder="4111 2222 3333 4444"
                      defaultValue="4532 •••• •••• 8912"
                      className="glass-input w-full py-2 px-3 text-sm font-mono"
                    />
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="form-label text-xs">Expiry Date</label>
                      <input
                        type="text"
                        placeholder="MM/YY"
                        defaultValue="09/28"
                        className="glass-input w-full py-2 px-3 text-sm"
                      />
                    </div>
                    <div>
                      <label className="form-label text-xs">CVV</label>
                      <input
                        type="password"
                        placeholder="•••"
                        defaultValue="888"
                        className="glass-input w-full py-2 px-3 text-sm font-mono"
                      />
                    </div>
                  </div>
                </div>
              )}

              {paymentMethod === 'netbanking' && (
                <div className="space-y-2">
                  <label className="form-label text-xs">Select Your Bank</label>
                  <select className="glass-input w-full py-2.5 px-3 text-sm">
                    <option>State Bank of India (SBI)</option>
                    <option>HDFC Bank</option>
                    <option>ICICI Bank</option>
                    <option>Axis Bank</option>
                    <option>Federal Bank</option>
                  </select>
                </div>
              )}

              {paymentMethod === 'cash' && (
                <div className="p-3 rounded-lg bg-amber-500/10 border border-amber-500/20 text-amber-600 dark:text-amber-400 text-xs flex items-center gap-2">
                  <ShieldCheck className="w-4 h-4 shrink-0" />
                  <span>Field Agent Cash Collection mode: Cash collected directly from customer {customer?.name}.</span>
                </div>
              )}
            </div>

            {/* Footer Submit Button */}
            <div className="flex items-center justify-between pt-2">
              <Button
                variant="secondary"
                onClick={() => setSelectedPaymentInst(null)}
                disabled={isProcessingPayment}
              >
                Cancel
              </Button>
              <Button
                onClick={handleProcessPayment}
                isLoading={isProcessingPayment}
                className="bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700 text-white font-bold px-6 py-2.5"
              >
                {isProcessingPayment ? 'Processing Payment...' : `Pay ${selectedPaymentInst.amount} Now`}
              </Button>
            </div>
          </div>
        )}
      </Modal>

      {/* Payment Receipt Modal */}
      <Modal
        isOpen={!!selectedReceipt}
        onClose={() => setSelectedReceipt(null)}
        title="Payment Receipt"
      >
        {selectedReceipt && (
          <div className="space-y-6 p-2">
            <div className="p-6 rounded-2xl bg-gradient-to-br from-slate-900 to-slate-800 text-white border border-slate-700 shadow-xl space-y-4">
              <div className="flex items-center justify-between border-b border-slate-700/80 pb-4">
                <div>
                  <h2 className="text-lg font-bold tracking-wide text-white">Chitty Finance</h2>
                  <p className="text-xs text-slate-400">Official Payment Receipt</p>
                </div>
                <div className="text-right">
                  <span className="px-2.5 py-1 rounded-full bg-green-500/20 text-green-400 text-xs font-semibold border border-green-500/30">
                    PAID
                  </span>
                  <p className="text-xs font-mono text-slate-300 mt-1">{selectedReceipt.receiptNo}</p>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4 text-sm pt-2">
                <div>
                  <p className="text-xs text-slate-400">Customer Name</p>
                  <p className="font-semibold text-white">{customer?.name}</p>
                  <p className="text-xs text-slate-400">{customer?.customerId}</p>
                </div>
                <div>
                  <p className="text-xs text-slate-400">Payment Date</p>
                  <p className="font-semibold text-white">{selectedReceipt.paidDate}</p>
                </div>
                <div>
                  <p className="text-xs text-slate-400">Chit Plan</p>
                  <p className="font-semibold text-white">{selectedReceipt.planName}</p>
                </div>
                <div>
                  <p className="text-xs text-slate-400">Installment</p>
                  <p className="font-semibold text-white">{selectedReceipt.monthLabel}</p>
                </div>
              </div>

              <div className="pt-4 border-t border-slate-700/80 flex items-center justify-between">
                <div>
                  <p className="text-xs text-slate-400">Total Amount Paid</p>
                  <p className="text-2xl font-bold text-green-400">{selectedReceipt.amount}</p>
                </div>
                <p className="text-xs text-slate-400 italic">Verified & Processed</p>
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 pt-2">
              <Button variant="secondary" onClick={() => setSelectedReceipt(null)}>
                Close
              </Button>
              <Button
                onClick={() => window.print()}
                icon={<Printer className="w-4 h-4" />}
                className="flex items-center gap-2"
              >
                Print Receipt
              </Button>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
}
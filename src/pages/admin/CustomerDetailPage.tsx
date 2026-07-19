import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { StatusBadge } from '../../components/ui/Badge';
import { Customer } from '../../types';
import { useAuth } from '../../hooks/useAuth';
import api, { fetchCustomer, fetchSubscriptions, mapApiError } from '../../services/api';
import { ArrowLeft, Edit, MapPin, Phone, Mail, CheckCircle, Navigation, CreditCard, Calendar, Clock } from 'lucide-react';

export default function CustomerDetailPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const [customer, setCustomer] = useState<Customer | null>(null);
  const [subscriptions, setSubscriptions] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');

  const loadData = () => {
    if (!id) return;
    setIsLoading(true);
    Promise.all([
      fetchCustomer(id),
      fetchSubscriptions({ customer: id }),
    ])
      .then(([cust, subs]) => {
        setCustomer(cust);
        setSubscriptions(subs);
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

  if (isLoading) return <div className="flex justify-center py-24"><div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" /></div>;
  if (!customer) return <div className="text-center py-12"><p>Customer record not found</p></div>;

  return (
    <div className="space-y-6 animate-fade-in max-w-5xl mx-auto">
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
                <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Home Address</h2>
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
                {customer.currentAddress.mapUrl && (
                  <button
                    onClick={() => window.open(customer.currentAddress.mapUrl, '_blank')}
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
                {customer.workAddress.mapUrl && (
                  <button
                    onClick={() => window.open(customer.workAddress.mapUrl, '_blank')}
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
                      {photo.type === 'addressProof' && 'Address Proof'}
                      {photo.type === 'idProof' && 'ID Proof'}
                      {photo.type === 'homeAddressProof' && 'Home Address Proof'}
                      {photo.type === 'currentAddressProof' && 'Current Address Proof'}
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
                  <div key={sub.id} className="p-4 rounded-2xl bg-slate-50 dark:bg-slate-800/50 border border-slate-100 dark:border-slate-700/50 space-y-2">
                    <div className="flex items-center justify-between">
                      <p className="font-semibold text-slate-800 dark:text-white">{sub.chitPlanName}</p>
                      <StatusBadge status={sub.status} />
                    </div>
                    <div className="flex items-center justify-between text-xs pt-2 border-t border-slate-200/50 dark:border-slate-700/50">
                      <span className="text-slate-500 dark:text-slate-400">Payment Status</span>
                      <StatusBadge status={sub.paymentStatus} />
                    </div>
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
    </div>
  );
}
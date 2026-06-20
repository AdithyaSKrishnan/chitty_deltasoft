import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Card } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { StatusBadge } from '../../components/ui/Badge';
import { Customer, Subscription } from '../../types';
import { fetchCustomer, fetchSubscriptions, mapApiError } from '../../services/api';
import { ArrowLeft, Phone, Mail, MapPin, Navigation, CreditCard } from 'lucide-react';

export default function AgentCustomerDetailPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [customer, setCustomer] = useState<Customer | null>(null);
  const [subscriptions, setSubscriptions] = useState<Subscription[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!id) return;
    setIsLoading(true);
    Promise.all([
      fetchCustomer(id),
      fetchSubscriptions({ customer: id }),
    ])
      .then(([customerData, subscriptionData]) => {
        setCustomer(customerData);
        setSubscriptions(subscriptionData);
      })
      .catch((err) => setError(mapApiError(err)))
      .finally(() => setIsLoading(false));
  }, [id]);

  if (isLoading) {
    return (
      <div className="flex justify-center py-24">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!customer) {
    return (
      <div className="text-center py-16">
        <p className="text-slate-500 dark:text-slate-400">Customer not found</p>
        <Button className="mt-4" onClick={() => navigate('/agent')}>
          Back to Customers
        </Button>
      </div>
    );
  }

  const getPhotoUrl = (type: string) => {
    return customer.photos.find((p) => p.type === type)?.url;
  };

  return (
    <div className="space-y-4 animate-fade-in pb-24">
      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      {/* Header */}
      <div className="flex items-center gap-3 mb-4">
        <button
          onClick={() => navigate(-1)}
          className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h1 className="text-lg font-bold text-slate-800 dark:text-white">Customer Details</h1>
      </div>

      {/* Profile Card */}
      <Card className="p-4 text-center">
        <img
          src={getPhotoUrl('customer') || `https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff&size=128`}
          alt={customer.name}
          className="w-20 h-20 rounded-full mx-auto mb-3 object-cover"
        />
        <h2 className="text-xl font-bold text-slate-800 dark:text-white">{customer.name}</h2>
        <p className="text-sm text-slate-500 dark:text-slate-400">{customer.customerId}</p>
      </Card>

      {/* Contact Info */}
      <Card className="p-4">
        <h3 className="font-semibold text-slate-800 dark:text-white mb-3">Contact Info</h3>
        <div className="space-y-3">
          <a
            href={`tel:${customer.primaryMobile}`}
            className="flex items-center gap-3 text-slate-600 dark:text-slate-300"
          >
            <div className="w-8 h-8 rounded-lg bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
              <Phone className="w-4 h-4 text-primary-500" />
            </div>
            <span>{customer.primaryMobile}</span>
          </a>
          {customer.alternateMobile && (
            <a
              href={`tel:${customer.alternateMobile}`}
              className="flex items-center gap-3 text-slate-600 dark:text-slate-300"
            >
              <div className="w-8 h-8 rounded-lg bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                <Phone className="w-4 h-4 text-slate-500" />
              </div>
              <span>{customer.alternateMobile}</span>
            </a>
          )}
          <a
            href={`mailto:${customer.email}`}
            className="flex items-center gap-3 text-slate-600 dark:text-slate-300"
          >
            <div className="w-8 h-8 rounded-lg bg-accent-50 dark:bg-accent-900/20 flex items-center justify-center">
              <Mail className="w-4 h-4 text-accent-500" />
            </div>
            <span className="text-sm">{customer.email}</span>
          </a>
        </div>
      </Card>

      {/* Home Address */}
      <Card className="p-4">
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <MapPin className="w-5 h-5 text-primary-500" />
            <h3 className="font-semibold text-slate-800 dark:text-white">Home Address</h3>
          </div>
          <button
            onClick={() => window.open(customer.homeAddress.mapUrl, '_blank')}
            className="flex items-center gap-1.5 text-sm text-primary-600 dark:text-primary-400"
          >
            <Navigation className="w-4 h-4" />
            Navigate
          </button>
        </div>
        <p className="text-sm text-slate-600 dark:text-slate-300">
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

      {/* Work Address */}
      {customer.workAddress && (
        <Card className="p-4">
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center gap-2">
              <MapPin className="w-5 h-5 text-accent-500" />
              <h3 className="font-semibold text-slate-800 dark:text-white">Work Address</h3>
            </div>
            <button
              onClick={() => window.open(customer.workAddress?.mapUrl, '_blank')}
              className="flex items-center gap-1.5 text-sm text-primary-600 dark:text-primary-400"
            >
              <Navigation className="w-4 h-4" />
              Navigate
            </button>
          </div>
          <p className="text-sm text-slate-600 dark:text-slate-300">
            {customer.workAddress.houseOrBuildingName}
          </p>
          <p className="text-sm text-slate-500 dark:text-slate-400">
            {customer.workAddress.district}, {customer.workAddress.state}
          </p>
        </Card>
      )}

      {/* Photos */}
      <Card className="p-4">
        <h3 className="font-semibold text-slate-800 dark:text-white mb-3">Documents</h3>
        <div className="grid grid-cols-3 gap-2">
          {customer.photos.map((photo, index) => (
            <div key={index} className="aspect-square rounded-xl overflow-hidden bg-slate-100 dark:bg-slate-700">
              <img
                src={photo.url}
                alt={photo.type}
                className="w-full h-full object-cover"
              />
            </div>
          ))}
        </div>
      </Card>

      {/* Subscriptions */}
      <Card className="p-4">
        <div className="flex items-center gap-2 mb-3">
          <CreditCard className="w-5 h-5 text-primary-500" />
          <h3 className="font-semibold text-slate-800 dark:text-white">Subscriptions</h3>
        </div>
        {subscriptions.length === 0 ? (
          <p className="text-sm text-slate-500 dark:text-slate-400">No active subscriptions</p>
        ) : (
          <div className="space-y-3">
            {subscriptions.map((sub) => (
              <div key={sub.id} className="p-3 rounded-xl bg-slate-50 dark:bg-slate-700/50">
                <div className="flex items-center justify-between mb-2">
                  <p className="font-medium text-slate-800 dark:text-white">{sub.chitPlanName}</p>
                  <StatusBadge status={sub.status} />
                </div>
                <div className="flex items-center justify-between text-xs">
                  <span className="text-slate-500 dark:text-slate-400">Payment</span>
                  <StatusBadge status={sub.paymentStatus} />
                </div>
              </div>
            ))}
          </div>
        )}
      </Card>
    </div>
  );
}

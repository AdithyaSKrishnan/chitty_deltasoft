import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { PhotoGallery } from '../../components/ui/PhotoUpload';
import { StatusBadge } from '../../components/ui/Badge';
import { Customer, Subscription } from '../../types';
import {
  deleteCustomer,
  fetchCustomer,
  fetchSubscriptions,
  mapApiError,
} from '../../services/api';
import {
  ArrowLeft,
  Edit,
  Trash2,
  MapPin,
  Phone,
  Mail,
  Calendar,
  CreditCard,
  Navigation,
} from 'lucide-react';
import { Modal } from '../../components/ui/Modal';

export default function CustomerDetailPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [deleteModalOpen, setDeleteModalOpen] = useState(false);
  const [customer, setCustomer] = useState<Customer | null>(null);
  const [subscriptions, setSubscriptions] = useState<Subscription[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isDeleting, setIsDeleting] = useState(false);
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

  const handleDelete = async () => {
    if (!id) return;
    setIsDeleting(true);
    try {
      await deleteCustomer(id);
      navigate('/admin/customers');
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsDeleting(false);
    }
  };

  if (isLoading) {
    return (
      <div className="flex justify-center py-24">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!customer) {
    return (
      <div className="text-center py-12">
        <p className="text-slate-500 dark:text-slate-400">Customer not found</p>
        <Button className="mt-4" onClick={() => navigate('/admin/customers')}>
          Back to Customers
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6 animate-fade-in max-w-5xl mx-auto">
      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <PageHeader
        title={customer.name}
        subtitle={`Customer ID: ${customer.customerId}`}
        action={
          <div className="flex gap-2">
            <Button
              variant="ghost"
              onClick={() => navigate(-1)}
              icon={<ArrowLeft className="w-4 h-4" />}
            >
              Back
            </Button>
            <Button
              variant="secondary"
              onClick={() => navigate(`/admin/customers/edit/${customer.id}`)}
              icon={<Edit className="w-4 h-4" />}
            >
              Edit
            </Button>
            <Button
              variant="danger"
              onClick={() => setDeleteModalOpen(true)}
              icon={<Trash2 className="w-4 h-4" />}
            >
              Delete
            </Button>
          </div>
        }
      />

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main Info */}
        <div className="lg:col-span-2 space-y-6">
          {/* Personal Info */}
          <Card>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">
              Personal Information
            </h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
                  <Phone className="w-5 h-5 text-primary-500" />
                </div>
                <div>
                  <p className="text-xs text-slate-500 dark:text-slate-400">Primary Mobile</p>
                  <p className="font-medium text-slate-800 dark:text-white">
                    {customer.primaryMobile}
                  </p>
                </div>
              </div>
              {customer.alternateMobile && (
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-xl bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                    <Phone className="w-5 h-5 text-slate-500" />
                  </div>
                  <div>
                    <p className="text-xs text-slate-500 dark:text-slate-400">Alternate Mobile</p>
                    <p className="font-medium text-slate-800 dark:text-white">
                      {customer.alternateMobile}
                    </p>
                  </div>
                </div>
              )}
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-accent-50 dark:bg-accent-900/20 flex items-center justify-center">
                  <Mail className="w-5 h-5 text-accent-500" />
                </div>
                <div>
                  <p className="text-xs text-slate-500 dark:text-slate-400">Email</p>
                  <p className="font-medium text-slate-800 dark:text-white">{customer.email}</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center">
                  <Calendar className="w-5 h-5 text-blue-500" />
                </div>
                <div>
                  <p className="text-xs text-slate-500 dark:text-slate-400">Created On</p>
                  <p className="font-medium text-slate-800 dark:text-white">
                    {new Date(customer.createdAt).toLocaleDateString()}
                  </p>
                </div>
              </div>
            </div>
          </Card>

          {/* Home Address */}
          <Card>
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <MapPin className="w-5 h-5 text-primary-500" />
                <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
                  Home Address
                </h2>
              </div>
              <a
                href={customer.homeAddress.mapUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-1.5 text-sm text-primary-600 dark:text-primary-400 hover:underline"
              >
                <Navigation className="w-4 h-4" />
                Navigate
              </a>
            </div>
            <div className="grid grid-cols-2 md:grid-cols-3 gap-3 text-sm">
              <div>
                <p className="text-slate-500 dark:text-slate-400">House/Building</p>
                <p className="text-slate-800 dark:text-white">
                  {customer.homeAddress.houseOrBuildingName}
                </p>
              </div>
              <div>
                <p className="text-slate-500 dark:text-slate-400">Landmark</p>
                <p className="text-slate-800 dark:text-white">{customer.homeAddress.landmark}</p>
              </div>
              <div>
                <p className="text-slate-500 dark:text-slate-400">Village</p>
                <p className="text-slate-800 dark:text-white">{customer.homeAddress.village}</p>
              </div>
              <div>
                <p className="text-slate-500 dark:text-slate-400">Taluk</p>
                <p className="text-slate-800 dark:text-white">{customer.homeAddress.taluk}</p>
              </div>
              <div>
                <p className="text-slate-500 dark:text-slate-400">District</p>
                <p className="text-slate-800 dark:text-white">{customer.homeAddress.district}</p>
              </div>
              <div>
                <p className="text-slate-500 dark:text-slate-400">State</p>
                <p className="text-slate-800 dark:text-white">{customer.homeAddress.state}</p>
              </div>
              <div>
                <p className="text-slate-500 dark:text-slate-400">PIN Code</p>
                <p className="text-slate-800 dark:text-white">{customer.homeAddress.pinCode}</p>
              </div>
              {customer.homeAddress.latitude && (
                <div className="col-span-2">
                  <p className="text-slate-500 dark:text-slate-400">Coordinates</p>
                  <p className="text-slate-800 dark:text-white text-xs font-mono">
                    {customer.homeAddress.latitude.toFixed(4)}, {customer.homeAddress.longitude?.toFixed(4)}
                  </p>
                </div>
              )}
            </div>
          </Card>

          {/* Work Address */}
          {customer.workAddress && (
            <Card>
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                  <MapPin className="w-5 h-5 text-accent-500" />
                  <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
                    Work Address
                  </h2>
                </div>
                <a
                  href={customer.workAddress.mapUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-1.5 text-sm text-primary-600 dark:text-primary-400 hover:underline"
                >
                  <Navigation className="w-4 h-4" />
                  Navigate
                </a>
              </div>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-3 text-sm">
                <div>
                  <p className="text-slate-500 dark:text-slate-400">Office/Building</p>
                  <p className="text-slate-800 dark:text-white">
                    {customer.workAddress.houseOrBuildingName}
                  </p>
                </div>
                <div>
                  <p className="text-slate-500 dark:text-slate-400">Landmark</p>
                  <p className="text-slate-800 dark:text-white">{customer.workAddress.landmark}</p>
                </div>
                <div>
                  <p className="text-slate-500 dark:text-slate-400">Village/Area</p>
                  <p className="text-slate-800 dark:text-white">{customer.workAddress.village}</p>
                </div>
                <div>
                  <p className="text-slate-500 dark:text-slate-400">District</p>
                  <p className="text-slate-800 dark:text-white">{customer.workAddress.district}</p>
                </div>
                <div>
                  <p className="text-slate-500 dark:text-slate-400">PIN Code</p>
                  <p className="text-slate-800 dark:text-white">{customer.workAddress.pinCode}</p>
                </div>
              </div>
            </Card>
          )}

          {/* Photos */}
          <Card>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">
              Uploaded Documents
            </h2>
            <PhotoGallery photos={customer.photos} />
          </Card>
        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          {/* Customer Avatar */}
          <Card className="text-center">
            <img
              src={`https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff&size=128`}
              alt={customer.name}
              className="w-24 h-24 rounded-full mx-auto mb-4"
            />
            <h3 className="text-xl font-bold text-slate-800 dark:text-white">{customer.name}</h3>
            <p className="text-slate-500 dark:text-slate-400">{customer.customerId}</p>
          </Card>

          {/* Subscriptions */}
          <Card>
            <div className="flex items-center gap-2 mb-4">
              <CreditCard className="w-5 h-5 text-primary-500" />
              <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
                Subscriptions
              </h2>
            </div>
            {subscriptions.length === 0 ? (
              <p className="text-sm text-slate-500 dark:text-slate-400">No active subscriptions</p>
            ) : (
              <div className="space-y-3">
                {subscriptions.map((sub) => (
                  <div
                    key={sub.id}
                    className="p-3 rounded-xl bg-slate-50 dark:bg-slate-700/50"
                  >
                    <div className="flex items-center justify-between mb-2">
                      <p className="font-medium text-slate-800 dark:text-white text-sm">
                        {sub.chitPlanName}
                      </p>
                      <StatusBadge status={sub.status} />
                    </div>
                    <div className="flex items-center justify-between text-xs">
                      <span className="text-slate-500 dark:text-slate-400">Payment</span>
                      <StatusBadge status={sub.paymentStatus} />
                    </div>
                    <div className="mt-2 pt-2 border-t border-slate-200 dark:border-slate-600 text-xs">
                      <span className="text-slate-500 dark:text-slate-400">Paid: </span>
                      <span className="text-slate-800 dark:text-white font-medium">
                        ₹{sub.totalPaid.toLocaleString()}
                      </span>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </Card>
        </div>
      </div>

      {/* Delete Modal */}
      <Modal
        isOpen={deleteModalOpen}
        onClose={() => setDeleteModalOpen(false)}
        title="Delete Customer"
        size="sm"
      >
        <p className="text-slate-600 dark:text-slate-300 mb-6">
          Are you sure you want to delete <span className="font-semibold">{customer.name}</span>?
          This will also remove all associated subscriptions and cannot be undone.
        </p>
        <div className="flex gap-3 justify-end">
          <Button variant="secondary" onClick={() => setDeleteModalOpen(false)}>
            Cancel
          </Button>
          <Button variant="danger" onClick={handleDelete} isLoading={isDeleting}>
            Delete
          </Button>
        </div>
      </Modal>
    </div>
  );
}

import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Card, PageHeader } from '../../components/ui/Card';
import { Input, Button, Select } from '../../components/ui/Form';
import { AddressForm } from '../../components/ui/AddressForm';
import { PhotoUpload } from '../../components/ui/PhotoUpload';
import { ArrowLeft, Save } from 'lucide-react';
import {
  createCustomerWithDetails,
  fetchChitPlans,
  fetchCustomer,
  mapApiError,
  updateCustomer,
} from '../../services/api';
import { ChitPlan } from '../../types';

export default function CustomerFormPage() {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;

  const [isLoading, setIsLoading] = useState(isEdit);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState('');
  const [chitPlans, setChitPlans] = useState<ChitPlan[]>([]);
  const [generatedId, setGeneratedId] = useState('Auto-generated');

  const [customer, setCustomer] = useState({
    name: '',
    primaryMobile: '',
    alternateMobile: '',
    email: '',
  });

  const [homeAddress, setHomeAddress] = useState({
    id: '',
    type: 'home' as const,
    houseOrBuildingName: '',
    landmark: '',
    village: '',
    taluk: '',
    district: '',
    state: '',
    pinCode: '',
    latitude: null as number | null,
    longitude: null as number | null,
    mapUrl: '',
  });

  const [workAddress, setWorkAddress] = useState({
    id: '',
    type: 'work' as const,
    houseOrBuildingName: '',
    landmark: '',
    village: '',
    taluk: '',
    district: '',
    state: '',
    pinCode: '',
    latitude: null as number | null,
    longitude: null as number | null,
    mapUrl: '',
  });

  const [photos, setPhotos] = useState({
    customer: '',
    addressProof: '',
    idProof: '',
    workLocation: '',
  });

  const [subscription, setSubscription] = useState({
    chitPlanId: '',
    joinedDate: new Date().toISOString().split('T')[0],
  });

  const [addWorkAddress, setAddWorkAddress] = useState(false);
  const [enrollInPlan, setEnrollInPlan] = useState(false);

  useEffect(() => {
    fetchChitPlans()
      .then((plans) => setChitPlans(plans.filter((p) => p.isActive)))
      .catch(() => {});
  }, []);

  useEffect(() => {
    if (!isEdit || !id) return;

    setIsLoading(true);
    fetchCustomer(id)
      .then((data) => {
        setGeneratedId(data.customerId);
        setCustomer({
          name: data.name,
          primaryMobile: data.primaryMobile,
          alternateMobile: data.alternateMobile || '',
          email: data.email,
        });
        setHomeAddress({ ...data.homeAddress, type: 'home' });
        if (data.workAddress) {
          setWorkAddress({ ...data.workAddress, type: 'work' });
          setAddWorkAddress(true);
        }
      })
      .catch((err) => setError(mapApiError(err)))
      .finally(() => setIsLoading(false));
  }, [id, isEdit]);

  const handleSave = async () => {
    setError('');
    setIsSaving(true);
    try {
      if (isEdit && id) {
        await updateCustomer(id, customer);
      } else {
        await createCustomerWithDetails({
          customer,
          homeAddress,
          workAddress: addWorkAddress ? workAddress : null,
          photos,
          subscription: enrollInPlan ? subscription : null,
        });
      }
      navigate('/admin/customers');
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsSaving(false);
    }
  };

  if (isLoading) {
    return (
      <div className="flex justify-center py-24">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-6 animate-fade-in max-w-4xl mx-auto">
      <PageHeader
        title={isEdit ? 'Edit Customer' : 'Add Customer'}
        subtitle={isEdit ? 'Update customer information' : 'Onboard a new customer'}
        action={
          <Button variant="ghost" onClick={() => navigate(-1)} icon={<ArrowLeft className="w-4 h-4" />}>
            Back
          </Button>
        }
      />

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <Card>
        <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">
          Personal Information
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Input
            label="Customer Name"
            placeholder="Full name as per ID proof"
            value={customer.name}
            onChange={(e) => setCustomer({ ...customer, name: e.target.value })}
            required
          />
          <Input
            label="Customer ID"
            placeholder="Auto-generated"
            value={generatedId}
            disabled
            className="opacity-60"
          />
          <Input
            label="Primary Mobile Number"
            placeholder="+91 XXXXX XXXXX"
            value={customer.primaryMobile}
            onChange={(e) => setCustomer({ ...customer, primaryMobile: e.target.value })}
            required
          />
          <Input
            label="Alternate Mobile Number"
            placeholder="+91 XXXXX XXXXX (optional)"
            value={customer.alternateMobile}
            onChange={(e) => setCustomer({ ...customer, alternateMobile: e.target.value })}
          />
          <Input
            label="Email Address"
            type="email"
            placeholder="customer@email.com"
            value={customer.email}
            onChange={(e) => setCustomer({ ...customer, email: e.target.value })}
            className="md:col-span-2"
          />
        </div>
      </Card>

      {!isEdit && (
        <>
          <Card>
            <AddressForm
              type="home"
              data={homeAddress}
              onChange={(data) => setHomeAddress({ ...homeAddress, ...data })}
            />
          </Card>

          <Card>
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={addWorkAddress}
                onChange={(e) => setAddWorkAddress(e.target.checked)}
                className="w-5 h-5 rounded border-slate-300 text-primary-600 focus:ring-primary-500"
              />
              <div>
                <p className="font-medium text-slate-800 dark:text-white">Add Work Address</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Include customer's workplace location
                </p>
              </div>
            </label>
          </Card>

          {addWorkAddress && (
            <Card>
              <AddressForm
                type="work"
                data={workAddress}
                onChange={(data) => setWorkAddress({ ...workAddress, ...data })}
              />
            </Card>
          )}

          <Card>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">
              Photo Uploads
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <PhotoUpload
                type="customer"
                label="Customer Photo"
                value={photos.customer}
                onChange={(url) => setPhotos({ ...photos, customer: url })}
              />
              <PhotoUpload
                type="address_proof"
                label="Address Proof"
                value={photos.addressProof}
                onChange={(url) => setPhotos({ ...photos, addressProof: url })}
              />
              <PhotoUpload
                type="id_proof"
                label="ID Proof"
                value={photos.idProof}
                onChange={(url) => setPhotos({ ...photos, idProof: url })}
              />
              {addWorkAddress && (
                <PhotoUpload
                  type="work_location"
                  label="Work Location Photo"
                  value={photos.workLocation}
                  onChange={(url) => setPhotos({ ...photos, workLocation: url })}
                />
              )}
            </div>
          </Card>

          <Card>
            <label className="flex items-center gap-3 cursor-pointer mb-4">
              <input
                type="checkbox"
                checked={enrollInPlan}
                onChange={(e) => setEnrollInPlan(e.target.checked)}
                className="w-5 h-5 rounded border-slate-300 text-primary-600 focus:ring-primary-500"
              />
              <div>
                <p className="font-medium text-slate-800 dark:text-white">Enroll in Chit Plan</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Subscribe customer to a chit plan immediately
                </p>
              </div>
            </label>

            {enrollInPlan && (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 pt-4 border-t border-slate-200/50 dark:border-slate-700/50">
                <Select
                  label="Select Chit Plan"
                  value={subscription.chitPlanId}
                  onChange={(e) => setSubscription({ ...subscription, chitPlanId: e.target.value })}
                  options={[
                    { value: '', label: 'Choose a plan...' },
                    ...chitPlans.map((p) => ({
                      value: p.id,
                      label: `${p.planName} - ₹${p.monthlyPayment}/month`,
                    })),
                  ]}
                />
                <Input
                  label="Joined Date"
                  type="date"
                  value={subscription.joinedDate}
                  onChange={(e) => setSubscription({ ...subscription, joinedDate: e.target.value })}
                />
              </div>
            )}
          </Card>
        </>
      )}

      <div className="flex justify-end gap-3">
        <Button variant="secondary" onClick={() => navigate('/admin/customers')}>
          Cancel
        </Button>
        <Button icon={<Save className="w-4 h-4" />} onClick={handleSave} isLoading={isSaving}>
          {isEdit ? 'Update Customer' : 'Save Customer'}
        </Button>
      </div>
    </div>
  );
}

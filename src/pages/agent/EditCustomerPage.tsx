import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Card } from '../../components/ui/Card';
import { Input, Button } from '../../components/ui/Form';
import { AddressForm } from '../../components/ui/AddressForm';
import { PhotoUpload } from '../../components/ui/PhotoUpload';
import { ArrowLeft, Save, MapPin } from 'lucide-react';
import {
  fetchCustomer,
  updateCustomer,
  uploadCustomerPhotos,
  fetchChitPlans,
  fetchSubscriptions,
  createSubscription,
  mapApiError,
} from '../../services/api';
import { ChitPlan } from '../../types';

export default function EditCustomerPage() {
  const navigate = useNavigate();
  const { id } = useParams();

  const [step, setStep] = useState(1);
  const totalSteps = 4;
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState('');
  const [generatedId, setGeneratedId] = useState('');
  const [approvalStatus, setApprovalStatus] = useState('Pending');
  const [chitPlans, setChitPlans] = useState<ChitPlan[]>([]);

  const [customer, setCustomer] = useState({
    name: '',
    primaryMobile: '',
    alternateMobile: '',
    email: '',
  });

  const [homeAddress, setHomeAddress] = useState<any>({
    houseOrBuildingName: '',
    landmark: '',
    village: '',
    taluk: '',
    district: '',
    state: '',
    pinCode: '',
    latitude: null,
    longitude: null,
    mapUrl: '',
  });

  const [currentAddress, setCurrentAddress] = useState<any>({
    houseOrBuildingName: '',
    landmark: '',
    village: '',
    taluk: '',
    district: '',
    state: '',
    pinCode: '',
    latitude: null,
    longitude: null,
    mapUrl: '',
  });

  const [workAddress, setWorkAddress] = useState<any>({
    houseOrBuildingName: '',
    landmark: '',
    village: '',
    taluk: '',
    district: '',
    state: '',
    pinCode: '',
    latitude: null,
    longitude: null,
    mapUrl: '',
  });

  const [photos, setPhotos] = useState({
    customer: '',
    addressProof: '',
    idProof: '',
  });

  const [subscription, setSubscription] = useState({
    chitPlanId: '',
    joinedDate: new Date().toISOString().split('T')[0],
  });

  const [existingChitPlanId, setExistingChitPlanId] = useState('');
  const [addCurrentAddress, setAddCurrentAddress] = useState(false);
  const [addWorkAddress, setAddWorkAddress] = useState(false);

  useEffect(() => {
    if (!id) return;

    setIsLoading(true);
    Promise.all([
      fetchCustomer(id),
      fetchChitPlans(),
      fetchSubscriptions({ customer: id }),
    ])
      .then(([data, plans, subs]) => {
        setChitPlans(plans.filter((p) => p.isActive));
        setGeneratedId(data.customerId);
        setApprovalStatus(data.approvalStatus);
        setCustomer({
          name: data.name,
          primaryMobile: data.primaryMobile,
          alternateMobile: data.alternateMobile || '',
          email: data.email || '',
        });

        if (data.homeAddress) {
          setHomeAddress(data.homeAddress);
        }

        if (data.currentAddress) {
          setCurrentAddress(data.currentAddress);
          setAddCurrentAddress(true);
        }

        if (data.workAddress) {
          setWorkAddress(data.workAddress);
          setAddWorkAddress(true);
        }

        const customerPhoto = data.photos.find((p: any) => p.type === 'customer')?.url || '';
        const addressProof = data.photos.find((p: any) => p.type === 'addressProof')?.url || '';
        const idProof = data.photos.find((p: any) => p.type === 'idProof')?.url || '';
        setPhotos({
          customer: customerPhoto,
          addressProof: addressProof,
          idProof: idProof,
        });

        if (subs.length > 0) {
          setSubscription({
            chitPlanId: subs[0].chitPlanId,
            joinedDate: subs[0].joinedDate || new Date().toISOString().split('T')[0],
          });
          setExistingChitPlanId(subs[0].chitPlanId);
        }
      })
      .catch((err) => setError(mapApiError(err)))
      .finally(() => setIsLoading(false));
  }, [id]);

  const canProceed = () => {
    switch (step) {
      case 1:
        return customer.name && customer.primaryMobile;
      case 2:
        return homeAddress.houseOrBuildingName && homeAddress.district && homeAddress.state && homeAddress.pinCode;
      case 3:
        return photos.customer && photos.idProof;
      case 4:
        return true;
      default:
        return false;
    }
  };

  const handleGetCurrentLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const { latitude, longitude } = position.coords;
          setHomeAddress({
            ...homeAddress,
            latitude,
            longitude,
            mapUrl: `https://maps.google.com/?q=${latitude},${longitude}`,
          });
        },
        (locationError) => console.error('Error getting location:', locationError),
      );
    }
  };

  const handleSave = async () => {
    if (!id) return;
    if (approvalStatus === 'Approved') {
      setError('Approved customer records cannot be modified by field agents.');
      return;
    }

    setError('');
    setIsSaving(true);
    try {
      await updateCustomer(id, {
        ...customer,
        homeAddress,
        currentAddress: addCurrentAddress ? currentAddress : null,
        workAddress: addWorkAddress ? workAddress : null,
      });
      await uploadCustomerPhotos(id, photos);
      
      if (subscription.chitPlanId && subscription.chitPlanId !== existingChitPlanId) {
        await createSubscription({
          customerId: id,
          chitPlanId: subscription.chitPlanId,
          joinedDate: subscription.joinedDate,
        });
      }
      
      navigate(`/agent/customer/${id}`);
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

  if (approvalStatus === 'Approved') {
    return (
      <div className="space-y-6 max-w-lg mx-auto py-12 text-center">
        <div className="p-4 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 rounded-xl">
          Access Denied: Approved customer profiles cannot be edited by field agents.
        </div>
        <Button variant="secondary" onClick={() => navigate(-1)} icon={<ArrowLeft className="w-4 h-4" />}>
          Go Back
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-4 animate-fade-in max-w-lg mx-auto pb-24">
      <div className="flex items-center gap-3 mb-4">
        <button
          onClick={() => (step > 1 ? setStep(step - 1) : navigate(-1))}
          className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div className="flex-1">
          <h1 className="text-lg font-bold text-slate-800 dark:text-white">Edit Customer</h1>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            Step {step} of {totalSteps}
          </p>
        </div>
      </div>

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <div className="flex gap-1">
        {Array.from({ length: totalSteps }).map((_, i) => (
          <div
            key={i}
            className={`flex-1 h-1.5 rounded-full ${
              i < step
                ? 'bg-primary-500'
                : i === step - 1
                ? 'bg-primary-300 dark:bg-primary-700'
                : 'bg-slate-200 dark:bg-slate-700'
            }`}
          />
        ))}
      </div>

      <div className="mt-6">
        {step === 1 && (
          <Card className="p-4 space-y-4">
            <h2 className="text-base font-semibold text-slate-800 dark:text-white">
              Personal Information
            </h2>
            <Input
              label="Customer Name"
              placeholder="Full name"
              value={customer.name}
              onChange={(e) => setCustomer({ ...customer, name: e.target.value })}
              required
            />
            <Input
              label="Customer ID"
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
              placeholder="+91 XXXXX XXXXX"
              value={customer.alternateMobile}
              onChange={(e) => setCustomer({ ...customer, alternateMobile: e.target.value })}
            />
            <Input
              label="Email Address"
              type="email"
              placeholder="customer@email.com"
              value={customer.email}
              onChange={(e) => setCustomer({ ...customer, email: e.target.value })}
            />
          </Card>
        )}

        {step === 2 && (
          <div className="space-y-4">
            <Card className="p-4">
              <div className="flex items-center justify-between mb-4">
                <h2 className="text-base font-semibold text-slate-800 dark:text-white">
                  Home Address
                </h2>
                <button
                  type="button"
                  onClick={handleGetCurrentLocation}
                  className="flex items-center gap-1.5 text-xs text-primary-600 dark:text-primary-400"
                >
                  <MapPin className="w-4 h-4" />
                  Use GPS
                </button>
              </div>
              <AddressForm
                type="home"
                data={homeAddress}
                onChange={(data) => setHomeAddress({ ...homeAddress, ...data })}
                compact
              />
            </Card>

            <label className="flex items-center gap-3 p-4 glass-card cursor-pointer">
              <input
                type="checkbox"
                checked={addCurrentAddress}
                onChange={(e) => setAddCurrentAddress(e.target.checked)}
                className="w-5 h-5 rounded text-primary-600"
              />
              <div>
                <p className="font-medium text-slate-800 dark:text-white">
                  Add Temporary Stay Address
                </p>
                <p className="text-xs text-slate-500 dark:text-slate-400">
                  Include current temporary residence details
                </p>
              </div>
            </label>

            {addCurrentAddress && (
              <Card className="p-4">
                <h2 className="text-base font-semibold text-slate-800 dark:text-white mb-4">
                  Current Address
                </h2>
                <AddressForm
                  type="home"
                  data={currentAddress}
                  onChange={(data) => setCurrentAddress({ ...currentAddress, ...data })}
                  compact
                />
              </Card>
            )}

            <label className="flex items-center gap-3 p-4 glass-card cursor-pointer">
              <input
                type="checkbox"
                checked={addWorkAddress}
                onChange={(e) => setAddWorkAddress(e.target.checked)}
                className="w-5 h-5 rounded text-primary-600"
              />
              <div>
                <p className="font-medium text-slate-800 dark:text-white">
                  Add Work Address
                </p>
                <p className="text-xs text-slate-500 dark:text-slate-400">
                  Include workplace location
                </p>
              </div>
            </label>

            {addWorkAddress && (
              <Card className="p-4">
                <h2 className="text-base font-semibold text-slate-800 dark:text-white mb-4">
                  Work Address
                </h2>
                <AddressForm
                  type="work"
                  data={workAddress}
                  onChange={(data) => setWorkAddress({ ...workAddress, ...data })}
                  compact
                />
              </Card>
            )}
          </div>
        )}

        {step === 3 && (
          <Card className="p-4 space-y-4">
            <h2 className="text-base font-semibold text-slate-800 dark:text-white">
              Photo Uploads
            </h2>
            <div className="grid grid-cols-3 gap-3">
              <PhotoUpload
                type="customer"
                label="Photo"
                value={photos.customer}
                onChange={(url) => setPhotos({ ...photos, customer: url })}
                compact
              />
              <PhotoUpload
                type="id_proof"
                label="ID Proof"
                value={photos.idProof}
                onChange={(url) => setPhotos({ ...photos, idProof: url })}
                compact
              />
              <PhotoUpload
                type="address_proof"
                label="Address"
                value={photos.addressProof}
                onChange={(url) => setPhotos({ ...photos, addressProof: url })}
                compact
              />
            </div>
          </Card>
        )}

        {step === 4 && (
          <Card className="p-4 space-y-4">
            <h2 className="text-base font-semibold text-slate-800 dark:text-white">
              Chit Plan Enrollment
            </h2>
            <div>
              <label className="form-label">Select Plan (Optional)</label>
              <select
                value={subscription.chitPlanId}
                onChange={(e) => setSubscription({ ...subscription, chitPlanId: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
              >
                <option value="">Choose a plan...</option>
                {chitPlans.map((p) => (
                  <option key={p.id} value={p.id}>
                    {p.planName} - ₹{p.monthlyPayment}/month
                  </option>
                ))}
              </select>
            </div>

            <div className="mt-6 pt-6 border-t border-slate-200 dark:border-slate-700">
              <h3 className="text-sm font-medium text-slate-700 dark:text-slate-300 mb-3">
                Summary
              </h3>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-slate-500 dark:text-slate-400">Name</span>
                  <span className="text-slate-800 dark:text-white font-medium">{customer.name}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-500 dark:text-slate-400">Mobile</span>
                  <span className="text-slate-800 dark:text-white font-medium">{customer.primaryMobile}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-500 dark:text-slate-400">Location</span>
                  <span className="text-slate-800 dark:text-white font-medium">{homeAddress.district || '-'}</span>
                </div>
              </div>
            </div>
          </Card>
        )}
      </div>

      <div className="fixed bottom-20 left-0 right-0 p-4 bg-transparent z-50">
        <div className="max-w-lg mx-auto flex gap-3">
          {step < totalSteps ? (
            <Button
              className="flex-1"
              onClick={() => setStep(step + 1)}
              disabled={!canProceed()}
            >
              Continue
            </Button>
          ) : (
            <Button
              className="flex-1"
              icon={<Save className="w-4 h-4" />}
              onClick={handleSave}
              isLoading={isSaving}
            >
              Save Changes
            </Button>
          )}
        </div>
      </div>
    </div>
  );
}

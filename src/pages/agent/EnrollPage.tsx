import { useEffect, useState } from 'react';
import { Card } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { CreditCard, IndianRupee, UserPlus } from 'lucide-react';
import {
  createSubscription,
  fetchChitPlans,
  fetchCustomers,
  mapApiError,
} from '../../services/api';
import { ChitPlan, Customer } from '../../types';

export default function EnrollPage() {
  const [step, setStep] = useState(1);
  const [selectedCustomer, setSelectedCustomer] = useState('');
  const [selectedPlan, setSelectedPlan] = useState('');
  const [success, setSuccess] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState('');
  const [myCustomers, setMyCustomers] = useState<Customer[]>([]);
  const [activePlans, setActivePlans] = useState<ChitPlan[]>([]);

  useEffect(() => {
    Promise.all([fetchCustomers(), fetchChitPlans()])
      .then(([customers, plans]) => {
        setMyCustomers(customers);
        setActivePlans(plans.filter((p) => p.isActive));
      })
      .catch((err) => setError(mapApiError(err)))
      .finally(() => setIsLoading(false));
  }, []);

  const customer = myCustomers.find((c) => c.id === selectedCustomer);
  const plan = activePlans.find((p) => p.id === selectedPlan);

  const handleEnroll = async () => {
    if (!selectedCustomer || !selectedPlan) return;

    setIsSaving(true);
    setError('');
    try {
      await createSubscription({
        customerId: selectedCustomer,
        chitPlanId: selectedPlan,
        joinedDate: new Date().toISOString().split('T')[0],
      });
      setSuccess(true);
      setTimeout(() => {
        setSuccess(false);
        setSelectedCustomer('');
        setSelectedPlan('');
        setStep(1);
      }, 2000);
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsSaving(false);
    }
  };

  if (success) {
    return (
      <div className="flex flex-col items-center justify-center py-16 animate-fade-in">
        <div className="w-20 h-20 rounded-full bg-gradient-to-br from-accent-400 to-accent-500 flex items-center justify-center mb-4 shadow-lg shadow-accent-500/30 animate-scale-in">
          <svg className="w-10 h-10 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <h2 className="text-xl font-bold text-slate-800 dark:text-white mb-2">
          Enrollment Successful!
        </h2>
        <p className="text-slate-500 dark:text-slate-400 text-center">
          {customer?.name} has been enrolled in {plan?.planName}
        </p>
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="flex justify-center py-24">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-4 animate-fade-in">
      <div className="text-center mb-6">
        <h1 className="text-xl font-bold text-slate-800 dark:text-white">Enroll Customer</h1>
        <p className="text-sm text-slate-500 dark:text-slate-400">
          Subscribe a customer to a chit plan
        </p>
      </div>

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <div className="flex gap-1 mb-6">
        {[1, 2].map((s) => (
          <div
            key={s}
            className={`flex-1 h-1.5 rounded-full ${
              s <= step
                ? 'bg-primary-500'
                : 'bg-slate-200 dark:bg-slate-700'
            }`}
          />
        ))}
      </div>

      {step === 1 && (
        <Card className="p-4 space-y-4">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-10 h-10 rounded-xl bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
              <CreditCard className="w-5 h-5 text-primary-500" />
            </div>
            <div>
              <h2 className="font-semibold text-slate-800 dark:text-white">Select Customer</h2>
              <p className="text-xs text-slate-500 dark:text-slate-400">Choose from your customers</p>
            </div>
          </div>

          <div className="space-y-2">
            {myCustomers.length === 0 ? (
              <p className="text-center text-slate-500 dark:text-slate-400 py-4">
                No customers available
              </p>
            ) : (
              myCustomers.map((c) => (
                <label
                  key={c.id}
                  className={`flex items-center gap-3 p-3 rounded-xl cursor-pointer transition-all ${
                    selectedCustomer === c.id
                      ? 'bg-primary-50 dark:bg-primary-900/20 border-2 border-primary-500'
                      : 'bg-slate-50 dark:bg-slate-700/50 border-2 border-transparent hover:bg-slate-100 dark:hover:bg-slate-700'
                  }`}
                >
                  <input
                    type="radio"
                    name="customer"
                    checked={selectedCustomer === c.id}
                    onChange={() => setSelectedCustomer(c.id)}
                    className="sr-only"
                  />
                  <img
                    src={c.customerPhoto || `https://ui-avatars.com/api/?name=${encodeURIComponent(c.name)}&background=3b82f6&color=fff`}
                    alt={c.name}
                    className="w-10 h-10 rounded-full object-cover"
                  />
                  <div className="flex-1">
                    <p className="font-medium text-slate-800 dark:text-white">{c.name}</p>
                    <p className="text-xs text-slate-500 dark:text-slate-400">{c.customerId}</p>
                  </div>
                </label>
              ))
            )}
          </div>

          <Button
            className="w-full mt-4"
            onClick={() => setStep(2)}
            disabled={!selectedCustomer}
          >
            Next: Select Plan
          </Button>
        </Card>
      )}

      {step === 2 && (
        <Card className="p-4 space-y-4">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-10 h-10 rounded-xl bg-accent-50 dark:bg-accent-900/20 flex items-center justify-center">
              <IndianRupee className="w-5 h-5 text-accent-500" />
            </div>
            <div>
              <h2 className="font-semibold text-slate-800 dark:text-white">Select Chit Plan</h2>
              <p className="text-xs text-slate-500 dark:text-slate-400">Choose a savings plan</p>
            </div>
          </div>

          {customer && (
            <div className="flex items-center gap-3 p-3 rounded-xl bg-slate-50 dark:bg-slate-700/50">
              <img
                src={customer.customerPhoto || `https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff`}
                alt={customer.name}
                className="w-8 h-8 rounded-full object-cover"
              />
              <div className="flex-1">
                <p className="text-sm font-medium text-slate-800 dark:text-white">{customer.name}</p>
                <p className="text-xs text-slate-500 dark:text-slate-400">{customer.customerId}</p>
              </div>
            </div>
          )}

          <div className="space-y-2">
            {activePlans.map((p) => (
              <label
                key={p.id}
                className={`block p-4 rounded-xl cursor-pointer transition-all ${
                  selectedPlan === p.id
                    ? 'bg-accent-50 dark:bg-accent-900/20 border-2 border-accent-500'
                    : 'bg-slate-50 dark:bg-slate-700/50 border-2 border-transparent hover:bg-slate-100 dark:hover:bg-slate-700'
                }`}
              >
                <div className="flex items-start justify-between">
                  <div>
                    <p className="font-semibold text-slate-800 dark:text-white">{p.planName}</p>
                    <p className="text-xs text-slate-500 dark:text-slate-400">{p.planCode}</p>
                  </div>
                  <div className="text-right">
                    <p className="font-bold text-lg text-accent-600 dark:text-accent-400">
                      ₹{p.monthlyPayment.toLocaleString()}
                    </p>
                    <p className="text-xs text-slate-500 dark:text-slate-400">/month</p>
                  </div>
                </div>
                <div className="flex items-center gap-4 mt-2 text-xs text-slate-500 dark:text-slate-400">
                  <span>Total: ₹{p.totalAmount.toLocaleString()}</span>
                  <span>{p.numberOfInstallments} months</span>
                </div>
                <input
                  type="radio"
                  name="plan"
                  checked={selectedPlan === p.id}
                  onChange={() => setSelectedPlan(p.id)}
                  className="sr-only"
                />
              </label>
            ))}
          </div>

          <div className="flex gap-3 mt-4">
            <Button variant="secondary" className="flex-1" onClick={() => setStep(1)}>
              Back
            </Button>
            <Button
              className="flex-1"
              icon={<UserPlus className="w-4 h-4" />}
              onClick={handleEnroll}
              disabled={!selectedPlan}
              isLoading={isSaving}
            >
              Enroll Now
            </Button>
          </div>
        </Card>
      )}
    </div>
  );
}

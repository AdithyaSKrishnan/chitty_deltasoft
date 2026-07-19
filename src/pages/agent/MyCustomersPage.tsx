import { useCallback, useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Card } from '../../components/ui/Card';
import { SearchBar } from '../../components/ui/Table';
import { Phone, MapPin, Navigation } from 'lucide-react';
import { fetchCustomers, mapApiError } from '../../services/api';
import { Customer } from '../../types';

export default function MyCustomersPage() {
  const navigate = useNavigate();
  const [search, setSearch] = useState('');
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');

  const loadCustomers = useCallback(async () => {
    setIsLoading(true);
    setError('');
    try {
      const data = await fetchCustomers(search ? { search } : {});
      setCustomers(data);
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsLoading(false);
    }
  }, [search]);

  useEffect(() => {
    const timer = setTimeout(() => {
      loadCustomers();
    }, 300);
    return () => clearTimeout(timer);
  }, [loadCustomers]);

  return (
    <div className="space-y-4 animate-fade-in">
      <div className="text-center mb-6">
        <h1 className="text-xl font-bold text-slate-800 dark:text-white">My Customers</h1>
        <p className="text-sm text-slate-500 dark:text-slate-400">
          {customers.length} customers onboarded
        </p>
      </div>

      <SearchBar
        value={search}
        onChange={setSearch}
        placeholder="Search customers..."
      />

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      {isLoading ? (
        <div className="flex justify-center py-16">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : (
        <div className="space-y-3">
          {customers.length === 0 ? (
            <Card className="text-center py-8">
              <p className="text-slate-500 dark:text-slate-400">No customers found</p>
            </Card>
          ) : (
            customers.map((customer) => (
              <Card
                key={customer.id}
                className="p-4"
                onClick={() => navigate(`/agent/customer/${customer.id}`)}
              >
                <div className="flex items-start gap-3">
                  <img
                    src={customer.customerPhoto || `https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff`}
                    alt={customer.name}
                    className="w-12 h-12 rounded-full object-cover"
                  />
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between">
                      <div>
                        <div className="flex items-center gap-2 flex-wrap">
                          <h3 className="font-semibold text-slate-800 dark:text-white">
                            {customer.name}
                          </h3>
                          {customer.isEditUnlocked ? (
                            <span className="text-[10px] font-semibold px-1.5 py-0.5 rounded bg-success-50 dark:bg-success-900/20 text-success-600 dark:text-success-400 flex items-center gap-0.5">
                              🔓 Unlocked
                            </span>
                          ) : customer.approvalStatus === 'Pending' ? (
                            <span className="text-[10px] font-medium px-1.5 py-0.5 rounded bg-warning-50 dark:bg-warning-900/20 text-warning-600 dark:text-warning-400">
                              Pending
                            </span>
                          ) : null}
                        </div>
                        <p className="text-xs text-slate-500 dark:text-slate-400">
                          {customer.customerId}
                        </p>
                      </div>
                      {customer.homeAddress.mapUrl && (
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            window.open(customer.homeAddress.mapUrl, '_blank');
                          }}
                          className="p-2 rounded-lg bg-primary-50 dark:bg-primary-900/20 text-primary-600 dark:text-primary-400"
                        >
                          <Navigation className="w-5 h-5" />
                        </button>
                      )}
                    </div>

                    <div className="mt-3 flex flex-wrap gap-3 text-xs">
                      <div className="flex items-center gap-1 text-slate-600 dark:text-slate-300">
                        <Phone className="w-3.5 h-3.5" />
                        {customer.primaryMobile}
                      </div>
                      {customer.homeAddress.district && (
                        <div className="flex items-center gap-1 text-slate-500 dark:text-slate-400">
                          <MapPin className="w-3.5 h-3.5" />
                          {customer.homeAddress.district}
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              </Card>
            ))
          )}
        </div>
      )}
    </div>
  );
}

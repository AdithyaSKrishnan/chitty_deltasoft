import { useCallback, useEffect, useState, useRef } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Table, Pagination, SearchBar } from '../../components/ui/Table';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { Customer } from '../../types';
import { StatusBadge } from '../../components/ui/Badge';
import { Plus, Eye, MapPin, Phone, Mail } from 'lucide-react';
import { fetchCustomers, mapApiError } from '../../services/api';

function CustomerNameCell({ name, customerId, customerPhoto }: { name: string; customerId: string; customerPhoto?: string }) {
  const [isScrolling, setIsScrolling] = useState(false);
  const timerRef = useRef<NodeJS.Timeout | null>(null);

  const needsTruncation = name.length > 25;
  const truncatedName = needsTruncation ? `${name.substring(0, 22)}...` : name;

  const handleMouseEnter = () => {
    if (!needsTruncation) return;
    timerRef.current = setTimeout(() => {
      setIsScrolling(true);
    }, 1000);
  };

  const handleMouseLeave = () => {
    setIsScrolling(false);
    if (timerRef.current) {
      clearTimeout(timerRef.current);
      timerRef.current = null;
    }
  };

  return (
    <div className="flex items-center gap-3">
      <img
        src={customerPhoto || `https://ui-avatars.com/api/?name=${encodeURIComponent(name)}&background=3b82f6&color=fff`}
        alt={name}
        className="w-10 h-10 rounded-full object-cover shrink-0"
      />
      <div
        className="min-w-0 max-w-[210px] overflow-hidden"
        onMouseEnter={handleMouseEnter}
        onMouseLeave={handleMouseLeave}
        title={name}
      >
        {isScrolling ? (
          <div className="whitespace-nowrap animate-marquee font-medium text-slate-800 dark:text-white">
            <span className="inline-block pr-6">{name}</span>
            <span className="inline-block pr-6">{name}</span>
          </div>
        ) : (
          <p className="font-medium text-slate-800 dark:text-white truncate">
            {truncatedName}
          </p>
        )}
        <p className="text-xs text-slate-500 dark:text-slate-400">{customerId}</p>
      </div>
    </div>
  );
}

function EmailCell({ email }: { email?: string }) {
  const [isScrolling, setIsScrolling] = useState(false);
  const timerRef = useRef<NodeJS.Timeout | null>(null);

  if (!email) return <span className="text-slate-400 text-xs">—</span>;

  const needsTruncation = email.length > 25;
  const truncatedEmail = needsTruncation ? `${email.substring(0, 22)}...` : email;

  const handleMouseEnter = () => {
    if (!needsTruncation) return;
    timerRef.current = setTimeout(() => {
      setIsScrolling(true);
    }, 1000);
  };

  const handleMouseLeave = () => {
    setIsScrolling(false);
    if (timerRef.current) {
      clearTimeout(timerRef.current);
      timerRef.current = null;
    }
  };

  return (
    <div className="flex items-center gap-1.5 text-sm text-slate-600 dark:text-slate-300">
      <Mail className="w-4 h-4 shrink-0 text-slate-400" />
      <div
        className="min-w-0 max-w-[170px] overflow-hidden"
        onMouseEnter={handleMouseEnter}
        onMouseLeave={handleMouseLeave}
        title={email}
      >
        {isScrolling ? (
          <div className="whitespace-nowrap animate-marquee font-normal text-slate-700 dark:text-slate-200">
            <span className="inline-block pr-6">{email}</span>
            <span className="inline-block pr-6">{email}</span>
          </div>
        ) : (
          <span className="truncate font-normal text-slate-700 dark:text-slate-200 block">
            {truncatedEmail}
          </span>
        )}
      </div>
    </div>
  );
}

const PAGE_SIZE = 10;

export default function CustomersPage() {
  const navigate = useNavigate();
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');

  const loadCustomers = useCallback(async () => {
    setIsLoading(true);
    setError('');
    try {
      const data = await fetchCustomers(search ? { search } : {});
      setCustomers(data);
      setCurrentPage(1);
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

  const paginatedCustomers = customers.slice(
    (currentPage - 1) * PAGE_SIZE,
    currentPage * PAGE_SIZE,
  );

  const columns = [
    {
      key: 'name',
      header: 'Customer',
      className: 'w-[260px] min-w-[220px]',
      render: (customer: Customer) => (
        <CustomerNameCell
          name={customer.name}
          customerId={customer.customerId}
          customerPhoto={customer.customerPhoto}
        />
      ),
    },
    {
      key: 'primaryMobile',
      header: 'Contact',
      className: 'w-[150px] min-w-[130px]',
      render: (customer: Customer) => (
        <div className="space-y-1">
          <div className="flex items-center gap-1.5 text-sm text-slate-600 dark:text-slate-300">
            <Phone className="w-3.5 h-3.5" />
            {customer.primaryMobile}
          </div>
          {customer.alternateMobile && (
            <div className="flex items-center gap-1.5 text-xs text-slate-400">
              <Phone className="w-3 h-3" />
              {customer.alternateMobile}
            </div>
          )}
        </div>
      ),
    },
    {
      key: 'email',
      header: 'Email',
      className: 'w-[180px] min-w-[150px]',
      render: (customer: Customer) => (
        <EmailCell email={customer.email} />
      ),
    },
    {
      key: 'address',
      header: 'Location',
      className: 'w-[90px] min-w-[70px] text-center',
      render: (customer: Customer) => {
        const home = customer.homeAddress;
        const current = customer.currentAddress;
        const hasValidCoords = (home?.latitude != null && home?.longitude != null && Number(home.latitude) !== 0 && Number(home.latitude) !== 17.385 && Number(home.latitude) !== 8.8932) || (current?.latitude != null && current?.longitude != null && Number(current.latitude) !== 0 && Number(current.latitude) !== 17.385 && Number(current.latitude) !== 8.8932);
        
        const mapUrl = hasValidCoords ? (home?.mapUrl || current?.mapUrl || `https://maps.google.com/?q=${home?.latitude || current?.latitude},${home?.longitude || current?.longitude}`) : '';

        if (!mapUrl || !hasValidCoords) {
          return <span className="text-slate-400 text-xs">—</span>;
        }

        return (
          <button
            onClick={(e) => {
              e.stopPropagation();
              window.open(mapUrl, '_blank');
            }}
            className="inline-flex items-center justify-center w-8 h-8 rounded-lg bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 hover:bg-blue-100 dark:hover:bg-blue-900/50 transition-colors"
            title="Open location on Google Maps"
          >
            <MapPin className="w-4 h-4" />
          </button>
        );
      },
    },
    {
      key: 'approvalStatus',
      header: 'Approval Status',
      className: 'w-[160px] min-w-[130px]',
      render: (customer: Customer) => (
        <StatusBadge status={customer.approvalStatus ? customer.approvalStatus.toLowerCase() : 'pending'} />
      ),
    },
    {
      key: 'actions',
      header: 'Actions',
      className: 'w-[70px] min-w-[60px] text-right',
      render: (customer: Customer) => (
        <div className="flex items-center justify-end">
          <button
            onClick={(e) => {
              e.stopPropagation();
              navigate(`/admin/customers/${customer.id}`);
            }}
            className="p-2 rounded-lg bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400 hover:bg-blue-100 dark:hover:bg-blue-900/40 transition-colors"
            title="View Customer Details"
          >
            <Eye className="w-4 h-4" />
          </button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Customers"
        subtitle="Manage all customer records"
        action={
          <Link to="/admin/customers/add">
            <Button icon={<Plus className="w-4 h-4" />}>Add Customer</Button>
          </Link>
        }
      />

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <Card>
        <div className="flex flex-col sm:flex-row gap-4 mb-4">
          <SearchBar
            value={search}
            onChange={setSearch}
            placeholder="Search by name, ID, or phone..."
          />
        </div>

        {isLoading ? (
          <div className="flex justify-center py-16">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : (
          <>
            <Table
              columns={columns}
              data={paginatedCustomers}
              keyExtractor={(c) => c.id}
              onRowClick={(c) => navigate(`/admin/customers/${c.id}`)}
              emptyMessage="No customers found"
            />

            <Pagination
              currentPage={currentPage}
              totalPages={Math.max(1, Math.ceil(customers.length / PAGE_SIZE))}
              onPageChange={setCurrentPage}
            />
          </>
        )}
      </Card>
    </div>
  );
}

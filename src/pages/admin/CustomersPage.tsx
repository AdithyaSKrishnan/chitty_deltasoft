import { useCallback, useEffect, useState, useRef } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Table, Pagination, SearchBar } from '../../components/ui/Table';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { Customer } from '../../types';
import { StatusBadge } from '../../components/ui/Badge';
import { Plus, Eye, Edit, Trash2, MapPin, Phone, Mail } from 'lucide-react';
import { Modal } from '../../components/ui/Modal';
import { deleteCustomer, fetchCustomers, mapApiError } from '../../services/api';

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
  const [deleteModal, setDeleteModal] = useState<{ open: boolean; customer: Customer | null }>({
    open: false,
    customer: null,
  });
  const [isDeleting, setIsDeleting] = useState(false);

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

  const handleDelete = async () => {
    if (!deleteModal.customer) return;
    setIsDeleting(true);
    try {
      await deleteCustomer(deleteModal.customer.id);
      setDeleteModal({ open: false, customer: null });
      await loadCustomers();
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsDeleting(false);
    }
  };

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
        const mapUrl = home?.mapUrl || current?.mapUrl || (home?.latitude != null && home?.longitude != null ? `https://maps.google.com/?q=${home.latitude},${home.longitude}` : '');
        
        if (!mapUrl) {
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
      className: 'w-[120px] min-w-[100px] text-right',
      render: (customer: Customer) => (
        <div className="flex items-center gap-1">
          <button
            onClick={(e) => {
              e.stopPropagation();
              navigate(`/admin/customers/${customer.id}`);
            }}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-500 hover:text-primary-600 transition-colors"
          >
            <Eye className="w-4 h-4" />
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              navigate(`/admin/customers/edit/${customer.id}`);
            }}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-500 hover:text-accent-600 transition-colors"
          >
            <Edit className="w-4 h-4" />
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              setDeleteModal({ open: true, customer });
            }}
            className="p-2 rounded-lg hover:bg-red-50 dark:hover:bg-red-900/20 text-slate-500 hover:text-red-600 transition-colors"
          >
            <Trash2 className="w-4 h-4" />
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

      <Modal
        isOpen={deleteModal.open}
        onClose={() => setDeleteModal({ open: false, customer: null })}
        title="Delete Customer"
        size="sm"
      >
        <p className="text-slate-600 dark:text-slate-300 mb-6">
          Are you sure you want to delete{' '}
          <span className="font-semibold">{deleteModal.customer?.name}</span>? This action
          cannot be undone.
        </p>
        <div className="flex gap-3 justify-end">
          <Button
            variant="secondary"
            onClick={() => setDeleteModal({ open: false, customer: null })}
          >
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

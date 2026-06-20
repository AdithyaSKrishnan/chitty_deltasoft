import { useCallback, useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Table, Pagination, SearchBar } from '../../components/ui/Table';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { Customer } from '../../types';
import { Plus, Eye, Edit, Trash2, MapPin, Phone, Mail } from 'lucide-react';
import { Modal } from '../../components/ui/Modal';
import { deleteCustomer, fetchCustomers, mapApiError } from '../../services/api';

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
      render: (customer: Customer) => (
        <div className="flex items-center gap-3">
          <img
            src={`https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff`}
            alt={customer.name}
            className="w-10 h-10 rounded-full"
          />
          <div>
            <p className="font-medium text-slate-800 dark:text-white">{customer.name}</p>
            <p className="text-xs text-slate-500 dark:text-slate-400">{customer.customerId}</p>
          </div>
        </div>
      ),
    },
    {
      key: 'primaryMobile',
      header: 'Contact',
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
      render: (customer: Customer) => (
        <div className="flex items-center gap-1.5 text-sm text-slate-600 dark:text-slate-300">
          <Mail className="w-4 h-4" />
          {customer.email || '—'}
        </div>
      ),
    },
    {
      key: 'address',
      header: 'Location',
      render: (customer: Customer) => (
        <div className="flex items-center gap-1.5 text-sm text-slate-600 dark:text-slate-300">
          <MapPin className="w-4 h-4" />
          {customer.homeAddress.district
            ? `${customer.homeAddress.district}, ${customer.homeAddress.state}`
            : '—'}
        </div>
      ),
    },
    {
      key: 'actions',
      header: 'Actions',
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

import { useState, useEffect, useCallback } from 'react';
import { Table, Pagination, SearchBar } from '../../components/ui/Table';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { StatusBadge, Badge } from '../../components/ui/Badge';
import { Modal } from '../../components/ui/Modal';
import { Employee } from '../../types';
import { Plus, Edit, Power, Mail, Phone, Users, Shield } from 'lucide-react';
import {
  fetchEmployees,
  createEmployee,
  updateEmployee,
  toggleEmployeeStatus,
  mapApiError,
} from '../../services/api';

const PAGE_SIZE = 10;

export default function EmployeesPage() {
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [showModal, setShowModal] = useState(false);
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState('');
  const [editingEmployee, setEditingEmployee] = useState<Employee | null>(null);
  
  const [formData, setFormData] = useState({
    name: '',
    username: '',
    email: '',
    phone: '',
    role: 'agent' as 'subadmin' | 'agent',
    password: '',
  });

  const loadEmployees = useCallback(async () => {
    setIsLoading(true);
    setError('');
    try {
      const data = await fetchEmployees(search ? { search } : {});
      setEmployees(data);
      setCurrentPage(1);
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsLoading(false);
    }
  }, [search]);

  useEffect(() => {
    const timer = setTimeout(() => {
      loadEmployees();
    }, 300);
    return () => clearTimeout(timer);
  }, [loadEmployees]);

  const handleOpenModal = (employee?: Employee) => {
    setError('');
    if (employee) {
      setEditingEmployee(employee);
      setFormData({
        name: employee.name,
        username: employee.username,
        email: employee.email,
        phone: employee.phone,
        role: employee.role === 'admin' ? 'subadmin' : (employee.role as 'subadmin' | 'agent'),
        password: '',
      });
    } else {
      setEditingEmployee(null);
      setFormData({
        name: '',
        username: '',
        email: '',
        phone: '',
        role: 'agent',
        password: '',
      });
    }
    setShowModal(true);
  };

  const handleSave = async () => {
    if (!formData.name || (!editingEmployee && !formData.username) || !formData.email || (!editingEmployee && !formData.password)) {
      setError('Please fill in all required fields.');
      return;
    }
    setError('');
    setIsSaving(true);
    try {
      if (editingEmployee) {
        await updateEmployee(editingEmployee.id, {
          name: formData.name,
          email: formData.email,
          phone: formData.phone,
          role: formData.role,
        });
      } else {
        await createEmployee({
          name: formData.name,
          username: formData.username,
          email: formData.email,
          phone: formData.phone,
          role: formData.role,
          password: formData.password,
        });
      }
      setShowModal(false);
      await loadEmployees();
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsSaving(false);
    }
  };

  const handleToggleStatus = async (emp: Employee) => {
    setError('');
    try {
      await toggleEmployeeStatus(emp.id);
      await loadEmployees();
    } catch (err) {
      setError(mapApiError(err));
    }
  };

  const paginatedEmployees = employees.slice(
    (currentPage - 1) * PAGE_SIZE,
    currentPage * PAGE_SIZE,
  );

  const columns = [
    {
      key: 'name',
      header: 'Employee',
      render: (emp: Employee) => (
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary-400 to-primary-500 flex items-center justify-center text-white font-semibold">
            {emp.name.charAt(0)}
          </div>
          <div>
            <p className="font-medium text-slate-800 dark:text-white">{emp.name}</p>
            <p className="text-xs text-slate-500 dark:text-slate-400">{emp.employeeId}</p>
          </div>
        </div>
      ),
    },
    {
      key: 'username',
      header: 'Username',
      render: (emp: Employee) => (
        <span className="text-sm font-mono text-slate-600 dark:text-slate-300">@{emp.username}</span>
      ),
    },
    {
      key: 'contact',
      header: 'Contact',
      render: (emp: Employee) => (
        <div className="space-y-1">
          <div className="flex items-center gap-1.5 text-sm text-slate-600 dark:text-slate-300">
            <Mail className="w-3.5 h-3.5" />
            {emp.email}
          </div>
          <div className="flex items-center gap-1.5 text-xs text-slate-400">
            <Phone className="w-3 h-3" />
            {emp.phone || '—'}
          </div>
        </div>
      ),
    },
    {
      key: 'role',
      header: 'Role',
      render: (emp: Employee) => (
        <Badge variant={emp.role === 'admin' ? 'success' : emp.role === 'subadmin' ? 'info' : 'default'}>
          {emp.role === 'admin' ? (
            <span className="flex items-center gap-1"><Shield className="w-3 h-3" /> Admin</span>
          ) : emp.role === 'subadmin' ? (
            <span className="flex items-center gap-1"><Shield className="w-3 h-3" /> Subadmin</span>
          ) : (
            <span className="flex items-center gap-1"><Users className="w-3 h-3" /> Agent</span>
          )}
        </Badge>
      ),
    },
    {
      key: 'customersCount',
      header: 'Customers',
      render: (emp: Employee) => <span className="font-medium text-slate-800 dark:text-white">{emp.customersCount}</span>,
    },
    {
      key: 'isActive',
      header: 'Status',
      render: (emp: Employee) => <StatusBadge status={emp.isActive ? 'active' : 'paused'} />,
    },
    {
      key: 'actions',
      header: 'Actions',
      render: (emp: Employee) => (
        <div className="flex items-center gap-1">
          <button
            onClick={(e) => { e.stopPropagation(); handleOpenModal(emp); }}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-500 hover:text-primary-600 transition-colors"
            title="Edit Employee"
          >
            <Edit className="w-4 h-4" />
          </button>
          {emp.role !== 'admin' && (
            <button
              onClick={(e) => { e.stopPropagation(); handleToggleStatus(emp); }}
              className={`p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors ${emp.isActive ? 'text-green-600 hover:text-green-700' : 'text-red-400 hover:text-red-500'}`}
              title={emp.isActive ? 'Deactivate Employee' : 'Activate Employee'}
            >
              <Power className="w-4 h-4" />
            </button>
          )}
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Employees"
        subtitle="Manage team members"
        action={<Button icon={<Plus className="w-4 h-4" />} onClick={() => handleOpenModal()}>Add Employee</Button>}
      />

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <Card>
        <div className="flex flex-col sm:flex-row gap-4 mb-4">
          <SearchBar value={search} onChange={setSearch} placeholder="Search employees..." />
        </div>

        {isLoading ? (
          <div className="flex justify-center py-16">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : (
          <>
            <Table columns={columns} data={paginatedEmployees} keyExtractor={(e) => e.id} emptyMessage="No employees found" />
            <Pagination currentPage={currentPage} totalPages={Math.max(1, Math.ceil(employees.length / PAGE_SIZE))} onPageChange={setCurrentPage} />
          </>
        )}
      </Card>

      <Modal isOpen={showModal} onClose={() => setShowModal(false)} title={editingEmployee ? 'Edit Employee' : 'Add Employee'}>
        <div className="space-y-4">
          {error && (
            <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
              {error}
            </div>
          )}
          
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="form-label">Full Name</label>
              <input
                type="text"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="Enter full name"
                required
              />
            </div>
            <div>
              <label className="form-label">Username</label>
              <input
                type="text"
                value={formData.username}
                onChange={(e) => setFormData({ ...formData, username: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="Enter username"
                disabled={!!editingEmployee}
                required
              />
            </div>
          </div>
          <div>
            <label className="form-label">Email Address</label>
            <input
              type="email"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              className="glass-input w-full py-2.5 px-4"
              placeholder="employee@chittyfinance.com"
              required
            />
          </div>
          <div>
            <label className="form-label">Phone Number</label>
            <input
              type="tel"
              value={formData.phone}
              onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
              className="glass-input w-full py-2.5 px-4"
              placeholder="+91 XXXXX XXXXX"
            />
          </div>
          <div>
            <label className="form-label">Role</label>
            {/* Admin role is excluded from creation or editing selections to prevent adding new Admins */}
            <select
              value={formData.role}
              onChange={(e) => setFormData({ ...formData, role: e.target.value as any })}
              className="glass-input w-full py-2.5 px-4"
            >
              <option value="agent">Field Agent</option>
              <option value="subadmin">Subadmin</option>
            </select>
          </div>
          {!editingEmployee && (
            <div>
              <label className="form-label">Password</label>
              <input
                type="password"
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="Set password"
                required
              />
            </div>
          )}
        </div>
        <div className="flex gap-3 justify-end mt-6">
          <Button variant="secondary" onClick={() => setShowModal(false)}>Cancel</Button>
          <Button onClick={handleSave} isLoading={isSaving}>
            {editingEmployee ? 'Update Employee' : 'Add Employee'}
          </Button>
        </div>
      </Modal>
    </div>
  );
}
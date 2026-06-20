import { useState } from 'react';
import { Table, Pagination, SearchBar } from '../../components/ui/Table';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { StatusBadge, Badge } from '../../components/ui/Badge';
import { Modal } from '../../components/ui/Modal';
import { mockEmployees } from '../../data/mockData';
import { Employee } from '../../types';
import { Plus, Edit, Power, Mail, Phone, Users, Shield } from 'lucide-react';

export default function EmployeesPage() {
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [showModal, setShowModal] = useState(false);
  const [editingEmployee, setEditingEmployee] = useState<Employee | null>(null);
  const [formData, setFormData] = useState({
    name: '',
    username: '',
    email: '',
    phone: '',
    role: 'agent' as 'admin' | 'agent',
    password: '',
  });

  const filteredEmployees = mockEmployees.filter(
    (e) =>
      e.name.toLowerCase().includes(search.toLowerCase()) ||
      e.username.toLowerCase().includes(search.toLowerCase()) ||
      e.email.toLowerCase().includes(search.toLowerCase())
  );

  const handleOpenModal = (employee?: Employee) => {
    if (employee) {
      setEditingEmployee(employee);
      setFormData({
        name: employee.name,
        username: employee.username,
        email: employee.email,
        phone: employee.phone,
        role: employee.role,
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
            {emp.phone}
          </div>
        </div>
      ),
    },
    {
      key: 'role',
      header: 'Role',
      render: (emp: Employee) => (
        <Badge variant={emp.role === 'admin' ? 'info' : 'default'}>
          {emp.role === 'admin' ? (
            <span className="flex items-center gap-1">
              <Shield className="w-3 h-3" /> Admin
            </span>
          ) : (
            <span className="flex items-center gap-1">
              <Users className="w-3 h-3" /> Agent
            </span>
          )}
        </Badge>
      ),
    },
    {
      key: 'customersCount',
      header: 'Customers',
      render: (emp: Employee) => (
        <span className="font-medium text-slate-800 dark:text-white">{emp.customersCount}</span>
      ),
    },
    {
      key: 'isActive',
      header: 'Status',
      render: (emp: Employee) => (
        <StatusBadge status={emp.isActive ? 'active' : 'paused'} />
      ),
    },
    {
      key: 'actions',
      header: 'Actions',
      render: (emp: Employee) => (
        <div className="flex items-center gap-1">
          <button
            onClick={(e) => {
              e.stopPropagation();
              handleOpenModal(emp);
            }}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-500 hover:text-primary-600 transition-colors"
          >
            <Edit className="w-4 h-4" />
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              // Toggle active status
            }}
            className={`p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors ${
              emp.isActive
                ? 'text-slate-500 hover:text-red-600'
                : 'text-slate-500 hover:text-accent-600'
            }`}
          >
            <Power className="w-4 h-4" />
          </button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Employees"
        subtitle="Manage team members"
        action={
          <Button icon={<Plus className="w-4 h-4" />} onClick={() => handleOpenModal()}>
            Add Employee
          </Button>
        }
      />

      <Card>
        <div className="flex flex-col sm:flex-row gap-4 mb-4">
          <SearchBar value={search} onChange={setSearch} placeholder="Search employees..." />
          <select className="glass-input py-2.5 px-4 text-sm">
            <option>All Roles</option>
            <option>Admin</option>
            <option>Agent</option>
          </select>
          <select className="glass-input py-2.5 px-4 text-sm">
            <option>All Status</option>
            <option>Active</option>
            <option>Inactive</option>
          </select>
        </div>

        <Table
          columns={columns}
          data={filteredEmployees}
          keyExtractor={(e) => e.id}
          emptyMessage="No employees found"
        />

        <Pagination
          currentPage={currentPage}
          totalPages={Math.ceil(filteredEmployees.length / 10)}
          onPageChange={setCurrentPage}
        />
      </Card>

      {/* Add/Edit Modal */}
      <Modal
        isOpen={showModal}
        onClose={() => setShowModal(false)}
        title={editingEmployee ? 'Edit Employee' : 'Add Employee'}
      >
        <div className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="form-label">Full Name</label>
              <input
                type="text"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="Enter full name"
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
            <div className="flex gap-4 mt-2">
              <label className="flex items-center gap-2 cursor-pointer">
                <input
                  type="radio"
                  name="role"
                  checked={formData.role === 'admin'}
                  onChange={() => setFormData({ ...formData, role: 'admin' })}
                  className="w-4 h-4 text-primary-600"
                />
                <span className="text-sm text-slate-700 dark:text-slate-300">Admin</span>
              </label>
              <label className="flex items-center gap-2 cursor-pointer">
                <input
                  type="radio"
                  name="role"
                  checked={formData.role === 'agent'}
                  onChange={() => setFormData({ ...formData, role: 'agent' })}
                  className="w-4 h-4 text-primary-600"
                />
                <span className="text-sm text-slate-700 dark:text-slate-300">Field Agent</span>
              </label>
            </div>
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
              />
            </div>
          )}
        </div>

        <div className="flex gap-3 justify-end mt-6">
          <Button variant="secondary" onClick={() => setShowModal(false)}>
            Cancel
          </Button>
          <Button onClick={() => setShowModal(false)}>
            {editingEmployee ? 'Update Employee' : 'Add Employee'}
          </Button>
        </div>
      </Modal>
    </div>
  );
}

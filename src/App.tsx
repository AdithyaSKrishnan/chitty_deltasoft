import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './hooks/useAuth';
import { ThemeProvider } from './hooks/useTheme';

import AdminLayout from './components/layout/AdminLayout';
import AgentLayout from './components/layout/AgentLayout';

import LoginPage from './pages/LoginPage';
import Dashboard from './pages/admin/Dashboard';
import CustomersPage from './pages/admin/CustomersPage';
import CustomerFormPage from './pages/admin/CustomerFormPage';
import CustomerDetailPage from './pages/admin/CustomerDetailPage';
import ChitPlansPage from './pages/admin/ChitPlansPage';
import SubscriptionsPage from './pages/admin/SubscriptionsPage';
import EmployeesPage from './pages/admin/EmployeesPage';
import ReportsPage from './pages/admin/ReportsPage';
import SettingsPage from './pages/admin/SettingsPage';

import MyCustomersPage from './pages/agent/MyCustomersPage';
import AddCustomerPage from './pages/agent/AddCustomerPage';
import EnrollPage from './pages/agent/EnrollPage';
import AgentCustomerDetailPage from './pages/agent/CustomerDetailPage';
import SubadminLoginPage from './pages/SubadminLoginPage';
import EditCustomerPage from './pages/agent/EditCustomerPage';

function LoadingScreen() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-900">
      <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
    </div>
  );
}

function ProtectedRoute({ children, role }: { children: React.ReactNode; role?: 'admin' | 'agent' }) {
  const { isAuthenticated, user, isLoading } = useAuth();

  if (isLoading) return <LoadingScreen />;
  if (!isAuthenticated) return <Navigate to="/login" replace />;

  // Map subadmin into the administrative environment mapping layout
  const normalizedRole = (user?.role === 'admin' || user?.role === 'subadmin') ? 'admin' : 'agent';

  if (role && normalizedRole !== role) {
    return <Navigate to={normalizedRole === 'admin' ? '/admin' : '/agent'} replace />;
  }

  return <>{children}</>;
}

function GuestRoute({ children }: { children: React.ReactNode }) {
  const { isAuthenticated, user, isLoading } = useAuth();
  if (isLoading) return <LoadingScreen />;
  if (isAuthenticated && user) {
    const defaultPath = (user.role === 'admin' || user.role === 'subadmin') ? '/admin' : '/agent';
    return <Navigate to={defaultPath} replace />;
  }
  return <>{children}</>;
}

function AppRoutes() {
  return (
    <Routes>
      <Route path="/login" element={<GuestRoute><LoginPage /></GuestRoute>} />
      <Route path="/subadmin-login" element={<GuestRoute><SubadminLoginPage /></GuestRoute>} />
      <Route path="/" element={<Navigate to="/login" replace />} />

      {/* Admin and Subadmin Route Matrices */}
      <Route path="/admin" element={<ProtectedRoute role="admin"><AdminLayout /></ProtectedRoute>}>
        <Route index element={<Dashboard />} />
        <Route path="customers" element={<CustomersPage />} />
        <Route path="customers/add" element={<CustomerFormPage />} />
        <Route path="customers/edit/:id" element={<CustomerFormPage />} />
        <Route path="customers/:id" element={<CustomerDetailPage />} />
        <Route path="plans" element={<ChitPlansPage />} />
        <Route path="plans/add" element={<ChitPlansPage />} />
        <Route path="subscriptions" element={<SubscriptionsPage />} />
        <Route path="employees" element={<EmployeesPage />} />
        <Route path="employees/add" element={<EmployeesPage />} />
        <Route path="reports" element={<ReportsPage />} />
        <Route path="settings" element={<SettingsPage />} />
      </Route>

      {/* Agent Route Matrices */}
      <Route path="/agent" element={<ProtectedRoute role="agent"><AgentLayout /></ProtectedRoute>}>
        <Route index element={<MyCustomersPage />} />
        <Route path="customer/:id" element={<AgentCustomerDetailPage />} />
        <Route path="customer/edit/:id" element={<EditCustomerPage />} />
        <Route path="add-customer" element={<AddCustomerPage />} />
        <Route path="enroll" element={<EnrollPage />} />
      </Route>

      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <ThemeProvider>
        <AuthProvider>
          <AppRoutes />
        </AuthProvider>
      </ThemeProvider>
    </BrowserRouter>
  );
}
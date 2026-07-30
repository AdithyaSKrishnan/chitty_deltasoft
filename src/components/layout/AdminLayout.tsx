import { Outlet, NavLink, useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import { useTheme } from '../../hooks/useTheme';
import {
  LayoutDashboard,
  Users,
  UserCog,
  FileText,
  CreditCard,
  BarChart3,
  Settings,
  LogOut,
  Moon,
  Sun,
  Menu,
  X,
  Bell,
} from 'lucide-react';
import { useEffect, useState } from 'react';
import { fetchCustomers, fetchCustomerEditRequests } from '../../services/api';

const navItems = [
  { to: '/admin', icon: LayoutDashboard, label: 'Dashboard', end: true },
  { to: '/admin/customers', icon: Users, label: 'Customers' },
  { to: '/admin/employees', icon: UserCog, label: 'Employees' },
  { to: '/admin/plans', icon: FileText, label: 'Chit Plans' },
  { to: '/admin/subscriptions', icon: CreditCard, label: 'Subscriptions' },
  { to: '/admin/reports', icon: BarChart3, label: 'Reports' },
  { to: '/admin/settings', icon: Settings, label: 'Settings' },
];

export default function AdminLayout() {
  const { user, logout } = useAuth();
  const { isDark, toggleTheme } = useTheme();
  const navigate = useNavigate();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [pendingCount, setPendingCount] = useState(0);
  const [pendingVerificationCount, setPendingVerificationCount] = useState(0);
  const [showVerificationModal, setShowVerificationModal] = useState(false);

  useEffect(() => {
    let isMounted = true;
    const loadPendingCount = async () => {
      try {
        const [pendingCustomers, editRequests] = await Promise.all([
          fetchCustomers({ approval_status: 'Pending' }),
          fetchCustomerEditRequests({ status: 'Pending' }),
        ]);
        if (isMounted) {
          const verificationCount = pendingCustomers?.length || 0;
          setPendingVerificationCount(verificationCount);
          const totalCount = verificationCount + (editRequests?.length || 0);
          setPendingCount(totalCount);
        }
      } catch (err) {
        console.error('Error fetching pending requests count:', err);
      }
    };

    loadPendingCount();
    const interval = setInterval(loadPendingCount, 10000);
    return () => {
      isMounted = false;
      clearInterval(interval);
    };
  }, []);

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-100 via-slate-50 to-blue-50 dark:from-slate-900 dark:via-slate-900 dark:to-slate-800">
      {/* Mobile sidebar overlay */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-40 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`fixed top-0 left-0 h-full w-64 glass-sidebar z-50 transform transition-transform duration-300 ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
        }`}
      >
        <div className="flex flex-col h-full">
          {/* Logo */}
          <div className="p-6 border-b border-slate-200/50 dark:border-slate-700/50">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-primary-500 to-primary-600 flex items-center justify-center shadow-lg shadow-primary-500/25">
                  <CreditCard className="w-5 h-5 text-white" />
                </div>
                <div>
                  <h1 className="font-bold text-lg text-slate-800 dark:text-white">
                    ChittyFinance
                  </h1>
                  <p className="text-xs text-slate-500 dark:text-slate-400">
                    Admin Panel
                  </p>
                </div>
              </div>
              <button
                onClick={() => setSidebarOpen(false)}
                className="lg:hidden p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
          </div>

          {/* Navigation */}
          <nav className="flex-1 p-4 space-y-1 overflow-y-auto scrollbar-thin">
            {navItems.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                end={item.end}
                className={({ isActive }) =>
                  `nav-item flex items-center gap-3 ${isActive ? 'nav-item-active' : ''}`
                }
                onClick={() => setSidebarOpen(false)}
              >
                <item.icon className="w-5 h-5 shrink-0" />
                <span className="flex-1">{item.label}</span>
                {item.label === 'Customers' && pendingCount > 0 && (
                  <span className="ml-auto flex items-center justify-center min-w-[20px] h-5 px-1.5 text-[11px] font-semibold rounded-full bg-red-500 text-white">
                    {pendingCount}
                  </span>
                )}
              </NavLink>
            ))}
          </nav>

          {/* User section */}
          <div className="p-4 border-t border-slate-200/50 dark:border-slate-700/50">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 rounded-full bg-gradient-to-br from-accent-400 to-accent-500 flex items-center justify-center text-white font-semibold">
                {user?.name?.charAt(0) || 'A'}
              </div>
              <div className="flex-1 min-w-0">
                <p className="font-medium text-slate-800 dark:text-white truncate">
                  {user?.name}
                </p>
                <p className="text-xs text-slate-500 dark:text-slate-400 truncate">
                  {user?.email}
                </p>
              </div>
            </div>
            <div className="flex gap-2">
              <button
                onClick={() => setShowVerificationModal(true)}
                className="relative flex-1 flex items-center justify-center gap-2 py-2 rounded-lg bg-slate-100 dark:bg-slate-700 hover:bg-slate-200 dark:hover:bg-slate-600 transition-colors"
                title="Profile Verification"
              >
                <Bell className="w-4 h-4 text-primary-500" />
                {pendingVerificationCount > 0 && (
                  <span className="absolute -top-1 -right-1 flex items-center justify-center min-w-[18px] h-[18px] px-1 text-[10px] font-bold rounded-full bg-red-500 text-white animate-pulse">
                    {pendingVerificationCount}
                  </span>
                )}
              </button>
              <button
                onClick={toggleTheme}
                className="flex-1 flex items-center justify-center gap-2 py-2 rounded-lg bg-slate-100 dark:bg-slate-700 hover:bg-slate-200 dark:hover:bg-slate-600 transition-colors"
              >
                {isDark ? (
                  <Sun className="w-4 h-4" />
                ) : (
                  <Moon className="w-4 h-4" />
                )}
              </button>
              <button
                onClick={handleLogout}
                className="flex-1 flex items-center justify-center gap-2 py-2 rounded-lg bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 hover:bg-red-100 dark:hover:bg-red-900/30 transition-colors"
              >
                <LogOut className="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <main className="lg:ml-64 min-h-screen">
        {/* Top desktop header bar with Bell icon */}
        <header className="hidden lg:flex sticky top-0 z-30 glass px-6 py-3 items-center justify-between border-b border-slate-200/50 dark:border-slate-700/50">
          <div className="flex items-center gap-3">
            <span className="text-sm font-semibold text-slate-700 dark:text-slate-200">
              Welcome, {user?.name || 'Admin'}
            </span>
          </div>
          <div className="flex items-center gap-3">
            <button
              onClick={() => setShowVerificationModal(true)}
              className="relative p-2 rounded-xl text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700/50 transition-colors"
              title="Profile Verification"
            >
              <Bell className="w-5 h-5 text-primary-500" />
              {pendingVerificationCount > 0 && (
                <span className="absolute top-1 right-1 flex items-center justify-center min-w-[18px] h-[18px] px-1 text-[10px] font-bold rounded-full bg-red-500 text-white animate-pulse">
                  {pendingVerificationCount}
                </span>
              )}
            </button>
            <button
              onClick={toggleTheme}
              className="p-2 rounded-xl text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700/50 transition-colors"
            >
              {isDark ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
            </button>
          </div>
        </header>

        {/* Mobile header */}
        <header className="lg:hidden sticky top-0 z-30 glass px-4 py-3 flex items-center justify-between">
          <button
            onClick={() => setSidebarOpen(true)}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700"
          >
            <Menu className="w-5 h-5" />
          </button>
          <h1 className="font-bold text-slate-800 dark:text-white">
            ChittyFinance
          </h1>
          <div className="flex items-center gap-2">
            <button
              onClick={() => setShowVerificationModal(true)}
              className="relative p-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700"
              title="Profile Verification"
            >
              <Bell className="w-5 h-5 text-primary-500" />
              {pendingVerificationCount > 0 && (
                <span className="absolute top-1 right-1 flex items-center justify-center min-w-[16px] h-[16px] px-1 text-[9px] font-bold rounded-full bg-red-500 text-white animate-pulse">
                  {pendingVerificationCount}
                </span>
              )}
            </button>
            <button
              onClick={toggleTheme}
              className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700"
            >
              {isDark ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
            </button>
          </div>
        </header>

        {/* Page content */}
        <div className="p-4 lg:p-6">
          <Outlet />
        </div>
      </main>

      {/* Profile Verification Modal */}
      {showVerificationModal && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-slate-900 border border-slate-700/80 rounded-2xl p-6 max-w-sm w-full shadow-2xl space-y-4 text-white">
            <div className="flex items-center justify-between">
              <h3 className="text-lg font-bold text-white flex items-center gap-2">
                <Bell className="w-5 h-5 text-primary-400" />
                Profile Verification
              </h3>
              <button
                onClick={() => setShowVerificationModal(false)}
                className="p-1 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            <p className="text-sm text-slate-300">
              {pendingVerificationCount === 1
                ? '1 customer needs to get their profile verified.'
                : `${pendingVerificationCount} customer(s) need to get their profile verified.`}
            </p>
            <div className="flex justify-end pt-2">
              <button
                onClick={() => setShowVerificationModal(false)}
                className="px-5 py-2 text-sm font-semibold rounded-xl bg-primary-600 hover:bg-primary-500 text-white transition-colors"
              >
                OK
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

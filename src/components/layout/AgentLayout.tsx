import { Outlet, NavLink, useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import { Users, UserPlus, FileText, LogOut, Menu, X } from 'lucide-react';
import { useState } from 'react';

const navItems = [
  { to: '/agent', icon: Users, label: 'My Customers', end: true },
  { to: '/agent/add-customer', icon: UserPlus, label: 'Add Customer' },
  { to: '/agent/enroll', icon: FileText, label: 'Enroll' },
];

export default function AgentLayout() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [menuOpen, setMenuOpen] = useState(false);

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-100 via-slate-50 to-blue-50 dark:from-slate-900 dark:via-slate-900 dark:to-slate-800 pb-20">
      {/* Header */}
      <header className="sticky top-0 z-30 glass px-4 py-3">
        <div className="flex items-center justify-between max-w-lg mx-auto">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-primary-500 to-primary-600 flex items-center justify-center shadow-lg shadow-primary-500/25">
              <FileText className="w-5 h-5 text-white" />
            </div>
            <div>
              <h1 className="font-bold text-base text-slate-800 dark:text-white">
                ChittyFinance
              </h1>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {user?.name}
              </p>
            </div>
          </div>
          <button
            onClick={() => setMenuOpen(!menuOpen)}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700"
          >
            {menuOpen ? (
              <X className="w-5 h-5" />
            ) : (
              <Menu className="w-5 h-5" />
            )}
          </button>
        </div>

        {/* Dropdown menu */}
        {menuOpen && (
          <div className="absolute right-4 top-16 w-48 glass-card p-2 shadow-xl animate-scale-in">
            <div className="px-3 py-2 border-b border-slate-200/50 dark:border-slate-700/50 mb-2">
              <p className="text-sm font-medium text-slate-800 dark:text-white">
                {user?.name}
              </p>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {user?.email}
              </p>
            </div>
            <button
              onClick={handleLogout}
              className="w-full flex items-center gap-3 px-3 py-2 rounded-lg text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors"
            >
              <LogOut className="w-4 h-4" />
              <span className="text-sm font-medium">Logout</span>
            </button>
          </div>
        )}
      </header>

      {/* Main content */}
      <main className="p-4 max-w-lg mx-auto">
        <Outlet />
      </main>

      {/* Bottom Navigation */}
      <nav className="fixed bottom-0 left-0 right-0 glass border-t border-slate-200/50 dark:border-slate-700/50 z-30">
        <div className="flex justify-around max-w-lg mx-auto py-2">
          {navItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.end}
              className={({ isActive }) =>
                `mobile-nav-item ${isActive ? 'mobile-nav-item-active' : ''}`
              }
            >
              <item.icon className="w-6 h-6" />
              <span className="text-xs font-medium">{item.label}</span>
            </NavLink>
          ))}
        </div>
      </nav>
    </div>
  );
}

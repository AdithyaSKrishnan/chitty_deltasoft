import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import { useTheme } from '../hooks/useTheme';
import { Input, Button } from '../components/ui/Form';
import { CreditCard, Moon, Sun, User, Lock } from 'lucide-react';

export default function LoginPage() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  const { login } = useAuth();
  const { isDark, toggleTheme } = useTheme();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    try {
      const user = await login(username, password);
      navigate(user.role === 'admin' ? '/admin' : '/agent');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-100 via-slate-50 to-blue-50 dark:from-slate-900 dark:via-slate-900 dark:to-slate-800 flex items-center justify-center p-4">
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-primary-500/10 rounded-full blur-3xl" />
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-accent-500/10 rounded-full blur-3xl" />
      </div>

      <button
        onClick={toggleTheme}
        className="absolute top-4 right-4 p-3 rounded-xl glass hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"
      >
        {isDark ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
      </button>

      <div className="w-full max-w-md">
        <div className="glass-card p-8 animate-fade-in">
          <div className="flex flex-col items-center mb-8">
            <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-primary-500 to-primary-600 flex items-center justify-center shadow-lg shadow-primary-500/25 mb-4">
              <CreditCard className="w-8 h-8 text-white" />
            </div>
            <h1 className="text-2xl font-bold text-slate-800 dark:text-white">
              ChittyFinance
            </h1>
            <p className="text-slate-500 dark:text-slate-400 text-sm mt-1">
              Customer Management System
            </p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <Input
              label="Username"
              placeholder="Enter your username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              icon={<User className="w-4 h-4" />}
              required
            />

            <Input
              label="Password"
              type="password"
              placeholder="Enter your password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              icon={<Lock className="w-4 h-4" />}
              required
            />

            {error && (
              <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
                {error}
              </div>
            )}

            <Button type="submit" className="w-full" isLoading={isLoading}>
              {isLoading ? 'Signing in...' : 'Sign In'}
            </Button>
          </form>

          <div className="mt-6 pt-6 border-t border-slate-200/50 dark:border-slate-700/50">
            <p className="text-center text-xs text-slate-400 dark:text-slate-500">
              Sign in with your employee credentials. Your role determines the dashboard you see.
            </p>
          </div>
        </div>

        <p className="text-center text-xs text-slate-400 dark:text-slate-500 mt-4">
          Protected by JWT Authentication
        </p>
      </div>
    </div>
  );
}

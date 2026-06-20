import { useState } from 'react';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button, Input } from '../../components/ui/Form';
import { useAuth } from '../../hooks/useAuth';
import { useTheme } from '../../hooks/useTheme';
import { Save, Moon, Sun, Bell, Lock, Mail, Smartphone } from 'lucide-react';

export default function SettingsPage() {
  const { user } = useAuth();
  const { isDark, toggleTheme } = useTheme();
  const [notifications, setNotifications] = useState({
    email: true,
    sms: false,
    push: true,
    overdueReminders: true,
    newCustomer: true,
  });

  return (
    <div className="space-y-6 animate-fade-in max-w-4xl mx-auto">
      <PageHeader title="Settings" subtitle="Manage your account preferences" />

      {/* Profile Settings */}
      <Card>
        <div className="flex items-center gap-3 mb-6">
          <div className="w-10 h-10 rounded-xl bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
            <Lock className="w-5 h-5 text-primary-500" />
          </div>
          <div>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Profile Settings</h2>
            <p className="text-sm text-slate-500 dark:text-slate-400">Update your personal information</p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Input label="Full Name" defaultValue={user?.name} />
          <Input label="Email Address" type="email" defaultValue={user?.email} />
          <Input label="Phone Number" defaultValue={user?.phone} />
          <Input label="Username" defaultValue={user?.username} disabled />
        </div>

        <div className="mt-6 pt-6 border-t border-slate-200 dark:border-slate-700">
          <Button icon={<Save className="w-4 h-4" />}>Save Changes</Button>
        </div>
      </Card>

      {/* Appearance */}
      <Card>
        <div className="flex items-center gap-3 mb-6">
          <div className="w-10 h-10 rounded-xl bg-accent-50 dark:bg-accent-900/20 flex items-center justify-center">
            {isDark ? <Moon className="w-5 h-5 text-accent-500" /> : <Sun className="w-5 h-5 text-accent-500" />}
          </div>
          <div>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Appearance</h2>
            <p className="text-sm text-slate-500 dark:text-slate-400">Customize the interface theme</p>
          </div>
        </div>

        <div className="space-y-4">
          <label className="flex items-center justify-between cursor-pointer">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                <Moon className="w-4 h-4 text-slate-600 dark:text-slate-300" />
              </div>
              <div>
                <p className="font-medium text-slate-800 dark:text-white">Dark Mode</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  {isDark ? 'Currently enabled' : 'Currently disabled'}
                </p>
              </div>
            </div>
            <button
              onClick={toggleTheme}
              className={`relative w-14 h-7 rounded-full transition-colors ${
                isDark ? 'bg-primary-500' : 'bg-slate-300 dark:bg-slate-600'
              }`}
            >
              <div
                className={`absolute top-1 w-5 h-5 rounded-full bg-white shadow transition-transform ${
                  isDark ? 'translate-x-8' : 'translate-x-1'
                }`}
              />
            </button>
          </label>
        </div>
      </Card>

      {/* Notifications */}
      <Card>
        <div className="flex items-center gap-3 mb-6">
          <div className="w-10 h-10 rounded-xl bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center">
            <Bell className="w-5 h-5 text-blue-500" />
          </div>
          <div>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Notifications</h2>
            <p className="text-sm text-slate-500 dark:text-slate-400">Configure how you receive alerts</p>
          </div>
        </div>

        <div className="space-y-4">
          <label className="flex items-center justify-between cursor-pointer">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                <Mail className="w-4 h-4 text-slate-600 dark:text-slate-300" />
              </div>
              <div>
                <p className="font-medium text-slate-800 dark:text-white">Email Notifications</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Receive updates via email
                </p>
              </div>
            </div>
            <input
              type="checkbox"
              checked={notifications.email}
              onChange={(e) => setNotifications({ ...notifications, email: e.target.checked })}
              className="w-5 h-5 rounded text-primary-600"
            />
          </label>

          <label className="flex items-center justify-between cursor-pointer">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                <Smartphone className="w-4 h-4 text-slate-600 dark:text-slate-300" />
              </div>
              <div>
                <p className="font-medium text-slate-800 dark:text-white">SMS Alerts</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Get important alerts via SMS
                </p>
              </div>
            </div>
            <input
              type="checkbox"
              checked={notifications.sms}
              onChange={(e) => setNotifications({ ...notifications, sms: e.target.checked })}
              className="w-5 h-5 rounded text-primary-600"
            />
          </label>

          <label className="flex items-center justify-between cursor-pointer">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                <Bell className="w-4 h-4 text-slate-600 dark:text-slate-300" />
              </div>
              <div>
                <p className="font-medium text-slate-800 dark:text-white">Push Notifications</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Browser push notifications
                </p>
              </div>
            </div>
            <input
              type="checkbox"
              checked={notifications.push}
              onChange={(e) => setNotifications({ ...notifications, push: e.target.checked })}
              className="w-5 h-5 rounded text-primary-600"
            />
          </label>
        </div>

        <div className="mt-6 pt-6 border-t border-slate-200 dark:border-slate-700">
          <h3 className="font-medium text-slate-800 dark:text-white mb-4">Alert Types</h3>
          <div className="space-y-3">
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={notifications.overdueReminders}
                onChange={(e) =>
                  setNotifications({ ...notifications, overdueReminders: e.target.checked })
                }
                className="w-5 h-5 rounded text-primary-600"
              />
              <span className="text-sm text-slate-700 dark:text-slate-300">Overdue payment reminders</span>
            </label>
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={notifications.newCustomer}
                onChange={(e) =>
                  setNotifications({ ...notifications, newCustomer: e.target.checked })
                }
                className="w-5 h-5 rounded text-primary-600"
              />
              <span className="text-sm text-slate-700 dark:text-slate-300">New customer onboarded</span>
            </label>
          </div>
        </div>
      </Card>

      {/* Danger Zone */}
      <Card className="border-red-200 dark:border-red-900/50">
        <h2 className="text-lg font-semibold text-red-600 dark:text-red-400 mb-4">Danger Zone</h2>
        <p className="text-sm text-slate-600 dark:text-slate-400 mb-4">
          These actions are irreversible. Please proceed with caution.
        </p>
        <div className="flex gap-3">
          <Button variant="danger">Delete Account</Button>
          <Button variant="secondary">Export Data</Button>
        </div>
      </Card>
    </div>
  );
}

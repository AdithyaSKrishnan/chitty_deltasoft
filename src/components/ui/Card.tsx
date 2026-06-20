import { ReactNode } from 'react';

interface CardProps {
  children: ReactNode;
  className?: string;
  onClick?: () => void;
}

export function Card({ children, className = '', onClick }: CardProps) {
  return (
    <div
      className={`glass-card p-6 ${className}`}
      onClick={onClick}
    >
      {children}
    </div>
  );
}

interface StatCardProps {
  title: string;
  value: string | number;
  subtitle?: string;
  icon: ReactNode;
  trend?: { value: number; isPositive: boolean };
  color?: 'primary' | 'accent' | 'warning' | 'danger';
}

export function StatCard({ title, value, subtitle, icon, trend, color = 'primary' }: StatCardProps) {
  const colorClasses = {
    primary: 'from-primary-400 to-primary-500 shadow-primary-500/25',
    accent: 'from-accent-400 to-accent-500 shadow-accent-500/25',
    warning: 'from-amber-400 to-amber-500 shadow-amber-500/25',
    danger: 'from-red-400 to-red-500 shadow-red-500/25',
  };

  return (
    <div className="stat-card">
      <div className="flex items-start justify-between">
        <div className="flex-1">
          <p className="text-sm font-medium text-slate-500 dark:text-slate-400 mb-1">
            {title}
          </p>
          <p className="text-2xl lg:text-3xl font-bold text-slate-800 dark:text-white">
            {value}
          </p>
          {subtitle && (
            <p className="text-xs text-slate-400 dark:text-slate-500 mt-1">
              {subtitle}
            </p>
          )}
          {trend && (
            <div className="flex items-center gap-1 mt-2">
              <span
                className={`text-xs font-medium ${
                  trend.isPositive
                    ? 'text-green-600 dark:text-green-400'
                    : 'text-red-600 dark:text-red-400'
                }`}
              >
                {trend.isPositive ? '+' : '-'}{Math.abs(trend.value)}%
              </span>
              <span className="text-xs text-slate-400">vs last month</span>
            </div>
          )}
        </div>
        <div
          className={`w-12 h-12 rounded-xl bg-gradient-to-br ${colorClasses[color]} flex items-center justify-center text-white shadow-lg`}
        >
          {icon}
        </div>
      </div>
    </div>
  );
}

interface PageHeaderProps {
  title: string;
  subtitle?: string;
  action?: ReactNode;
}

export function PageHeader({ title, subtitle, action }: PageHeaderProps) {
  return (
    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
      <div>
        <h1 className="text-2xl lg:text-3xl font-bold text-slate-800 dark:text-white">
          {title}
        </h1>
        {subtitle && (
          <p className="text-slate-500 dark:text-slate-400 mt-1">
            {subtitle}
          </p>
        )}
      </div>
      {action && <div>{action}</div>}
    </div>
  );
}

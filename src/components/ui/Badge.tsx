import { ReactNode } from 'react';

interface BadgeProps {
  variant: 'success' | 'warning' | 'danger' | 'info' | 'default';
  children: ReactNode;
  className?: string;
}

export function Badge({ variant, children, className = '' }: BadgeProps) {
  const variants = {
    success: 'badge badge-success',
    warning: 'badge badge-warning',
    danger: 'badge badge-danger',
    info: 'badge badge-info',
    default: 'badge bg-slate-100 dark:bg-slate-700 text-slate-700 dark:text-slate-300',
  };

  return <span className={`${variants[variant]} ${className}`}>{children}</span>;
}

export function StatusBadge({ status }: { status: string }) {
  const statusMap: Record<string, { variant: BadgeProps['variant']; label: string }> = {
    active: { variant: 'success', label: 'Active' },
    completed: { variant: 'info', label: 'Completed' },
    paused: { variant: 'warning', label: 'Paused' },
    pending: { variant: 'warning', label: 'Pending' },
    paid: { variant: 'success', label: 'Paid' },
    overdue: { variant: 'danger', label: 'Overdue' },
  };

  const config = statusMap[status] || { variant: 'default', label: status };

  return <Badge variant={config.variant}>{config.label}</Badge>;
}

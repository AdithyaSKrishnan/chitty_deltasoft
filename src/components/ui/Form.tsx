import { InputHTMLAttributes, SelectHTMLAttributes, TextareaHTMLAttributes, forwardRef } from 'react';

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  icon?: React.ReactNode;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ label, error, icon, className = '', ...props }, ref) => {
    return (
      <div className="w-full">
        {label && <label className="form-label">{label}</label>}
        <div className="relative">
          {icon && (
            <div className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">
              {icon}
            </div>
          )}
          <input
            ref={ref}
            className={`glass-input w-full py-3 ${icon ? 'pl-10' : 'px-4'} ${
              error ? 'border-red-400 focus:border-red-500 focus:ring-red-500/20' : ''
            } ${className}`}
            {...props}
          />
        </div>
        {error && <p className="text-sm text-red-500 mt-1">{error}</p>}
      </div>
    );
  }
);

Input.displayName = 'Input';

interface SelectProps extends SelectHTMLAttributes<HTMLSelectElement> {
  label?: string;
  error?: string;
  options: { value: string; label: string }[];
}

export const Select = forwardRef<HTMLSelectElement, SelectProps>(
  ({ label, error, options, className = '', ...props }, ref) => {
    return (
      <div className="w-full">
        {label && <label className="form-label">{label}</label>}
        <select
          ref={ref}
          className={`glass-input w-full py-3 px-4 appearance-none cursor-pointer ${
            error ? 'border-red-400 focus:border-red-500 focus:ring-red-500/20' : ''
          } ${className}`}
          {...props}
        >
          {options.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>
        {error && <p className="text-sm text-red-500 mt-1">{error}</p>}
      </div>
    );
  }
);

Select.displayName = 'Select';

interface TextareaProps extends TextareaHTMLAttributes<HTMLTextAreaElement> {
  label?: string;
  error?: string;
}

export const Textarea = forwardRef<HTMLTextAreaElement, TextareaProps>(
  ({ label, error, className = '', ...props }, ref) => {
    return (
      <div className="w-full">
        {label && <label className="form-label">{label}</label>}
        <textarea
          ref={ref}
          className={`glass-input w-full py-3 px-4 resize-none ${
            error ? 'border-red-400 focus:border-red-500 focus:ring-red-500/20' : ''
          } ${className}`}
          {...props}
        />
        {error && <p className="text-sm text-red-500 mt-1">{error}</p>}
      </div>
    );
  }
);

Textarea.displayName = 'Textarea';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'danger' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  isLoading?: boolean;
  icon?: React.ReactNode;
}

export function Button({
  children,
  variant = 'primary',
  size = 'md',
  isLoading = false,
  icon,
  className = '',
  disabled,
  ...props
}: ButtonProps) {
  const variants = {
    primary: 'glass-button',
    secondary: 'glass-button-secondary',
    danger: 'bg-gradient-to-r from-red-500 to-red-600 dark:from-red-400 dark:to-red-500 text-white font-semibold rounded-xl shadow-lg shadow-red-500/25 hover:shadow-xl hover:shadow-red-500/30 hover:-translate-y-0.5 active:translate-y-0 transition-all duration-200',
    ghost: 'text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 font-medium rounded-xl transition-all duration-200',
  };

  const sizes = {
    sm: 'px-3 py-2 text-sm',
    md: 'px-4 py-3 text-sm',
    lg: 'px-6 py-4 text-base',
  };

  return (
    <button
      className={`${variants[variant]} ${sizes[size]} flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:transform-none ${className}`}
      disabled={disabled || isLoading}
      {...props}
    >
      {isLoading ? (
        <div className="w-5 h-5 border-2 border-current border-t-transparent rounded-full animate-spin" />
      ) : (
        <>
          {icon}
          {children}
        </>
      )}
    </button>
  );
}

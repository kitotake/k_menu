import type { ButtonHTMLAttributes, ReactNode } from 'react'
import styles from './Button.scss?inline'

export type ButtonVariant = 'primary' | 'secondary' | 'ghost' | 'danger' | 'success'
export type ButtonSize    = 'sm' | 'md' | 'lg'

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?:  ButtonVariant
  size?:     ButtonSize
  leftIcon?: ReactNode
  rightIcon?: ReactNode
  loading?:  boolean
  fullWidth?: boolean
  children:  ReactNode
}

export function Button({
  variant   = 'primary',
  size      = 'md',
  leftIcon,
  rightIcon,
  loading   = false,
  fullWidth = false,
  disabled,
  children,
  className = '',
  ...rest
}: ButtonProps) {
  const cls = [
    'k-btn',
    `k-btn--${variant}`,
    `k-btn--${size}`,
    loading   ? 'k-btn--loading'    : '',
    fullWidth ? 'k-btn--full-width' : '',
    className,
  ].filter(Boolean).join(' ')

  return (
    <button
      className={cls}
      disabled={disabled || loading}
      aria-busy={loading}
      {...rest}
    >
      {loading && <span className="k-btn__spinner" aria-hidden="true" />}
      {!loading && leftIcon && <span className="k-btn__icon k-btn__icon--left">{leftIcon}</span>}
      <span className="k-btn__label">{children}</span>
      {!loading && rightIcon && <span className="k-btn__icon k-btn__icon--right">{rightIcon}</span>}
    </button>
  )
}

// Suppress unused import warning — styles are injected via ?inline
void styles
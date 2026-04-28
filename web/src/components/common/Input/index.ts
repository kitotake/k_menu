import type { InputHTMLAttributes, ReactNode } from 'react'

export interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?:     string
  hint?:      string
  error?:     string
  leftIcon?:  ReactNode
  rightIcon?: ReactNode
  fullWidth?: boolean
}

export function Input({
  label,
  hint,
  error,
  leftIcon,
  rightIcon,
  fullWidth = false,
  className = '',
  id,
  ...rest
}: InputProps) {
  const inputId = id ?? `k-input-${Math.random().toString(36).slice(2, 7)}`
  const cls = [
    'k-input__field',
    leftIcon  ? 'k-input__field--left-icon'  : '',
    rightIcon ? 'k-input__field--right-icon' : '',
    error     ? 'k-input__field--error'      : '',
  ].filter(Boolean).join(' ')

  return (
    <div className={['k-input', fullWidth ? 'k-input--full' : '', className].filter(Boolean).join(' ')}>
      {label && <label className="k-input__label" htmlFor={inputId}>{label}</label>}
      <div className="k-input__wrapper">
        {leftIcon  && <span className="k-input__icon k-input__icon--left">{leftIcon}</span>}
        <input id={inputId} className={cls} aria-invalid={!!error} aria-describedby={error ? `${inputId}-err` : undefined} {...rest} />
        {rightIcon && <span className="k-input__icon k-input__icon--right">{rightIcon}</span>}
      </div>
      {error && <span id={`${inputId}-err`} className="k-input__error" role="alert">{error}</span>}
      {!error && hint && <span className="k-input__hint">{hint}</span>}
    </div>
  )
}
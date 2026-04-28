import type { ReactNode, HTMLAttributes } from 'react'
import './Card.scss'

export interface CardProps extends HTMLAttributes<HTMLDivElement> {
  children: ReactNode
  variant?: 'default' | 'elevated' | 'outlined' | 'ghost'
  padding?: 'none' | 'sm' | 'md' | 'lg'
  glow?: boolean
}

export function Card({
  children,
  variant  = 'default',
  padding  = 'md',
  glow     = false,
  className = '',
  ...rest
}: CardProps) {
  const cls = [
    'k-card',
    `k-card--${variant}`,
    `k-card--pad-${padding}`,
    glow ? 'k-card--glow' : '',
    className,
  ].filter(Boolean).join(' ')

  return <div className={cls} {...rest}>{children}</div>
}
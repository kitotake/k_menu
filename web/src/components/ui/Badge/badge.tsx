import type { ReactNode } from 'react'

export type BadgeVariant = 'default' | 'accent' | 'success' | 'danger' | 'warning' | 'ghost'

export interface BadgeProps {
  children: ReactNode
  variant?: BadgeVariant
  dot?:     boolean
  size?:    'sm' | 'md'
}

const colors: Record<BadgeVariant, { bg: string; color: string; border: string }> = {
  default: { bg: 'rgba(255,255,255,0.06)', color: '#7a7f99', border: 'rgba(255,255,255,0.06)' },
  accent:  { bg: 'rgba(130,100,255,0.15)', color: '#a891ff', border: 'rgba(130,100,255,0.3)'  },
  success: { bg: 'rgba(77,255,184,0.12)',  color: '#4dffb8', border: 'rgba(77,255,184,0.3)'   },
  danger:  { bg: 'rgba(255,77,106,0.12)',  color: '#ff4d6a', border: 'rgba(255,77,106,0.3)'   },
  warning: { bg: 'rgba(255,210,77,0.12)',  color: '#ffd24d', border: 'rgba(255,210,77,0.3)'   },
  ghost:   { bg: 'transparent',            color: '#4a4f66', border: 'rgba(255,255,255,0.04)' },
}

export function Badge({ children, variant = 'default', dot = false, size = 'md' }: BadgeProps) {
  const c        = colors[variant]
  const fontSize = size === 'sm' ? 9 : 11
  const padding  = size === 'sm' ? '1px 5px' : '2px 7px'

  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 4,
      fontSize, fontWeight: 600, letterSpacing: '0.07em',
      textTransform: 'uppercase', padding,
      background: c.bg, color: c.color,
      border: `1px solid ${c.border}`, borderRadius: 4,
      whiteSpace: 'nowrap',
    }}>
      {dot && <span style={{ width: 5, height: 5, borderRadius: '50%', background: c.color, flexShrink: 0 }} />}
      {children}
    </span>
  )
}
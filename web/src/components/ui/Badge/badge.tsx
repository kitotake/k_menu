import type { ReactNode } from 'react'

export type BadgeVariant = 'default' | 'accent' | 'success' | 'danger' | 'warning' | 'ghost'

export interface BadgeProps {
  children: ReactNode
  variant?: BadgeVariant
  dot?: boolean
  size?: 'sm' | 'md'
}

const colors: Record<BadgeVariant, { bg: string; color: string; border: string }> = {
  default: { bg: 'rgba(255,255,255,0.06)', color: '#6a88aa',  border: 'rgba(255,255,255,0.06)' },
  accent:  { bg: 'rgba(59,158,255,0.12)',  color: '#7cc4ff',  border: 'rgba(59,158,255,0.3)'   },
  success: { bg: 'rgba(61,255,200,0.10)',  color: '#3dffc8',  border: 'rgba(61,255,200,0.3)'   },
  danger:  { bg: 'rgba(255,77,106,0.10)',  color: '#ff4d6a',  border: 'rgba(255,77,106,0.3)'   },
  warning: { bg: 'rgba(255,184,77,0.10)',  color: '#ffb84d',  border: 'rgba(255,184,77,0.3)'   },
  ghost:   { bg: 'transparent',            color: '#2e4058',  border: 'rgba(255,255,255,0.04)' },
}

export function Badge({
  children,
  variant = 'default',
  dot = false,
  size = 'md',
}: BadgeProps) {
  const c = colors[variant]
  return (
    <span
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: 4,
        fontSize: size === 'sm' ? 9 : 11,
        fontWeight: 600,
        letterSpacing: '0.07em',
        textTransform: 'uppercase',
        padding: size === 'sm' ? '1px 5px' : '2px 7px',
        background: c.bg,
        color: c.color,
        border: `1px solid ${c.border}`,
        borderRadius: 2,
        whiteSpace: 'nowrap',
        fontFamily: "'Share Tech Mono', monospace",
      }}
    >
      {dot && (
        <span
          style={{
            width: 5,
            height: 5,
            borderRadius: '50%',
            background: c.color,
            flexShrink: 0,
          }}
        />
      )}
      {children}
    </span>
  )
}

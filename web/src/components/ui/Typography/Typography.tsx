import type { ReactNode, ElementType, CSSProperties } from 'react'

export type TypographyVariant =
  | 'h1' | 'h2' | 'h3' | 'h4'
  | 'body' | 'body-sm'
  | 'caption' | 'label' | 'mono' | 'overline'

export interface TypographyProps {
  variant?: TypographyVariant
  as?: ElementType
  children: ReactNode
  color?: 'primary' | 'secondary' | 'muted' | 'accent' | 'danger' | 'success' | 'warning'
  className?: string
  truncate?: boolean
}

const variantStyles: Record<TypographyVariant, CSSProperties> = {
  h1:        { fontSize: 28, fontWeight: 700, letterSpacing: '0.06em', lineHeight: 1.1, textTransform: 'uppercase' },
  h2:        { fontSize: 20, fontWeight: 700, letterSpacing: '0.04em', lineHeight: 1.15 },
  h3:        { fontSize: 16, fontWeight: 600, letterSpacing: '0.02em', lineHeight: 1.2 },
  h4:        { fontSize: 13, fontWeight: 600, letterSpacing: '0.04em', lineHeight: 1.3 },
  body:      { fontSize: 14, fontWeight: 400, letterSpacing: '0.01em', lineHeight: 1.5 },
  'body-sm': { fontSize: 12, fontWeight: 400, letterSpacing: '0.01em', lineHeight: 1.5 },
  caption:   { fontSize: 11, fontWeight: 400, letterSpacing: '0.02em', lineHeight: 1.4 },
  label:     { fontSize: 10, fontWeight: 600, letterSpacing: '0.12em', lineHeight: 1, textTransform: 'uppercase' },
  mono:      { fontSize: 12, fontWeight: 400, fontFamily: "'Share Tech Mono', monospace", letterSpacing: '0.04em' },
  overline:  { fontSize: 9,  fontWeight: 700, letterSpacing: '0.16em', lineHeight: 1, textTransform: 'uppercase' },
}

const colorMap: Record<string, string> = {
  primary: '#e8f4ff', secondary: '#6a88aa', muted: '#2e4058',
  accent: '#7cc4ff', danger: '#ff4d6a', success: '#3dffc8', warning: '#ffb84d',
}

const defaultTag: Partial<Record<TypographyVariant, ElementType>> = {
  h1: 'h1', h2: 'h2', h3: 'h3', h4: 'h4',
}

export function Typography({
  variant = 'body',
  as,
  children,
  color = 'primary',
  className = '',
  truncate = false,
}: TypographyProps) {
  const Tag = as ?? defaultTag[variant] ?? 'p'
  return (
    <Tag
      className={className}
      style={{
        margin: 0,
        ...variantStyles[variant],
        color: colorMap[color] ?? color,
        ...(truncate && { overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }),
      }}
    >
      {children}
    </Tag>
  )
}

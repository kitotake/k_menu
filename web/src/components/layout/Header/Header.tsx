import type { ReactNode } from 'react'

export interface HeaderProps { children?: ReactNode; title?: string }

export function Header({ children, title }: HeaderProps) {
  return (
    <header style={{
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      padding: '12px 20px', borderBottom: '1px solid rgba(255,255,255,0.06)',
      background: '#111318', flexShrink: 0,
    }}>
      {title && (
        <span style={{
          fontSize: 14, fontWeight: 700, letterSpacing: '0.06em',
          textTransform: 'uppercase', color: '#e8eaf0',
        }}>
          {title}
        </span>
      )}
      {children}
    </header>
  )
}
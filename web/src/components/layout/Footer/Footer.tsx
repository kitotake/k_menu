import type { ReactNode } from 'react'

export interface FooterProps { children?: ReactNode }

export function Footer({ children }: FooterProps) {
  return (
    <footer style={{
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      padding: '8px 16px', borderTop: '1px solid rgba(255,255,255,0.06)',
      background: '#111318', flexShrink: 0,
      fontSize: 11, color: '#4a4f66', letterSpacing: '0.04em',
    }}>
      {children ?? 'k_Menu • FiveM'}
    </footer>
  )
}
import type { ReactNode } from 'react'

export interface SidebarProps {
  children:  ReactNode
  width?:    number
  position?: 'left' | 'right'
}

export function Sidebar({ children, width = 220, position = 'left' }: SidebarProps) {
  const borderKey = position === 'left' ? 'borderRight' : 'borderLeft'
  return (
    <aside style={{
      width, flexShrink: 0,
      display: 'flex', flexDirection: 'column',
      background: '#111318',
      [borderKey]: '1px solid rgba(255,255,255,0.06)',
      overflowY: 'auto', overflowX: 'hidden',
    }}>
      {children}
    </aside>
  )
}
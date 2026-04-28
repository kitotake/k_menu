import type { ReactNode } from 'react'

export interface NavbarItem { label: string; icon?: string; active?: boolean; onClick?: () => void }
export interface NavbarProps { items: NavbarItem[]; children?: ReactNode }

export function Navbar({ items, children }: NavbarProps) {
  return (
    <nav style={{
      display: 'flex', alignItems: 'center', gap: 2,
      padding: '0 12px', background: '#111318',
      borderBottom: '1px solid rgba(255,255,255,0.06)',
      height: 44, flexShrink: 0,
    }}>
      {items.map((item) => (
        <button
          key={item.label}
          onClick={item.onClick}
          style={{
            display: 'flex', alignItems: 'center', gap: 6,
            padding: '6px 12px', borderRadius: 6,
            background: item.active ? 'rgba(130,100,255,0.12)' : 'transparent',
            border: 'none',
            color: item.active ? '#a891ff' : '#7a7f99',
            fontSize: 12, fontWeight: 600, letterSpacing: '0.04em',
            cursor: 'pointer', transition: 'all 0.12s',
            textTransform: 'uppercase',
          }}
        >
          {item.icon && <span>{item.icon}</span>}
          {item.label}
        </button>
      ))}
      {children}
    </nav>
  )
}
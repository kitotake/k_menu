import { useState, useRef, type ReactNode } from 'react'

export interface TooltipProps {
  content:   ReactNode
  children:  ReactNode
  position?: 'top' | 'bottom' | 'left' | 'right'
  delay?:    number
}

export function Tooltip({ content, children, position = 'top', delay = 300 }: TooltipProps) {
  const [visible, setVisible] = useState(false)
  const timer = useRef<ReturnType<typeof setTimeout>>()

  const show = () => { timer.current = setTimeout(() => setVisible(true), delay) }
  const hide = () => { clearTimeout(timer.current); setVisible(false) }

  const offsets: Record<string, React.CSSProperties> = {
    top:    { bottom: 'calc(100% + 6px)', left: '50%', transform: 'translateX(-50%)' },
    bottom: { top:    'calc(100% + 6px)', left: '50%', transform: 'translateX(-50%)' },
    left:   { right:  'calc(100% + 6px)', top:  '50%', transform: 'translateY(-50%)' },
    right:  { left:   'calc(100% + 6px)', top:  '50%', transform: 'translateY(-50%)' },
  }

  return (
    <span style={{ position: 'relative', display: 'inline-flex' }} onMouseEnter={show} onMouseLeave={hide}>
      {children}
      {visible && (
        <span style={{
          position: 'absolute', zIndex: 9999, pointerEvents: 'none',
          ...offsets[position],
          background: '#1a1d27', border: '1px solid rgba(255,255,255,0.08)',
          borderRadius: 5, padding: '5px 9px', fontSize: 11, color: '#e8eaf0',
          whiteSpace: 'nowrap', boxShadow: '0 4px 16px rgba(0,0,0,0.5)',
          animation: 'fadeIn 0.12s ease',
        }}>
          {content}
        </span>
      )}
    </span>
  )
}
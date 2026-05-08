import { useState, useRef, useEffect, type ReactNode } from 'react'

export interface TooltipProps {
  content: ReactNode
  children: ReactNode
  position?: 'top' | 'bottom' | 'left' | 'right'
  delay?: number
}

export function Tooltip({ content, children, position = 'top', delay = 300 }: TooltipProps) {
  const [visible, setVisible] = useState(false)
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null)

  const show = () => {
    if (timer.current) clearTimeout(timer.current)
    timer.current = setTimeout(() => setVisible(true), delay)
  }

  const hide = () => {
    if (timer.current) { clearTimeout(timer.current); timer.current = null }
    setVisible(false)
  }

  useEffect(() => () => { if (timer.current) clearTimeout(timer.current) }, [])

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
          background: '#0a0c14',
          border: '1px solid rgba(59,158,255,0.2)',
          borderRadius: 2,
          padding: '5px 9px',
          fontSize: 10,
          color: '#e8f4ff',
          whiteSpace: 'nowrap',
          boxShadow: '0 4px 16px rgba(0,0,0,0.6)',
          fontFamily: "'Share Tech Mono', monospace",
          letterSpacing: '0.04em',
        }}>
          {content}
        </span>
      )}
    </span>
  )
}

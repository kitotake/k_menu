import { useEffect, type ReactNode } from 'react'
import { createPortal } from 'react-dom'

export interface ModalProps {
  open:     boolean
  onClose:  () => void
  title?:   string
  children: ReactNode
  size?:    'sm' | 'md' | 'lg'
}

export function Modal({ open, onClose, title, children, size = 'md' }: ModalProps) {
  useEffect(() => {
    if (!open) return
    const handler = (e: KeyboardEvent) => { if (e.key === 'Escape') onClose() }
    window.addEventListener('keydown', handler)
    return () => window.removeEventListener('keydown', handler)
  }, [open, onClose])

  if (!open) return null

  const widths: Record<string, number> = { sm: 320, md: 480, lg: 640 }

  return createPortal(
    <div
      className="k-modal-overlay"
      onClick={e => { if (e.target === e.currentTarget) onClose() }}
      role="dialog"
      aria-modal
      aria-label={title}
    >
      <div className="k-modal" style={{ maxWidth: widths[size] }}>
        {title && (
          <div className="k-modal__header">
            <h2 className="k-modal__title">{title}</h2>
            <button className="k-modal__close" onClick={onClose} aria-label="Fermer">✕</button>
          </div>
        )}
        <div className="k-modal__body">{children}</div>
      </div>
    </div>,
    document.body
  )
}
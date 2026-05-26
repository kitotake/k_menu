// App.tsx
import { useState, useCallback } from 'react'
import type { MenuData, NUIMessage } from './types'
import { useNUI } from './hooks/useNUI'
import { Menu } from './components/Menu'
import s from './App.module.scss'

export default function App() {
  const [stack, setStack] = useState<MenuData[]>([])

  useNUI<NUIMessage>(msg => {
    if (!msg?.action) return

    if (msg.action === 'open') {
      const m: MenuData = {
        id:       msg.id    ?? `m_${Date.now()}`,
        title:    msg.title ?? 'Menu',
        subtitle: msg.subtitle,
        items:    msg.items ?? [],
      }
      setStack(prev => {
        const idx = prev.findIndex(x => x.id === m.id)
        if (idx !== -1) {
          const next = [...prev]
          next[idx] = m
          return next
        }
        return [...prev, m]
      })
    }

    if (msg.action === 'close') {
      setStack([])
    }
  })

  const close = useCallback(() => setStack([]), [])

  const back = useCallback(() => {
    setStack(prev => prev.length <= 1 ? [] : prev.slice(0, -1))
  }, [])

  const active = stack[stack.length - 1] ?? null

  if (!active) return null

  return (
    <div className={s.root}>
      <Menu
        key={active.id}
        menu={active}
        isRoot={stack.length === 1}
        onClose={close}
        onBack={back}
      />
    </div>
  )
}

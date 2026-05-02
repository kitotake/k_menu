import { useState, useCallback } from 'react'
import type { MenuData, NUIMessage } from './types'
import { useNUIMessage } from './hooks/useNUIMessage'
import { sendNUICallback } from './utils/nui'
import { Menu } from './components/Menu/Menu'
import styles from './App.module.scss'

export default function App() {
  const [menus, setMenus] = useState<MenuData[]>([])

  const handleMessage = useCallback((msg: NUIMessage) => {
    switch (msg.action) {

      case 'openMenu': {
        const newMenu: MenuData = {
          id:       msg.menuId  ?? 'menu_' + Date.now(),
          title:    msg.title   ?? 'Menu',
          subtitle: msg.subtitle,
          banner:   msg.banner,
          items:    msg.items   ?? [],
        }
        setMenus(prev => {
          const exists = prev.findIndex(m => m.id === newMenu.id)
          if (exists !== -1) {
            const updated = [...prev]
            updated[exists] = newMenu
            return updated
          }
          return [...prev, newMenu]
        })
        break
      }

      case 'setItems': {
        setMenus(prev =>
          prev.map(m =>
            m.id === msg.menuId
              ? { ...m, items: msg.items ?? m.items }
              : m
          )
        )
        break
      }

      case 'closeMenu': {
        if (msg.menuId) {
          setMenus(prev => {
            const idx = prev.findIndex(m => m.id === msg.menuId)
            if (idx === -1) return prev
            return prev.slice(0, idx)
          })
        } else {
          setMenus([])
        }
        break
      }

      // FIX: 'goBack' géré côté React sans appel NUI supplémentaire
      // (ce cas arrive quand le Lua confirme le retour arrière)
      case 'goBack': {
        setMenus(prev => {
          if (prev.length <= 1) return []
          return prev.slice(0, -1)
        })
        break
      }

      default:
        break
    }
  }, [])

  useNUIMessage(handleMessage)

  const handleClose = useCallback((menuId: string) => {
    setMenus(prev => {
      const idx = prev.findIndex(m => m.id === menuId)
      if (idx === -1) return prev
      return prev.slice(0, idx)
    })
  }, [])

  const handleBack = useCallback((menuId: string) => {
    setMenus(prev => {
      const idx = prev.findIndex(m => m.id === menuId)
      if (idx === -1) return prev
      if (idx === 0) {
        sendNUICallback('closeMenu', { menuId })
        return []
      }
      sendNUICallback('goBack', { menuId })
      return prev.slice(0, idx)
    })
  }, [])

  const activeMenu = menus[menus.length - 1] ?? null

  return (
    <div className={styles.root}>
      {activeMenu && (
        <div className={styles.overlay}>
          <div className={styles.menuWrapper}>
            <Menu
              key={activeMenu.id}
              menu={activeMenu}
              onClose={() => handleClose(activeMenu.id)}
              onBack={() => handleBack(activeMenu.id)}
              isRoot={menus.length === 1}
            />
          </div>
        </div>
      )}
    </div>
  )
}
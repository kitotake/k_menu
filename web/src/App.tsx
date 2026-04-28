import { useState, useCallback } from 'react'
import type { MenuData, Notification, NUIMessage } from './types'
import { useNUIMessage } from './hooks/useNUIMessage'
import { Menu } from './components/Menu'
import { Notifications } from './components/Notifications'
import styles from './App.module.scss'

let notifCounter = 0

export default function App() {
  const [menus, setMenus] = useState<MenuData[]>([])
  const [notifications, setNotifications] = useState<Notification[]>([])

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
          // Replace if same id, otherwise stack (submenu)
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
          setMenus(prev => prev.filter(m => m.id !== msg.menuId))
        } else {
          setMenus([])
        }
        break
      }

      case 'notify': {
        const notif: Notification = {
          id:       `notif_${++notifCounter}`,
          type:     msg.type      ?? 'info',
          message:  msg.message   ?? '',
          duration: msg.duration  ?? 4000,
        }
        setNotifications(prev => [...prev, notif])
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
      // Close this menu and all on top of it (submenu stack)
      return prev.slice(0, idx)
    })
  }, [])

  const removeNotif = useCallback((id: string) => {
    setNotifications(prev => prev.filter(n => n.id !== id))
  }, [])

  // Top menu in the stack
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
            />
          </div>
        </div>
      )}
      <Notifications
        notifications={notifications}
        onRemove={removeNotif}
      />
    </div>
  )
}

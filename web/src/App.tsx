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
          // Si le menu existe déjà dans le stack, on le met à jour sur place
          const exists = prev.findIndex(m => m.id === newMenu.id)
          if (exists !== -1) {
            const updated = [...prev]
            updated[exists] = newMenu
            return updated
          }
          // Sinon on empile
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
          // Ferme un menu spécifique et tout ce qui est au-dessus dans le stack
          setMenus(prev => {
            const idx = prev.findIndex(m => m.id === msg.menuId)
            if (idx === -1) return prev
            return prev.slice(0, idx)
          })
        } else {
          // Ferme tout
          setMenus([])
        }
        break
      }

      default:
        break
    }
  }, [])

  useNUIMessage(handleMessage)

  // Appelé quand Échap est pressé dans le menu actif
  const handleClose = useCallback((menuId: string) => {
    setMenus(prev => {
      const idx = prev.findIndex(m => m.id === menuId)
      if (idx === -1) return prev
      // Retire ce menu et tout ce qui est au-dessus
      return prev.slice(0, idx)
    })
  }, [])

  // Appelé quand Backspace est pressé → retour d'un niveau
  const handleBack = useCallback((menuId: string) => {
    setMenus(prev => {
      const idx = prev.findIndex(m => m.id === menuId)
      if (idx === -1) return prev
      if (idx === 0) {
        // Dernier menu → ferme tout + notifie Lua
        sendNUICallback('closeMenu', { menuId })
        return []
      }
      // Sinon retire juste le menu actif (revient au précédent)
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
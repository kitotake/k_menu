import { useState, useCallback, useEffect } from 'react'
import type { MenuData, MenuItem } from '../types'
import { sendNUICallback } from '../utils/nui'
import { useKeyPress } from '../hooks/useKeyPress'
import { MenuHeader } from './MenuHeader'
import { MenuItemComponent } from './MenuItem'
import { MenuFooter } from './MenuFooter'
import styles from './Menu.module.scss'

interface MenuProps {
  menu: MenuData
  onClose: () => void
}

/** Returns indices of items that can be navigated to */
function getNavigableIndices(items: MenuItem[]): number[] {
  return items
    .map((item, i) => ({ item, i }))
    .filter(({ item }) => item.type !== 'separator' && item.type !== 'title' && !item.disabled)
    .map(({ i }) => i)
}

export function Menu({ menu, onClose }: MenuProps) {
  const navigable = getNavigableIndices(menu.items)
  const [navIndex, setNavIndex] = useState(0) // index within navigable array

  const selectedItemIndex = navigable[navIndex] ?? -1

  // Reset selection when items change
  useEffect(() => {
    setNavIndex(0)
  }, [menu.id])

  const moveUp = useCallback(() => {
    setNavIndex(i => Math.max(0, i - 1))
  }, [])

  const moveDown = useCallback(() => {
    setNavIndex(i => Math.min(navigable.length - 1, i + 1))
  }, [navigable.length])

  const activate = useCallback((item: MenuItem) => {
    if (item.type === 'button') {
      sendNUICallback('buttonClick', { menuId: menu.id, id: item.id })
    } else if (item.type === 'submenu') {
      sendNUICallback('openSubmenu', { menuId: menu.id, submenuId: item.submenuId, id: item.id })
    }
  }, [menu.id])

  const handleEnter = useCallback(() => {
    const item = menu.items[selectedItemIndex]
    if (item && item.type !== 'separator' && item.type !== 'title') {
      activate(item)
    }
  }, [menu.items, selectedItemIndex, activate])

  const handleEscape = useCallback(() => {
    sendNUICallback('closeMenu', { menuId: menu.id })
    onClose()
  }, [menu.id, onClose])

  // Keyboard bindings
  useKeyPress('ArrowUp',  moveUp,    [])
  useKeyPress('ArrowDown', moveDown,  [])
  useKeyPress('Enter',    handleEnter, [handleEnter])
  useKeyPress('Escape',   handleEscape, [handleEscape])
  useKeyPress('Backspace', handleEscape, [handleEscape])

  // Count only navigable items for the counter display
  const navigableSelected = navigable.indexOf(selectedItemIndex)

  return (
    <div className={styles.menu} role="listbox" aria-label={menu.title}>
      <MenuHeader
        title={menu.title}
        subtitle={menu.subtitle}
        banner={menu.banner}
        itemCount={navigable.length}
        selectedIndex={Math.max(0, navigableSelected)}
      />

      <div className={styles.itemList}>
        {menu.items.map((item, index) => (
          <MenuItemComponent
            key={item.id}
            item={item}
            isSelected={index === selectedItemIndex}
            index={index}
            onHover={(hoveredIndex) => {
              const ni = navigable.indexOf(hoveredIndex)
              if (ni !== -1) setNavIndex(ni)
            }}
            onActivate={activate}
          />
        ))}
      </div>

      <MenuFooter />
    </div>
  )
}

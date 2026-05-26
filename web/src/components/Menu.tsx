// components/Menu.tsx
import { useState, useEffect, useCallback, useRef } from 'react'
import type { MenuData, MenuItem, ButtonItem, InputItem, ToggleItem, SubmenuItem } from '../types'
import { nuiCallback } from '../utils/nui'
import { useKey } from '../hooks/useKey'
import s from './Menu.module.scss'

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

function navigable(items: MenuItem[]) {
  return items
    .map((item, i) => ({ item, i }))
    .filter(({ item }) => item.type !== 'separator' && !item.disabled)
    .map(({ i }) => i)
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu Item
// ─────────────────────────────────────────────────────────────────────────────

interface ItemProps {
  item:       MenuItem
  selected:   boolean
  index:      number
  inputs:     Record<string, string>
  onHover:    (i: number) => void
  onActivate: (item: MenuItem) => void
  onInput:    (id: string, val: string) => void
  onToggle:   (item: ToggleItem, val: boolean) => void
}

function Item({ item, selected, index, inputs, onHover, onActivate, onInput, onToggle }: ItemProps) {
  const inputRef = useRef<HTMLInputElement>(null)

  // Focus auto sur l'input quand sélectionné
  useEffect(() => {
    if (selected && item.type === 'input' && inputRef.current) {
      inputRef.current.focus()
    }
  }, [selected, item.type])

  // Separator
  if (item.type === 'separator') {
    return (
      <div className={s.sep}>
        {item.label && <span>{item.label}</span>}
        <div className={s.sepLine} />
      </div>
    )
  }

  const colorCls = item.type === 'button'
    ? s[`c_${(item as ButtonItem).color ?? ''}`] ?? ''
    : ''

  const toggleVal = item.type === 'toggle'
    ? (inputs[item.id] !== undefined ? inputs[item.id] === 'true' : ((item as ToggleItem).value ?? false))
    : false

  const inputVal = item.type === 'input'
    ? (inputs[item.id] ?? (item as InputItem).value ?? '')
    : ''

  return (
    <div
      className={`${s.item} ${selected ? s.sel : ''} ${colorCls} ${item.disabled ? s.dis : ''}`}
      onMouseEnter={() => !item.disabled && onHover(index)}
      onClick={() => {
        if (item.disabled) return
        if (item.type === 'toggle') onToggle(item as ToggleItem, !toggleVal)
        else onActivate(item)
      }}
    >
      <span className={s.label}>{item.label}</span>

      <div className={s.right}>
        {item.type === 'submenu' && <span className={s.arrow}>›</span>}

        {item.type === 'button' && (item as ButtonItem).rightLabel && (
          <span className={s.badge}>{(item as ButtonItem).rightLabel}</span>
        )}

        {item.type === 'input' && (
          <input
            ref={inputRef}
            className={s.input}
            type={(item as InputItem).inputType ?? 'text'}
            placeholder={(item as InputItem).placeholder ?? ''}
            value={inputVal}
            min={(item as InputItem).min}
            max={(item as InputItem).max}
            onChange={e => onInput(item.id, e.target.value)}
            onKeyDown={e => {
              if (['ArrowUp', 'ArrowDown', 'Escape'].includes(e.key)) e.stopPropagation()
              if (e.key === 'Enter') {
                nuiCallback('input', { id: item.id, value: e.currentTarget.value })
              }
            }}
            onClick={e => e.stopPropagation()}
          />
        )}

        {item.type === 'toggle' && (
          <div
            className={`${s.toggle} ${toggleVal ? s.on : ''}`}
            onClick={e => { e.stopPropagation(); onToggle(item as ToggleItem, !toggleVal) }}
          />
        )}
      </div>
    </div>
  )
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu principal
// ─────────────────────────────────────────────────────────────────────────────

interface MenuProps {
  menu:    MenuData
  isRoot:  boolean
  onClose: () => void
  onBack:  () => void
}

export function Menu({ menu, isRoot, onClose, onBack }: MenuProps) {
  const nav    = navigable(menu.items)
  const [idx,  setIdx]    = useState(0)
  const [vals, setVals]   = useState<Record<string, string>>({})

  // Reset à chaque changement de menu
  useEffect(() => { setIdx(0) }, [menu.id])

  const selItemIdx = nav[idx] ?? -1

  const up   = useCallback(() => setIdx(i => Math.max(0, i - 1)), [])
  const down = useCallback(() => setIdx(i => Math.min(nav.length - 1, i + 1)), [nav.length])

  const activate = useCallback((item: MenuItem) => {
    switch (item.type) {
      case 'button':
        nuiCallback('button', { id: item.id, menuId: menu.id })
        break
      case 'submenu':
        nuiCallback('submenu', { submenuId: (item as SubmenuItem).submenuId, menuId: menu.id })
        break
    }
  }, [menu.id])

  const handleEnter = useCallback(() => {
    const item = menu.items[selItemIdx]
    if (!item || item.type === 'separator' || item.disabled) return
    if (item.type === 'toggle') {
      const cur = vals[item.id] !== undefined ? vals[item.id] === 'true' : ((item as ToggleItem).value ?? false)
      const next = !cur
      setVals(v => ({ ...v, [item.id]: String(next) }))
      nuiCallback('toggle', { id: item.id, value: next, menuId: menu.id })
    } else {
      activate(item)
    }
  }, [menu.items, selItemIdx, vals, activate, menu.id])

  const handleInput = useCallback((id: string, val: string) => {
    setVals(v => ({ ...v, [id]: val }))
    nuiCallback('input', { id, value: val })
  }, [])

  const handleToggle = useCallback((item: ToggleItem, val: boolean) => {
    setVals(v => ({ ...v, [item.id]: String(val) }))
    nuiCallback('toggle', { id: item.id, value: val, menuId: menu.id })
  }, [menu.id])

  const escape = useCallback(() => {
    if (isRoot) { nuiCallback('close', {}); onClose() }
    else        { onBack() }
  }, [isRoot, onClose, onBack])

  useKey('ArrowUp',   up)
  useKey('ArrowDown', down)
  useKey('Enter',     handleEnter)
  useKey('Escape',    escape)
  useKey('Backspace', onBack)

  return (
    <div className={s.menu}>
      {/* Header */}
      <div className={s.header}>
        <div className={s.title}>{menu.title}</div>
        {menu.subtitle && <div className={s.sub}>{menu.subtitle}</div>}
      </div>

      {/* Items */}
      <div className={s.list}>
        {menu.items.map((item, i) => (
          <Item
            key={item.id}
            item={item}
            selected={i === selItemIdx}
            index={i}
            inputs={vals}
            onHover={hovered => {
              const ni = nav.indexOf(hovered)
              if (ni !== -1) setIdx(ni)
            }}
            onActivate={activate}
            onInput={handleInput}
            onToggle={handleToggle}
          />
        ))}
      </div>

      {/* Footer */}
      <div className={s.footer}>
        <span>↑↓ nav</span>
        <span>↵ select</span>
        <span>{isRoot ? 'esc fermer' : '⌫ retour'}</span>
      </div>
    </div>
  )
}

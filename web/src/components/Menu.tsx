// components/Menu.tsx
import { useState, useEffect, useCallback, useRef } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import {
  faChevronRight, faArrowLeft, faXmark,
  faSliders, faListUl,
} from '@fortawesome/free-solid-svg-icons'
import type { MenuData, MenuItem, ButtonItem, InputItem, ToggleItem, SubmenuItem } from '../types'
import { nuiCallback } from '../utils/nui'
import { useKey } from '../hooks/useKey'
import { getIcon } from '../utils/icons'
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
// Item
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

  useEffect(() => {
    if (selected && item.type === 'input' && inputRef.current) {
      inputRef.current.focus()
    }
  }, [selected, item.type])

  // ── Separator
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
    ? (inputs[item.id] !== undefined
        ? inputs[item.id] === 'true'
        : ((item as ToggleItem).value ?? false))
    : false

  const inputVal = item.type === 'input'
    ? (inputs[item.id] ?? (item as InputItem).value ?? '')
    : ''

  const faIcon = getIcon(item.icon)

  return (
    <motion.div
      className={`${s.item} ${selected ? s.sel : ''} ${colorCls} ${item.disabled ? s.dis : ''}`}
      onMouseEnter={() => !item.disabled && onHover(index)}
      onClick={() => {
        if (item.disabled) return
        if (item.type === 'toggle') onToggle(item as ToggleItem, !toggleVal)
        else onActivate(item)
      }}
      initial={false}
      animate={{
        backgroundColor: selected ? undefined : 'transparent',
      }}
      whileTap={item.disabled ? {} : { scale: 0.98 }}
    >
      {/* Icon */}
      {faIcon && (
        <span className={s.iconWrap}>
          <FontAwesomeIcon icon={faIcon} />
        </span>
      )}

      {/* Label */}
      <span className={s.label}>{item.label}</span>

      {/* Right side */}
      <div className={s.right}>
        {item.type === 'submenu' && (
          <motion.span
            className={s.arrow}
            animate={{ x: selected ? 2 : 0 }}
            transition={{ duration: 0.15 }}
          >
            <FontAwesomeIcon icon={faChevronRight} />
          </motion.span>
        )}

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
          <motion.div
            className={`${s.toggle} ${toggleVal ? s.on : ''}`}
            onClick={e => { e.stopPropagation(); onToggle(item as ToggleItem, !toggleVal) }}
            whileTap={{ scale: 0.9 }}
          />
        )}
      </div>
    </motion.div>
  )
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu
// ─────────────────────────────────────────────────────────────────────────────

interface MenuProps {
  menu:    MenuData
  isRoot:  boolean
  onClose: () => void
  onBack:  () => void
}

export function Menu({ menu, isRoot, onClose, onBack }: MenuProps) {
  const nav   = navigable(menu.items)
  const [idx,  setIdx]  = useState(0)
  const [vals, setVals] = useState<Record<string, string>>({})

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
      const cur  = vals[item.id] !== undefined ? vals[item.id] === 'true' : ((item as ToggleItem).value ?? false)
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
    <motion.div
      className={s.menu}
      initial={{ opacity: 0, x: -12, scale: 0.97 }}
      animate={{ opacity: 1, x: 0,   scale: 1 }}
      exit={{    opacity: 0, x: -8,  scale: 0.97 }}
      transition={{ duration: 0.18, ease: [0.4, 0, 0.2, 1] }}
    >
      {/* Header */}
      <div className={s.header}>
        <div className={s.headerIcon}>
          <FontAwesomeIcon icon={faListUl} />
        </div>
        <div className={s.headerText}>
          <div className={s.title}>{menu.title}</div>
          {menu.subtitle && <div className={s.sub}>{menu.subtitle}</div>}
        </div>
        {!isRoot && (
          <motion.button
            className={s.backBtn}
            onClick={onBack}
            whileTap={{ scale: 0.9 }}
            title="Retour"
          >
            <FontAwesomeIcon icon={faArrowLeft} />
          </motion.button>
        )}
        {isRoot && (
          <motion.button
            className={s.closeBtn}
            onClick={() => { nuiCallback('close', {}); onClose() }}
            whileTap={{ scale: 0.9 }}
            title="Fermer"
          >
            <FontAwesomeIcon icon={faXmark} />
          </motion.button>
        )}
      </div>

      {/* Items */}
      <div className={s.list}>
        <AnimatePresence initial={false}>
          {menu.items.map((item, i) => (
            <motion.div
              key={item.id}
              initial={{ opacity: 0, x: -6 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.12, delay: i * 0.018 }}
            >
              <Item
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
            </motion.div>
          ))}
        </AnimatePresence>
      </div>

      {/* Footer */}
      <div className={s.footer}>
        <span>↑↓ nav</span>
        <span className={s.dot} />
        <span>↵ select</span>
        <span className={s.dot} />
        <span>{isRoot ? 'esc fermer' : '⌫ retour'}</span>
      </div>
    </motion.div>
  )
}

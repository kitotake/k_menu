import { useRef, useEffect, useState, useCallback } from 'react'
import type { MenuItem, InputItem, ButtonItem } from '../../types'
import { sendNUICallback } from '../../utils/nui'
import styles from './MenuItem.module.scss'

interface MenuItemProps {
  item: MenuItem
  isSelected: boolean
  index: number
  onHover: (index: number) => void
  onActivate: (item: MenuItem) => void
}

export function MenuItemComponent({ item, isSelected, index, onHover, onActivate }: MenuItemProps) {
  const ref = useRef<HTMLDivElement>(null)
  const [inputValue, setInputValue] = useState((item as InputItem).value ?? '')

  // Scroll into view when selected
  useEffect(() => {
    if (isSelected && ref.current) {
      ref.current.scrollIntoView({ block: 'nearest', behavior: 'smooth' })
    }
  }, [isSelected])

  const handleInputChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value
    setInputValue(val)
    sendNUICallback('inputChange', { id: item.id, value: val })
  }, [item.id])

  const handleInputKeyDown = useCallback((e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      sendNUICallback('inputConfirm', { id: item.id, value: inputValue })
    }
    // Stop arrow keys from bubbling to menu navigation when input is focused
    if (['ArrowUp', 'ArrowDown'].includes(e.key)) {
      e.stopPropagation()
    }
  }, [item.id, inputValue])

  // ── Separator ──────────────────────────────────────────────────────────────
  if (item.type === 'separator') {
    return (
      <div className={styles.separator} aria-hidden="true">
        {item.label && <span className={styles.separatorLabel}>{item.label}</span>}
        <div className={styles.separatorLine} />
      </div>
    )
  }

  // ── Title ──────────────────────────────────────────────────────────────────
  if (item.type === 'title') {
    return (
      <div className={styles.title} aria-label={item.label}>
        <span className={styles.titleDot} />
        <span className={styles.titleText}>{item.label}</span>
        <span className={styles.titleDot} />
      </div>
    )
  }

  // ── Interactive items (button / input / submenu) ────────────────────────────
  const colorClass = item.type === 'button'
    ? styles[`color_${(item as ButtonItem).color ?? 'default'}`]
    : ''

  const isDisabled = item.disabled

  return (
    <div
      ref={ref}
      role="option"
      aria-selected={isSelected}
      aria-disabled={isDisabled}
      tabIndex={isDisabled ? -1 : 0}
      className={[
        styles.item,
        isSelected ? styles.selected : '',
        isDisabled ? styles.disabled : '',
        colorClass,
      ].filter(Boolean).join(' ')}
      onMouseEnter={() => !isDisabled && onHover(index)}
      onClick={() => !isDisabled && onActivate(item)}
    >
      {/* Left icon */}
      {item.icon && (
        <span className={styles.icon} aria-hidden="true">{item.icon}</span>
      )}

      {/* Main content */}
      <div className={styles.content}>
        <span className={styles.label}>{item.label}</span>
        {item.description && (
          <span className={styles.description}>{item.description}</span>
        )}
      </div>

      {/* Right side */}
      <div className={styles.right}>
        {item.type === 'button' && (item as ButtonItem).rightLabel && (
          <span className={styles.rightLabel}>{(item as ButtonItem).rightLabel}</span>
        )}

        {item.type === 'submenu' && (
          <span className={styles.arrow}>›</span>
        )}

        {item.type === 'input' && isSelected && (
          <input
            className={styles.input}
            type={(item as InputItem).inputType ?? 'text'}
            placeholder={(item as InputItem).placeholder ?? ''}
            value={inputValue}
            min={(item as InputItem).min}
            max={(item as InputItem).max}
            autoFocus
            onChange={handleInputChange}
            onKeyDown={handleInputKeyDown}
            onClick={e => e.stopPropagation()}
          />
        )}
        {item.type === 'input' && !isSelected && (
          <span className={styles.inputPreview}>
            {inputValue || <span className={styles.inputPlaceholder}>{(item as InputItem).placeholder}</span>}
          </span>
        )}
      </div>

      {/* Selected indicator */}
      {isSelected && <div className={styles.selectedBar} />}
    </div>
  )
}

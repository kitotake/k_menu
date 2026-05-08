import { useRef, useEffect, useState, useCallback } from 'react'
import type { MenuItem, InputItem, ButtonItem, ToggleItem, SliderItem } from '../../types'
import { sendNUICallback } from '../../utils/nui'
import styles from './MenuItem.module.scss'

interface MenuItemProps {
  item: MenuItem
  isSelected: boolean
  index: number
  onHover: (index: number) => void
  onActivate: (item: MenuItem) => void
}

export function MenuItemComponent({
  item,
  isSelected,
  index,
  onHover,
  onActivate,
}: MenuItemProps) {
  const ref = useRef<HTMLDivElement>(null)

  // ── Input state ─────────────────────────────────────────────────────────────
  const [inputValue, setInputValue] = useState(
    item.type === 'input' ? ((item as InputItem).value ?? '') : ''
  )

  // Reset input value when item changes
  useEffect(() => {
    if (item.type === 'input') {
      setInputValue((item as InputItem).value ?? '')
    }
  }, [item.id, item.type])

  // ── Toggle state ─────────────────────────────────────────────────────────────
  const [toggleValue, setToggleValue] = useState(
    item.type === 'toggle' ? ((item as ToggleItem).value ?? false) : false
  )

  useEffect(() => {
    if (item.type === 'toggle') {
      setToggleValue((item as ToggleItem).value ?? false)
    }
  }, [item.id, item.type])

  // ── Slider state ─────────────────────────────────────────────────────────────
  const [sliderValue, setSliderValue] = useState(
    item.type === 'slider' ? ((item as SliderItem).value ?? 0) : 0
  )

  useEffect(() => {
    if (item.type === 'slider') {
      setSliderValue((item as SliderItem).value ?? 0)
    }
  }, [item.id, item.type])

  // ── Auto-scroll when selected ────────────────────────────────────────────────
  useEffect(() => {
    if (isSelected && ref.current) {
      ref.current.scrollIntoView({ block: 'nearest', behavior: 'smooth' })
    }
  }, [isSelected])

  // ── Input handlers ───────────────────────────────────────────────────────────
  const handleInputChange = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      const val = e.target.value
      setInputValue(val)
      sendNUICallback('inputChange', { id: item.id, value: val })
    },
    [item.id]
  )

  const handleInputKeyDown = useCallback(
    (e: React.KeyboardEvent<HTMLInputElement>) => {
      if (e.key === 'Enter') {
        sendNUICallback('inputConfirm', { id: item.id, value: inputValue })
      }
      // Prevent menu navigation while typing
      if (['ArrowUp', 'ArrowDown', 'Escape'].includes(e.key)) {
        e.stopPropagation()
      }
    },
    [item.id, inputValue]
  )

  // ── Toggle handler ───────────────────────────────────────────────────────────
  const handleToggle = useCallback(
    (e: React.MouseEvent) => {
      e.stopPropagation()
      const next = !toggleValue
      setToggleValue(next)
      sendNUICallback('inputChange', { id: item.id, value: next })
    },
    [item.id, toggleValue]
  )

  // ── Slider handler ───────────────────────────────────────────────────────────
  const handleSliderChange = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      const val = Number(e.target.value)
      setSliderValue(val)
      sendNUICallback('inputChange', { id: item.id, value: val })
    },
    [item.id]
  )

  // ════════════════════════════════════════════════════════════════════════════
  // Separator
  // ════════════════════════════════════════════════════════════════════════════
  if (item.type === 'separator') {
    return (
      <div className={styles.separator} aria-hidden="true">
        {item.label && <span className={styles.separatorLabel}>{item.label}</span>}
        <div className={styles.separatorLine} />
      </div>
    )
  }

  // ════════════════════════════════════════════════════════════════════════════
  // Title
  // ════════════════════════════════════════════════════════════════════════════
  if (item.type === 'title') {
    return (
      <div className={styles.titleItem}>
        <div className={styles.titleBar} />
        <span className={styles.titleText}>{item.label}</span>
        <div className={styles.titleLine} />
      </div>
    )
  }

  // ════════════════════════════════════════════════════════════════════════════
  // Interactive items
  // ════════════════════════════════════════════════════════════════════════════
  const colorClass =
    item.type === 'button'
      ? styles[`color_${(item as ButtonItem).color ?? 'default'}`] ?? ''
      : ''

  const isDisabled = item.disabled ?? false

  const handleClick = () => {
    if (isDisabled) return
    if (item.type === 'toggle') {
      handleToggle({ stopPropagation: () => {} } as React.MouseEvent)
    } else {
      onActivate(item)
    }
  }

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
      ]
        .filter(Boolean)
        .join(' ')}
      onMouseEnter={() => !isDisabled && onHover(index)}
      onClick={handleClick}
    >
      {/* Left icon */}
      {item.icon && (
        <span className={styles.icon} aria-hidden="true">
          {item.icon}
        </span>
      )}

      {/* Main content */}
      <div className={styles.content}>
        <span className={styles.label}>{item.label}</span>
        {item.description && (
          <span className={styles.description}>{item.description}</span>
        )}
      </div>

      {/* Right side — varies per type */}
      <div className={styles.right}>
        {/* Button: optional right label */}
        {item.type === 'button' && (item as ButtonItem).rightLabel && (
          <span className={styles.rightLabel}>
            {(item as ButtonItem).rightLabel}
          </span>
        )}

        {/* Submenu: arrow */}
        {item.type === 'submenu' && (
          <span className={styles.arrow}>►</span>
        )}

        {/* Input: text field when selected, preview when not */}
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
            onClick={(e) => e.stopPropagation()}
          />
        )}
        {item.type === 'input' && !isSelected && (
          <span className={styles.inputPreview}>
            {inputValue ? (
              inputValue
            ) : (
              <span className={styles.inputPlaceholder}>
                {(item as InputItem).placeholder ?? '—'}
              </span>
            )}
          </span>
        )}

        {/* Toggle */}
        {item.type === 'toggle' && (
          <div
            className={[
              styles.toggle,
              toggleValue ? styles.toggleOn : '',
              (item as ToggleItem).color === 'danger' ? styles.toggleDanger : '',
              (item as ToggleItem).color === 'success' ? styles.toggleSuccess : '',
            ]
              .filter(Boolean)
              .join(' ')}
            onClick={handleToggle}
            aria-checked={toggleValue}
            role="switch"
          />
        )}

        {/* Slider */}
        {item.type === 'slider' && (
          <div className={styles.sliderWrapper}>
            <input
              className={styles.slider}
              type="range"
              min={(item as SliderItem).min ?? 0}
              max={(item as SliderItem).max ?? 100}
              step={(item as SliderItem).step ?? 1}
              value={sliderValue}
              onChange={handleSliderChange}
              onClick={(e) => e.stopPropagation()}
            />
            <span className={styles.sliderValue}>{sliderValue}</span>
          </div>
        )}
      </div>

      {/* Selected indicator bar */}
      {isSelected && <div className={styles.selectedBar} />}
    </div>
  )
}

export type MenuItemType = 'button' | 'input' | 'title' | 'separator' | 'submenu'

export interface BaseMenuItem {
  id: string
  type: MenuItemType
  label?: string
  description?: string
  icon?: string
  disabled?: boolean
}

export interface ButtonItem extends BaseMenuItem {
  type: 'button'
  value?: string | number | boolean
  rightLabel?: string
  color?: 'default' | 'danger' | 'success' | 'warning'
}

export interface InputItem extends BaseMenuItem {
  type: 'input'
  placeholder?: string
  inputType?: 'text' | 'number' | 'password'
  value?: string
  min?: number
  max?: number
}

export interface TitleItem extends BaseMenuItem {
  type: 'title'
}

export interface SeparatorItem extends BaseMenuItem {
  type: 'separator'
}

export interface SubMenuItem extends BaseMenuItem {
  type: 'submenu'
  submenuId: string
}

export type MenuItem = ButtonItem | InputItem | TitleItem | SeparatorItem | SubMenuItem

export interface MenuData {
  id: string
  title: string
  subtitle?: string
  banner?: string
  items: MenuItem[]
}

export interface NUIMessage {
  action: 'openMenu' | 'closeMenu' | 'setItems' | 'updateItem'
  menuId?: string
  title?: string
  subtitle?: string
  banner?: string
  items?: MenuItem[]
  item?: MenuItem
  visible?: boolean
}
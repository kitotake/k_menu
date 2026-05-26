// types/index.ts

export type ItemType =
  | 'button'
  | 'input'
  | 'toggle'
  | 'separator'
  | 'submenu'

export interface BaseItem {
  id:          string
  type:        ItemType
  label?:      string
  icon?:       string
  disabled?:   boolean
  description?: string
}

export interface ButtonItem extends BaseItem {
  type:       'button'
  color?:     'danger' | 'success' | 'warning'
  rightLabel?: string
}

export interface InputItem extends BaseItem {
  type:        'input'
  placeholder?: string
  inputType?:  'text' | 'number' | 'password'
  value?:      string
  min?:        number
  max?:        number
}

export interface ToggleItem extends BaseItem {
  type:  'toggle'
  value?: boolean
}

export interface SeparatorItem extends BaseItem {
  type:  'separator'
}

export interface SubmenuItem extends BaseItem {
  type:      'submenu'
  submenuId: string
}

export type MenuItem =
  | ButtonItem
  | InputItem
  | ToggleItem
  | SeparatorItem
  | SubmenuItem

export interface MenuData {
  id:       string
  title:    string
  subtitle?: string
  items:    MenuItem[]
}

export interface NUIMessage {
  action:   'open' | 'close'
  id?:      string
  title?:   string
  subtitle?: string
  items?:   MenuItem[]
}

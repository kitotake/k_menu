/**
 * Dev helper — fire fake NUI messages from the browser console
 * Usage: already imported in main.tsx during dev (import.meta.env.DEV)
 */
import type { NUIMessage } from './types'

function dispatch(msg: NUIMessage) {
  window.dispatchEvent(new MessageEvent('message', { data: msg }))
}

const w = window as unknown as Record<string, unknown>

w.__kMenu = {
  openDemo() {
    dispatch({
      action: 'openMenu',
      menuId: 'demo_main',
      title: 'K_MENU DEMO',
      subtitle: 'SYS://navigation_v2',
      items: [
        { id: 't1', type: 'title', label: 'Actions véhicule' },
        { id: '1',  type: 'button', label: 'Réparer véhicule',   icon: '🔧', description: 'Répare votre véhicule actuel', rightLabel: 'GRATUIT' },
        { id: '2',  type: 'button', label: 'Laver véhicule',     icon: '🚿', rightLabel: '250$' },
        { id: 'sep1', type: 'separator', label: 'Gestion' },
        { id: '3',  type: 'button', label: "Inventaire",         icon: '🎒' },
        { id: '4',  type: 'input',  label: 'Montant', icon: '💰', placeholder: '0', inputType: 'number', min: 0, max: 10000 },
        { id: 't2', type: 'title', label: 'Options' },
        { id: '5',  type: 'toggle', label: 'God Mode',           icon: '🛡️', value: false },
        { id: '6',  type: 'toggle', label: 'Invisible',          icon: '👻', value: true,  color: 'success' },
        { id: '7',  type: 'slider', label: 'Volume',             icon: '🔊', value: 60, min: 0, max: 100, step: 5 },
        { id: 'sep2', type: 'separator' },
        { id: '8',  type: 'submenu', label: "Plus d'options",    icon: '⚙️', submenuId: 'sub_options' },
        { id: '9',  type: 'button', label: 'Action dangereuse',  icon: '⚠️', color: 'danger', description: 'Irréversible' },
        { id: '10', type: 'button', label: 'Désactivé',          disabled: true },
      ],
    })
  },

  openSubmenu() {
    dispatch({
      action: 'openMenu',
      menuId: 'sub_options',
      title: 'OPTIONS',
      subtitle: 'SYS://sub_menu',
      items: [
        { id: 'so1', type: 'button', label: 'Option A', color: 'success' },
        { id: 'so2', type: 'button', label: 'Option B', color: 'warning' },
        { id: 'so3', type: 'button', label: 'Retour',   icon: '◄' },
      ],
    })
  },

  close() {
    dispatch({ action: 'closeMenu' })
  },

  goBack() {
    dispatch({ action: 'goBack' })
  },
}

console.info(
  '%c[k_Menu dev]%c Appelle %cwindow.__kMenu.openDemo()%c pour tester.',
  'color:#3b9eff;font-weight:bold',
  'color:inherit',
  'color:#7cc4ff;font-family:monospace',
  'color:inherit'
)

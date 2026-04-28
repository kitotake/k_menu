/**
 * Dev helper – fire fake NUI messages from the browser console
 * Usage: import './dev-mock' in main.tsx during dev only
 *
 * Or call window.__kMenu.openDemo() in the browser console.
 */
import type { NUIMessage } from './types'

function dispatch(msg: NUIMessage) {
  window.dispatchEvent(new MessageEvent('message', { data: msg }))
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const w = window as any

w.__kMenu = {
  openDemo() {
    dispatch({
      action: 'openMenu',
      menuId: 'demo_main',
      title:  'K_MENU DEMO',
      subtitle: 'Navigation FiveM',
      items: [
        { id: 's1', type: 'title', label: 'Actions' },
        { id: '1', type: 'button', label: 'Réparer le véhicule', icon: '🔧', description: 'Répare votre véhicule actuel', rightLabel: 'Gratuit' },
        { id: '2', type: 'button', label: 'Laver le véhicule', icon: '🚿', description: '250$', rightLabel: '250 $' },
        { id: 'sep1', type: 'separator', label: 'Gestion' },
        { id: '3', type: 'button', label: 'Ouvrir l\'inventaire', icon: '🎒' },
        { id: '4', type: 'input', label: 'Montant', icon: '💰', placeholder: 'Entrer un montant...', inputType: 'number', min: 0, max: 10000 },
        { id: 'sep2', type: 'separator' },
        { id: '5', type: 'submenu', label: 'Plus d\'options', icon: '⚙️', submenuId: 'sub_options' },
        { id: '6', type: 'button', label: 'Action dangereuse', icon: '⚠️', color: 'danger', description: 'Irréversible' },
        { id: '7', type: 'button', label: 'Action désactivée', disabled: true },
      ],
    })
  },

  openSubmenu() {
    dispatch({
      action: 'openMenu',
      menuId: 'sub_options',
      title: 'OPTIONS',
      subtitle: 'Sous-menu',
      items: [
        { id: 'so1', type: 'button', label: 'Option A', color: 'success' },
        { id: 'so2', type: 'button', label: 'Option B', color: 'warning' },
        { id: 'so3', type: 'button', label: 'Retour', icon: '←' },
      ],
    })
  },

  close() {
    dispatch({ action: 'closeMenu' })
  },
}

console.info('[k_Menu dev] Appelle window.__kMenu.openDemo() pour tester le menu.')
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './styles/global.scss'
import App from './App'

if (import.meta.env.DEV) {
  const w = window as any
  w.dev = {
    open: () => window.dispatchEvent(new MessageEvent('message', { data: {
      action:   'open',
      id:       'demo',
      title:    'K_MENU',
      subtitle: 'v3.1 · FiveM',
      items: [
        { id: 'sep1',  type: 'separator', label: 'Véhicule' },
        { id: 'b1',    type: 'button',    label: 'Réparer',      icon: 'wrench' },
        { id: 'b2',    type: 'button',    label: 'Supprimer',    icon: 'trash',   color: 'danger' },
        { id: 'b3',    type: 'button',    label: 'Boost nitro',  icon: 'bolt',    color: 'warning', rightLabel: 'N' },
        { id: 'sep2',  type: 'separator', label: 'Joueur' },
        { id: 'i1',    type: 'input',     label: 'Montant $',    icon: 'dollar',  placeholder: '0', inputType: 'number' },
        { id: 't1',    type: 'toggle',    label: 'God Mode',     icon: 'shield',  value: false },
        { id: 't2',    type: 'toggle',    label: 'Invisible',    icon: 'eye-slash', value: true },
        { id: 'sep3',  type: 'separator', label: 'Navigation' },
        { id: 'sub1',  type: 'submenu',   label: 'Options avancées', icon: 'gear', submenuId: 'sub' },
        { id: 'b4',    type: 'button',    label: 'Désactivé',    icon: 'ban',     disabled: true },
      ],
    }})),
    sub: () => window.dispatchEvent(new MessageEvent('message', { data: {
      action:   'open',
      id:       'sub',
      title:    'Options',
      subtitle: 'Avancées',
      items: [
        { id: 's1', type: 'button', label: 'Option 1', icon: 'star',   color: 'success' },
        { id: 's2', type: 'button', label: 'Option 2', icon: 'rotate' },
        { id: 's3', type: 'toggle', label: 'Activer logs', icon: 'terminal', value: false },
      ],
    }})),
    close: () => window.dispatchEvent(new MessageEvent('message', { data: { action: 'close' } })),
  }
  console.info('%c[k_menu dev]%c dev.open() · dev.sub() · dev.close()', 'color:#7c6ff7;font-weight:bold', 'color:#9898aa')
}

createRoot(document.getElementById('root')!).render(
  <StrictMode><App /></StrictMode>
)

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
      subtitle: 'v3.0',
      items: [
        { id: 'sep1',  type: 'separator', label: 'véhicule' },
        { id: 'b1',    type: 'button',    label: 'Réparer',    icon: 'wrench' },
        { id: 'b2',    type: 'button',    label: 'Supprimer',  color: 'danger' },
        { id: 'sep2',  type: 'separator', label: 'joueur' },
        { id: 'i1',    type: 'input',     label: 'Montant',    placeholder: '0', inputType: 'number' },
        { id: 't1',    type: 'toggle',    label: 'God Mode',   value: false },
        { id: 'sep3',  type: 'separator' },
        { id: 'sub1',  type: 'submenu',   label: 'Options',    submenuId: 'sub' },
        { id: 'b3',    type: 'button',    label: 'Désactivé',  disabled: true },
      ],
    }})),
    close: () => window.dispatchEvent(new MessageEvent('message', { data: { action: 'close' } })),
  }
  console.info('%c[k_menu dev]%c dev.open() / dev.close()', 'color:#e8e8e8;font-weight:bold', '')
}

createRoot(document.getElementById('root')!).render(
  <StrictMode><App /></StrictMode>
)

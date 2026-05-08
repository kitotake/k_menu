import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './styles/global.scss'
import App from './App.tsx'

// Load dev helpers only in development
if (import.meta.env.DEV) {
  import('./dev-mock')
}

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
)

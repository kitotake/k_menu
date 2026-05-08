/**
 * NUI bridge utilities — FiveM ↔ React communication
 */

const IS_DEV = !window.hasOwnProperty('GetParentResourceName') ||
  (window as unknown as Record<string, unknown>).GetParentResourceName === undefined

/**
 * Get the FiveM resource name (fallback for dev)
 */
export function getResourceName(): string {
  const win = window as unknown as Record<string, (() => string) | undefined>
  if (typeof win.GetParentResourceName === 'function') {
    return win.GetParentResourceName()
  }
  return 'k_menu'
}

/**
 * Send a NUI callback to Lua
 * Returns parsed JSON or null on failure
 */
export async function sendNUICallback<T = unknown>(
  event: string,
  data: unknown = {}
): Promise<T | null> {
  if (IS_DEV) {
    console.info(`[NUI→Lua] ${event}`, data)
    return null
  }
  try {
    const resp = await fetch(`https://${getResourceName()}/${event}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    })
    if (!resp.ok) return null
    return await resp.json() as T
  } catch (err) {
    console.warn(`[NUI] sendNUICallback failed for "${event}":`, err)
    return null
  }
}

/**
 * Register a listener for a specific NUI action
 * Returns a cleanup function
 */
export function onNUIMessage<T = unknown>(
  action: string,
  callback: (data: T) => void
): () => void {
  const handler = (event: MessageEvent) => {
    const data = event.data as { action?: string } & T
    if (data?.action === action) callback(data)
  }
  window.addEventListener('message', handler)
  return () => window.removeEventListener('message', handler)
}

/**
 * Listen to ALL NUI messages — returns cleanup function
 */
export function onAnyNUIMessage<T = unknown>(
  callback: (data: T) => void
): () => void {
  const handler = (event: MessageEvent) => callback(event.data as T)
  window.addEventListener('message', handler)
  return () => window.removeEventListener('message', handler)
}

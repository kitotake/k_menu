/**
 * Send a callback to FiveM Lua
 */
export async function sendNUICallback(event: string, data: unknown = {}) {
  const resp = await fetch(`https://${getResourceName()}/${event}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  try {
    return await resp.json()
  } catch {
    return null
  }
}

/**
 * Get resource name (FiveM env) or fallback
 */
export function getResourceName(): string {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const win = window as any
  if (win.GetParentResourceName) return win.GetParentResourceName()
  return 'k_menu'
}

/**
 * Register a NUI message listener for a specific action
 */
export function onNUIMessage<T = unknown>(
  action: string,
  callback: (data: T) => void
): () => void {
  const handler = (event: MessageEvent) => {
    const data = event.data as { action?: string } & T
    if (data?.action === action) {
      callback(data)
    }
  }
  window.addEventListener('message', handler)
  return () => window.removeEventListener('message', handler)
}

/**
 * Listen to all NUI messages
 */
export function onAnyNUIMessage<T = unknown>(
  callback: (data: T) => void
): () => void {
  const handler = (event: MessageEvent) => {
    callback(event.data as T)
  }
  window.addEventListener('message', handler)
  return () => window.removeEventListener('message', handler)
}
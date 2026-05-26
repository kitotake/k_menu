// utils/nui.ts

const DEV = typeof (window as any).GetParentResourceName !== 'function'

function getResource(): string {
  const w = window as any
  return typeof w.GetParentResourceName === 'function'
    ? w.GetParentResourceName()
    : 'k_menu'
}

export async function nuiCallback<T = unknown>(
  event: string,
  data: unknown = {}
): Promise<T | null> {
  if (DEV) {
    console.info(`[nui→lua] ${event}`, data)
    return null
  }
  try {
    const res = await fetch(`https://${getResource()}/${event}`, {
      method:  'POST',
      headers: { 'Content-Type': 'application/json' },
      body:    JSON.stringify(data),
    })
    if (!res.ok) return null
    return res.json() as Promise<T>
  } catch {
    return null
  }
}

export function onMessage<T = unknown>(cb: (data: T) => void): () => void {
  const handler = (e: MessageEvent) => cb(e.data as T)
  window.addEventListener('message', handler)
  return () => window.removeEventListener('message', handler)
}

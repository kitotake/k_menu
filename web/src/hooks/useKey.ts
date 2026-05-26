// hooks/useKey.ts
import { useEffect, useRef } from 'react'

export function useKey(key: string, fn: () => void) {
  const ref = useRef(fn)
  ref.current = fn
  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (e.key === key) { e.preventDefault(); ref.current() }
    }
    window.addEventListener('keydown', handler)
    return () => window.removeEventListener('keydown', handler)
  }, [key])
}

import { useEffect, useRef } from 'react'

export function useKeyPress(
  targetKey: string,
  handler: (e: KeyboardEvent) => void
) {
  const handlerRef = useRef(handler)
  handlerRef.current = handler

  useEffect(() => {
    const listener = (e: KeyboardEvent) => {
      if (e.key === targetKey) {
        e.preventDefault()
        handlerRef.current(e)
      }
    }
    window.addEventListener('keydown', listener)
    return () => window.removeEventListener('keydown', listener)
  }, [targetKey])
}

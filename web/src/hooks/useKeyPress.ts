import { useEffect, useCallback } from 'react'

export function useKeyPress(
  targetKey: string,
  handler: (e: KeyboardEvent) => void,
  deps: React.DependencyList = []
) {
  const memoHandler = useCallback(handler, deps) // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => {
    const listener = (e: KeyboardEvent) => {
      if (e.key === targetKey) {
        e.preventDefault()
        memoHandler(e)
      }
    }
    window.addEventListener('keydown', listener)
    return () => window.removeEventListener('keydown', listener)
  }, [targetKey, memoHandler])
}

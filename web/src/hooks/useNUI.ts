// hooks/useNUI.ts
import { useEffect, useRef } from 'react'
import { onMessage } from '../utils/nui'

export function useNUI<T = unknown>(cb: (data: T) => void) {
  const ref = useRef(cb)
  ref.current = cb
  useEffect(() => onMessage<T>((d) => ref.current(d)), [])
}

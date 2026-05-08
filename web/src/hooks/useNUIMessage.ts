import { useEffect, useRef } from 'react'
import { onAnyNUIMessage } from '../utils/nui'
import type { NUIMessage } from '../types'

export function useNUIMessage(callback: (data: NUIMessage) => void) {
  const callbackRef = useRef(callback)
  callbackRef.current = callback

  useEffect(() => {
    return onAnyNUIMessage<NUIMessage>((data) => {
      if (data?.action) callbackRef.current(data)
    })
  }, [])
}

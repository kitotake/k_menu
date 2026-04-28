import { useEffect } from 'react'
import { onAnyNUIMessage } from '../utils/nui'
import type { NUIMessage } from '../types'

export function useNUIMessage(callback: (data: NUIMessage) => void) {
  useEffect(() => {
    const cleanup = onAnyNUIMessage<NUIMessage>(callback)
    return cleanup
  }, [callback])
}

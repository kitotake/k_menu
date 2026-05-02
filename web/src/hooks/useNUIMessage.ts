import { useEffect, useRef } from 'react'
import { onAnyNUIMessage } from '../utils/nui'
import type { NUIMessage } from '../types'

export function useNUIMessage(callback: (data: NUIMessage) => void) {
  // FIX: stabiliser le callback avec useRef pour éviter les re-registrations
  const callbackRef = useRef(callback)
  callbackRef.current = callback

  useEffect(() => {
    const cleanup = onAnyNUIMessage<NUIMessage>((data) => callbackRef.current(data))
    return cleanup
  }, []) // pas de dépendances — le ref gère la fraîcheur du callback
}
import { useEffect, useRef } from 'react'

// FIX: utilisation de useRef pour le handler plutôt que useCallback avec deps fragiles.
// Cela évite les re-registrations inutiles d'event listeners et supprime
// le besoin du commentaire eslint-disable.
export function useKeyPress(
  targetKey: string,
  handler: (e: KeyboardEvent) => void,
  // Le paramètre deps est conservé pour la compatibilité mais n'est plus
  // utilisé directement — le pattern ref est plus sûr.
  _deps?: React.DependencyList
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
  }, [targetKey]) // targetKey est la seule vraie dépendance stable
}
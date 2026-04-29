import styles from './MenuFooter.module.scss'

interface MenuFooterProps {
  isRoot?: boolean
}

export function MenuFooter({ isRoot }: MenuFooterProps) {
  return (
    <div className={styles.footer}>
      <div className={styles.hint}>
        <kbd className={styles.key}>↑↓</kbd>
        <span>Naviguer</span>
      </div>
      <div className={styles.hint}>
        <kbd className={styles.key}>↵</kbd>
        <span>Confirmer</span>
      </div>
      {!isRoot ? (
        <div className={styles.hint}>
          <kbd className={styles.key}>⌫</kbd>
          <span>Retour</span>
        </div>
      ) : (
        <div className={styles.hint}>
          <kbd className={styles.key}>Esc</kbd>
          <span>Fermer</span>
        </div>
      )}
    </div>
  )
}
import styles from './MenuFooter.module.scss'

export function MenuFooter() {
  return (
    <div className={styles.footer}>
      <div className={styles.hint}>
        <kbd className={styles.key}>↑↓</kbd>
        <span>Naviguer</span>
      </div>
      <div className={styles.hint}>
        <kbd className={styles.key}>Entrée</kbd>
        <span>Sélectionner</span>
      </div>
      <div className={styles.hint}>
        <kbd className={styles.key}>Échap</kbd>
        <span>Fermer</span>
      </div>
    </div>
  )
}

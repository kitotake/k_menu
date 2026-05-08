import styles from './MenuFooter.module.scss'

interface MenuFooterProps {
  isRoot?: boolean
}

export function MenuFooter({ isRoot }: MenuFooterProps) {
  return (
    <div className={styles.footer}>
      <div className={styles.hint}>
        <kbd className={styles.key}>↑↓</kbd>
        <span>Nav</span>
      </div>
      <div className={styles.divider} />
      <div className={styles.hint}>
        <kbd className={styles.key}>↵</kbd>
        <span>Select</span>
      </div>
      <div className={styles.divider} />
      {!isRoot ? (
        <div className={styles.hint}>
          <kbd className={styles.key}>⌫</kbd>
          <span>Back</span>
        </div>
      ) : (
        <div className={styles.hint}>
          <kbd className={styles.key}>ESC</kbd>
          <span>Close</span>
        </div>
      )}
    </div>
  )
}

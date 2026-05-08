import styles from './MenuHeader.module.scss'

interface MenuHeaderProps {
  title: string
  subtitle?: string
  banner?: string
  itemCount: number
  selectedIndex: number
  showBack?: boolean
}

export function MenuHeader({
  title,
  subtitle,
  banner,
  itemCount,
  selectedIndex,
  showBack = false,
}: MenuHeaderProps) {
  return (
    <div className={styles.header}>
      {/* Banner */}
      {banner && (
        <div className={styles.banner}>
          <img src={banner} alt="" draggable={false} />
        </div>
      )}

      {/* ID tag top bar */}
      <div className={styles.idBar}>
        <span className={styles.idTag}>SYS // K_MENU</span>
        <span className={styles.statusDot} aria-label="online" />
      </div>

      {/* Title row */}
      <div className={styles.content}>
        <div className={styles.titleRow}>
          <div className={styles.titleGroup}>
            {showBack && (
              <div className={styles.backHint}>
                <span className={styles.backArrow}>◄</span>
                <span className={styles.backLabel}>Retour</span>
              </div>
            )}
            <h1 className={styles.title}>{title}</h1>
            {subtitle && <p className={styles.subtitle}>{subtitle}</p>}
          </div>

          <div className={styles.counter}>
            <span className={styles.counterLabel}>ITEM</span>
            <div className={styles.counterValue}>
              <span className={styles.counterCurrent}>{selectedIndex + 1}</span>
              <span className={styles.counterSep}>/</span>
              <span className={styles.counterTotal}>{itemCount}</span>
            </div>
          </div>
        </div>

        <div className={styles.accentLine} />
      </div>
    </div>
  )
}

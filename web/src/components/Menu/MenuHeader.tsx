import styles from './MenuHeader.module.scss'

interface MenuHeaderProps {
  title: string
  subtitle?: string
  banner?: string
  itemCount: number
  selectedIndex: number
  showBack?: boolean
}

export function MenuHeader({ title, subtitle, banner, itemCount, selectedIndex, showBack = false }: MenuHeaderProps) {
  return (
    <div className={styles.header}>
      {banner && (
        <div className={styles.banner}>
          <img src={banner} alt="" draggable={false} />
          <div className={styles.bannerOverlay} />
        </div>
      )}
      <div className={styles.content}>
        <div className={styles.titleRow}>
          <div className={styles.titleGroup}>
            {showBack && (
              <div className={styles.backHint}>
                <span className={styles.backArrow}>‹</span>
                <span className={styles.backLabel}>Retour</span>
              </div>
            )}
            <h1 className={styles.title}>{title}</h1>
            {subtitle && <p className={styles.subtitle}>{subtitle}</p>}
          </div>
          <div className={styles.counter}>
            <span className={styles.counterCurrent}>{selectedIndex + 1}</span>
            <span className={styles.counterSep}>/</span>
            <span className={styles.counterTotal}>{itemCount}</span>
          </div>
        </div>
        <div className={styles.accentLine} />
      </div>
    </div>
  )
}
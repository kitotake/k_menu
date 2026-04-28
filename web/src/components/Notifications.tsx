import { useEffect, useState } from 'react'
import type { Notification } from '../types'
import styles from './Notifications.module.scss'

interface NotificationsProps {
  notifications: Notification[]
  onRemove: (id: string) => void
}

function NotifItem({ notif, onRemove }: { notif: Notification; onRemove: (id: string) => void }) {
  const [exiting, setExiting] = useState(false)

  useEffect(() => {
    const exitTimer = setTimeout(() => setExiting(true), notif.duration - 400)
    const removeTimer = setTimeout(() => onRemove(notif.id), notif.duration)
    return () => {
      clearTimeout(exitTimer)
      clearTimeout(removeTimer)
    }
  }, [notif, onRemove])

  const icons: Record<string, string> = {
    success: '✓',
    error:   '✕',
    warning: '⚠',
    info:    'ℹ',
  }

  return (
    <div
      className={[
        styles.notif,
        styles[notif.type],
        exiting ? styles.exit : '',
      ].filter(Boolean).join(' ')}
      onClick={() => { setExiting(true); setTimeout(() => onRemove(notif.id), 300) }}
    >
      <span className={styles.notifIcon}>{icons[notif.type]}</span>
      <span className={styles.notifMessage}>{notif.message}</span>
      <div
        className={styles.progressBar}
        style={{ animationDuration: `${notif.duration}ms` }}
      />
    </div>
  )
}

export function Notifications({ notifications, onRemove }: NotificationsProps) {
  return (
    <div className={styles.container} aria-live="polite">
      {notifications.map(n => (
        <NotifItem key={n.id} notif={n} onRemove={onRemove} />
      ))}
    </div>
  )
}

export interface AvatarProps {
  src?:     string
  alt?:     string
  initials?: string
  size?:    'xs' | 'sm' | 'md' | 'lg' | 'xl'
  status?:  'online' | 'offline' | 'busy' | 'away'
}

const sizes = { xs: 24, sm: 32, md: 40, lg: 52, xl: 64 }
const statusColors = { online: '#4dffb8', offline: '#4a4f66', busy: '#ff4d6a', away: '#ffd24d' }

export function Avatar({ src, alt = '', initials, size = 'md', status }: AvatarProps) {
  const px = sizes[size]
  const fontSize = Math.round(px * 0.36)

  return (
    <div style={{ position: 'relative', display: 'inline-flex', flexShrink: 0 }}>
      <div style={{
        width: px, height: px,
        borderRadius: '50%',
        overflow: 'hidden',
        background: '#1a1d27',
        border: '1px solid rgba(255,255,255,0.08)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontSize, fontWeight: 600, color: '#a891ff',
        fontFamily: 'var(--k-font-ui)',
        flexShrink: 0,
      }}>
        {src
          ? <img src={src} alt={alt} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
          : <span>{initials ?? alt.slice(0, 2).toUpperCase()}</span>
        }
      </div>
      {status && (
        <span style={{
          position: 'absolute', bottom: 0, right: 0,
          width: Math.max(8, px * 0.24), height: Math.max(8, px * 0.24),
          borderRadius: '50%',
          background: statusColors[status],
          border: '2px solid #0d0e12',
        }} aria-label={status} />
      )}
    </div>
  )
}

// barrel
export { Avatar as default } from './Avatar'
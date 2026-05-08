export interface AvatarProps {
  src?: string
  alt?: string
  initials?: string
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
  status?: 'online' | 'offline' | 'busy' | 'away'
}

const sizes = { xs: 24, sm: 32, md: 40, lg: 52, xl: 64 }
const statusColors = {
  online: '#3dffc8',
  offline: '#2e4058',
  busy: '#ff4d6a',
  away: '#ffb84d',
}

export function Avatar({ src, alt = '', initials, size = 'md', status }: AvatarProps) {
  const px = sizes[size]
  return (
    <div style={{ position: 'relative', display: 'inline-flex', flexShrink: 0 }}>
      <div
        style={{
          width: px, height: px, borderRadius: '50%', overflow: 'hidden',
          background: '#0a0c14', border: '1px solid rgba(59,158,255,0.15)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontSize: Math.round(px * 0.36), fontWeight: 600, color: '#7cc4ff',
          fontFamily: "'Share Tech Mono', monospace", flexShrink: 0,
        }}
      >
        {src
          ? <img src={src} alt={alt} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
          : <span>{initials ?? alt.slice(0, 2).toUpperCase()}</span>}
      </div>
      {status && (
        <span
          style={{
            position: 'absolute', bottom: 0, right: 0,
            width: Math.max(8, px * 0.24), height: Math.max(8, px * 0.24),
            borderRadius: '50%', background: statusColors[status], border: '2px solid #080a10',
          }}
          aria-label={status}
        />
      )}
    </div>
  )
}

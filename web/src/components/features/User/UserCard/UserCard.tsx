import { Avatar }     from '../../../ui/Avatar/Avatar'
import { Badge }      from '../../../ui/Badge/Badge'
import { Typography } from '../../../ui/Typography/Typography'

export interface UserCardProps {
  name:        string
  identifier?: string
  avatar?:     string
  status?:     'online' | 'offline' | 'busy' | 'away'
  role?:       string
  compact?:    boolean
}

export function UserCard({ name, identifier, avatar, status = 'online', role, compact = false }: UserCardProps) {
  if (compact) {
    return (
      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
        <Avatar alt={name} src={avatar} size="sm" status={status} />
        <Typography variant="body-sm" truncate>{name}</Typography>
      </div>
    )
  }

  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 12,
      padding: '10px 14px',
      background: '#13151c',
      border: '1px solid rgba(255,255,255,0.06)',
      borderRadius: 8,
    }}>
      <Avatar alt={name} src={avatar} size="md" status={status} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <Typography variant="h4" truncate>{name}</Typography>
        {identifier && (
          <Typography variant="caption" color="muted" truncate>{identifier}</Typography>
        )}
      </div>
      {role && <Badge variant="accent" size="sm">{role}</Badge>}
    </div>
  )
}
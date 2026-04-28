export type LoaderSize = 'xs' | 'sm' | 'md' | 'lg'

export interface LoaderProps {
  size?:  LoaderSize
  label?: string
  color?: string
}

const sizes: Record<LoaderSize, number> = { xs: 14, sm: 20, md: 32, lg: 48 }

export function Loader({ size = 'md', label, color = 'var(--k-accent, #8264ff)' }: LoaderProps) {
  const px = sizes[size]
  return (
    <div
      role="status"
      aria-label={label ?? 'Chargement…'}
      style={{ display: 'inline-flex', flexDirection: 'column', alignItems: 'center', gap: 8 }}
    >
      <svg
        width={px} height={px}
        viewBox="0 0 24 24"
        fill="none"
        style={{ animation: 'k-spin 0.8s linear infinite' }}
      >
        <circle cx="12" cy="12" r="10" stroke="rgba(255,255,255,0.1)" strokeWidth="2.5" />
        <path
          d="M12 2 a10 10 0 0 1 10 10"
          stroke={color}
          strokeWidth="2.5"
          strokeLinecap="round"
        />
        <style>{`@keyframes k-spin { to { transform: rotate(360deg); } }`}</style>
      </svg>
      {label && (
        <span style={{ fontSize: 11, color: 'var(--k-text-secondary, #7a7f99)', letterSpacing: '0.06em', textTransform: 'uppercase' }}>
          {label}
        </span>
      )}
    </div>
  )
}


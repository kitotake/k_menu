export interface IconProps {
  name:    string   // emoji, SVG path id, or lucide icon name
  size?:   number
  color?:  string
  label?:  string
}

export function Icon({ name, size = 16, color = 'currentColor', label }: IconProps) {
  return (
    <span
      role={label ? 'img' : 'presentation'}
      aria-label={label}
      aria-hidden={!label}
      style={{
        display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        width: size, height: size, fontSize: size * 0.85,
        color, lineHeight: 1, flexShrink: 0, userSelect: 'none',
      }}
    >
      {name}
    </span>
  )
}
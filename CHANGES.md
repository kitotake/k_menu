# k_Menu v2.1 — Changelog des modifications

## 🎨 Refonte visuelle complète (web/src)

### Aesthetic Direction
- **Thème**: Military HUD / Scanner tactique
- **Police principale**: `Rajdhani` (display condensé) + `Share Tech Mono` (données/code)
- **Palette**: Deep space noir (#080a10) + Electric blue accent (#3b9eff)
- **Coins angulaires** (bracket decorations) animés à l'ouverture
- **Scan line animée** traversant le menu (effet HUD)
- **Lignes de scan répétées** (subtle scanlines overlay)

### Corrections de bugs
| Fichier | Problème | Fix |
|---------|----------|-----|
| `Badge/badge.tsx` | Mauvaise casse du fichier (lowercase b) | Renommé `Badge.tsx` |
| `Icon/icon.tsx` | Mauvaise casse du fichier | Renommé `Icon.tsx` |
| `App.tsx` | `dev-mock.ts` importé en prod | Import conditionnel `import.meta.env.DEV` |
| `utils/nui.ts` | Pas de gestion d'erreur sur fetch, type unsafe | Try/catch + generic typing |
| `MenuItem.tsx` | Input value ne se reset pas correctement | `useEffect` sur `item.id` |
| `MenuItem.tsx` | ArrowKey + Escape bubblent dans input | `stopPropagation` sur Escape aussi |
| `useNUIMessage.ts` | Callback sans guard sur `action` | Guard `data?.action` ajouté |

### Nouvelles fonctionnalités
- **Toggle item** : interrupteur ON/OFF avec couleurs (success/danger)
- **Slider item** : glissière avec valeur affichée temps réel
- **NUI util** : `sendNUICallback` typée générique `<T>`
- **Dev mock** : log stylisé + exemples toggle/slider
- **main.tsx** : import conditionnel dev-mock via `import.meta.env.DEV`

### Améliorations UX
- Animation d'ouverture `clip-path` scan (revèle le menu de haut en bas)
- Coins de brackets (TL/BR plus lumineux, TR/BL atténués)
- Ligne d'accent centrale avec point central dans le header
- Barre ID `SYS // K_MENU` + dot de statut animé
- Counter re-stylisé (vertical, label + valeur séparés)
- Footer : hints de touches avec séparateurs
- Item sélectionné : `border-left` + glow bar + afterglow droit
- Séparateur : font mono, tracking élevé
- Titre section : barre verticale bleue + ligne dégradée

## 📁 Fichiers modifiés
```
web/src/styles/_variables.scss   ← palette + fonts
web/src/styles/global.scss       ← keyframes + fonts import
web/src/types/index.ts           ← +ToggleItem, +SliderItem
web/src/utils/nui.ts             ← IS_DEV guard, generic typing, error handling
web/src/hooks/useKeyPress.ts     ← nettoyage
web/src/hooks/useNUIMessage.ts   ← guard data?.action
web/src/App.tsx                  ← nettoyage
web/src/App.module.scss          ← simplifié
web/src/main.tsx                 ← import.meta.env.DEV
web/src/dev-mock.ts              ← +toggle/slider exemples, log stylisé
web/src/components/Menu/Menu.tsx
web/src/components/Menu/Menu.module.scss
web/src/components/Menu/MenuHeader.tsx
web/src/components/Menu/MenuHeader.module.scss
web/src/components/Menu/MenuFooter.tsx
web/src/components/Menu/MenuFooter.module.scss
web/src/components/Menu/MenuItem.tsx
web/src/components/Menu/MenuItem.module.scss
web/src/components/ui/Badge/Badge.tsx  ← casse corrigée
web/src/components/ui/Icon/Icon.tsx    ← casse corrigée
web/src/components/ui/Avatar/Avatar.tsx
web/src/components/ui/Tooltip/Tooltip.tsx
web/src/components/ui/Typography/Typography.tsx
```

## 📁 Fichiers NON modifiés (Lua backend)
```
client/main.lua
client/admin.lua
client/admin_effects.lua
client/noclip.lua
server/main.lua
server/admin.lua
shared/main.lua
fxmanifest.lua  (version bump 2.0 → 2.1)
```

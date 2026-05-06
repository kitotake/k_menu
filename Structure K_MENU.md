# 📁 Structure du projet K_MENU

```bash 
K_MENU/
│   fxmanifest.lua
│   README.md
│
├── .vscode/
│   ├── settings.json
│   └── tasks.json
│
├── client/
│   ├── admin.lua
│   ├── admin_effects.lua
│   ├── main.lua
│   └── noclip.lua
│
├── server/
│   ├── admin.lua
│   └── main.lua
│
├── shared/
│   └── main.lua
│
└── web/
    │   .gitignore
    │   eslint.config.js
    │   index.html
    │   note.txt
    │   package-lock.json
    │   package.json
    │   README.md
    │   tsconfig.app.json
    │   tsconfig.json
    │   tsconfig.node.json
    │   vite.config.ts
    │
    ├── dist/                    # Build production (à ignorer Git)
    │   ├── favicon.svg
    │   ├── icons.svg
    │   ├── index.html
    │   └── assets/
    │       ├── index-BRolyyAD.js
    │       └── index-gvlBIywI.css
    │
    ├── public/
    │   ├── favicon.svg
    │   └── icons.svg
    │
    └── src/
        │   App.tsx
        │   App.module.scss
        │   main.tsx
        │   dev-mock.ts
        │
        ├── assets/
        │   ├── hero.png
        │   ├── react.svg
        │   └── vite.svg
        │
        ├── components/
        │   │   index.ts
        │   │
        │   ├── common/
        │   │   ├── Button/
        │   │   │   ├── Button.scss
        │   │   │   ├── Button.tsx
        │   │   │   └── index.ts
        │   │   │
        │   │   ├── Card/
        │   │   │   ├── Card.scss
        │   │   │   ├── Card.tsx
        │   │   │   └── index.ts
        │   │   │
        │   │   ├── Input/
        │   │   │   ├── Input.scss
        │   │   │   ├── Input.tsx
        │   │   │   └── index.ts
        │   │   │
        │   │   ├── Loader/
        │   │   │   ├── Loader.scss
        │   │   │   ├── Loader.tsx
        │   │   │   └── index.ts
        │   │   │
        │   │   └── Modal/
        │   │       ├── Modal.tsx
        │   │       └── index.ts
        │   │
        │   ├── features/
        │   │   └── User/
        │   │       └── UserCard/
        │   │           └── UserCard.tsx
        │   │
        │   ├── Menu/
        │   │   ├── Menu.tsx
        │   │   ├── Menu.module.scss
        │   │   ├── MenuHeader.tsx
        │   │   ├── MenuHeader.module.scss
        │   │   ├── MenuFooter.tsx
        │   │   ├── MenuFooter.module.scss
        │   │   ├── MenuItem.tsx
        │   │   └── MenuItem.module.scss
        │   │
        │   └── ui/
        │       ├── index.ts
        │       ├── Avatar/Avatar.tsx
        │       ├── Badge/Badge.tsx
        │       ├── Icon/Icon.tsx
        │       ├── Tooltip/Tooltip.tsx
        │       └── Typography/Typography.tsx
        │
        ├── core/
        │   ├── bridge/
        │   ├── devtools/
        │   └── events/
        │
        ├── hooks/
        │   ├── useKeyPress.ts
        │   └── useNUIMessage.ts
        │
        ├── styles/
        │   ├── global.scss
        │   └── _variables.scss
        │
        ├── types/
        │   └── index.ts
        │
        └── utils/
            └── nui.ts
```

---

## 🧠 Analyse rapide

### 🎮 Backend FiveM

* `client/admin.lua` → admin tools + noclip
* `server/admin.lua` → permissions admin
* `shared/main.lua` → config globale

👉 Tu as un **menu admin + dev tool system intégré**

---

### 🌐 Frontend (NUI React)

#### 🧱 Architecture UI

* `common/` → composants réutilisables (Button, Modal…)
* `ui/` → primitives UI (Avatar, Icon, Typography)
* `Menu/` → cœur du système menu
* `features/User/` → logique métier isolée

---

### ⚙️ Core

* `bridge/` → communication NUI ↔ Lua
* `events/` → event bus
* `devtools/` → debug tools

---

### 🎯 Hooks

* `useKeyPress` → input clavier
* `useNUIMessage` → communication FiveM

---

## ⚠️ Points forts

✔ architecture propre en layers
✔ séparation UI / features / core
✔ bon découpage menu system
✔ base scalable pour admin menu complet

---

## 🚀 Améliorations possibles

* Ajouter `store/` (Zustand ou Redux)
* Ajouter `services/` (API layer NUI)
* Compléter `core/bridge` (fetchNui + register callbacks)
* Ajouter `permissions system` côté web (UI admin)

---

## 🔥 Verdict

👉 C’est un **menu system très propre type framework admin**
👉 Bien structuré pour évoluer en :

* admin panel complet
* dev tools
* menu interactif RP

---

# k_menu v3

Menu NUI minimaliste pour FiveM — React + TypeScript + Lua.

## Installation

```sh
cd web
npm install
npm run build
```

Copier le dossier `k_menu_v2` dans `resources/` et ajouter dans `server.cfg` :
```
ensure k_menu
```

## Configuration

Éditer `shared/config.lua` :
- `Config.Admins` — liste des IDs admins (license ou steam)
- `Config.MenuKey` / `Config.AdminKey` — touches d'ouverture
- `Config.Debug` — logs de debug

## Utilisation

### Ouvrir un menu depuis Lua (client)

```lua
K.open({
    id       = "mon_menu",
    title    = "MON MENU",
    subtitle = "description",
    items    = {
        { id = "sep1", type = "separator", label = "Section" },
        { id = "b1",   type = "button",    label = "Bouton",   color = "success" },
        { id = "i1",   type = "input",     label = "Valeur",   placeholder = "0", inputType = "number" },
        { id = "t1",   type = "toggle",    label = "Option",   value = false },
        { id = "sub1", type = "submenu",   label = "Sous-menu", submenuId = "mon_sous_menu" },
    }
})
```

### Lire la valeur d'un input

```lua
local val = K.input("i1")  -- retourne la valeur saisie
```

### Fermer

```lua
K.close()
```

### Écouter les clics

```lua
RegisterNetEvent('k_menu:button', function(id, menuId)
    if id == "b1" then
        -- action
    end
end)
```

### Écouter les toggles

```lua
RegisterNetEvent('k_menu:toggle', function(id, value, menuId)
    if id == "t1" then
        -- value = true/false
    end
end)
```

### Naviguer vers un sous-menu

```lua
RegisterNetEvent('k_menu:submenu', function(submenuId, menuId)
    if submenuId == "mon_sous_menu" then
        K.open({ id = "mon_sous_menu", title = "SOUS-MENU", items = {} })
    end
end)
```

## Types d'items

| type        | champs spécifiques                                   |
|-------------|------------------------------------------------------|
| `button`    | `color` (danger/success/warning), `rightLabel`       |
| `input`     | `placeholder`, `inputType`, `min`, `max`, `value`    |
| `toggle`    | `value` (bool)                                       |
| `separator` | `label` (optionnel)                                  |
| `submenu`   | `submenuId`                                          |

## Dev

```sh
cd web && npm run dev
```

Dans la console : `dev.open()` / `dev.close()`

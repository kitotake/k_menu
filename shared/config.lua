-- shared/config.lua

Config = {}

-- ─────────────────────────────────────────────────────────────
-- Admins hardcodés (license identifier)
-- Prioritaire sur la vérification SQL
-- ─────────────────────────────────────────────────────────────
Config.Admins = {
    "license:CHANGEME",
    -- "license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
}

-- ─────────────────────────────────────────────────────────────
-- Touches menus
-- ─────────────────────────────────────────────────────────────
Config.AdminKey = 'F10'   -- Ouvrir le menu admin

-- ─────────────────────────────────────────────────────────────
-- NoClip — control IDs FiveM
-- Référence : https://docs.fivem.net/docs/game-references/controls/
-- ─────────────────────────────────────────────────────────────
Config.Noclip = {
    toggleKey   = 56,   -- F9          — activer/désactiver le noclip

    forward     = 32,   -- W (Z AZERTY)
    backward    = 33,   -- S
    left        = 34,   -- A (Q AZERTY)
    right       = 35,   -- D

    up          = 22,   -- ESPACE      — monter
    down        = 36,   -- LEFT CTRL   — descendre

    sprint      = 21,   -- LEFT SHIFT  — boost temporaire ×2.5
    cycleSpeed  = 19,   -- LEFT ALT    — changer la vitesse

    -- Vitesses disponibles (cycle avec cycleSpeed)
    speeds = {
        { label = "Très Lent",   speed = 0.3  },
        { label = "Lent",        speed = 0.8  },
        { label = "Normal",      speed = 2.0  },
        { label = "Rapide",      speed = 4.0  },
        { label = "Très Rapide", speed = 8.0  },
        { label = "Extrême",     speed = 15.0 },
        { label = "Turbo",       speed = 30.0 },
    },
    defaultSpeedIndex = 3,  -- "Normal" au démarrage

    -- Transparence du joueur/véhicule pendant le noclip (0-255)
    alpha = 180,
}

-- ─────────────────────────────────────────────────────────────
-- Debug
-- ─────────────────────────────────────────────────────────────
Config.Debug = false
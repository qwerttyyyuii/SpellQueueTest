std = "lua51"
max_line_length = false

exclude_files = {
    ".idea/",
    "notee.lua",
    ".luacheckrc",
}

ignore = {
    "11./SLASH_.*", -- Setting an undefined (Slash handler) global variable
    --"212/self",  -- Unused argument
    --"213", -- Unused loop variable
}

-- Force error on 'print' in code to ensure we never forget to remove debug statements on release
--not_globals = { "print" }

globals = {
    "SlashCmdList",
}

read_globals = {
    "CreateFrame",
    "C_CVar",
    "UnitName",
    "UnitGUID",
    "GetSpellInfo",
    "GetSpellBaseCooldown",
    "UIParent",
    "GetLocale",
    "CombatLogGetCurrentEventInfo",
    "SlashCmdList",
    "GetNetStats",
    "GetSpellCooldown",
    "debugprofilestop",
    "BackdropTemplateMixin",
    "UISpecialFrames",
    "GameFontHighlightSmall",
}
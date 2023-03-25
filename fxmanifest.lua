fx_version "adamant"
game "gta5"

name "mth-aggressive"
description "Spawns aggressive peds"
author "Mathu_lmn"
version "2.0.0"
url "https://github.com/Mathu-lmn/mth-aggressive"

server_script "server.lua"
shared_script "config.lua"

client_scripts {
    'RageUI/RMenu.lua',
    'RageUI/menu/RageUI.lua',
    'RageUI/menu/Menu.lua',
    'RageUI/menu/MenuController.lua',
    'RageUI/components/*.lua',
    'RageUI/menu/elements/*.lua',
    'RageUI/menu/items/*.lua',
    'RageUI/menu/panels/*.lua',
    'RageUI/menu/windows/*.lua',
    'client.lua',
}
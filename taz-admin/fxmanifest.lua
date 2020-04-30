fx_version 'bodacious'
game 'gta5'

author 'Tazio de Bruin'
title 'Taz Admin'
description 'Administrate your server'
version '0.1'

dependencies {
    'mysql-async'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua',
    '@mysql-async/lib/MySQL.lua',
    'config.lua'
}

server_exports {
    'report',
    'warning',
    'kick',
    'ban'
}
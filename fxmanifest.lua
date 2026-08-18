fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'DANIELGDM180'
description 'unified compass, street label & nearest postal display'
version '1.0.0'

client_scripts {
    'config.lua',
    'cl.lua',
    'cl_commands.lua',

    -- uncomment to enable dev tools for adding new postal codes in-game
    --'cl_dev.lua',
}

server_scripts {
    'config.lua',
    'sv.lua',
}

ui_page 'html/index.html'

files {
    'BigDaddy-postals.json',
    'html/index.html',
    'html/css/styles.css',
    'html/css/font-face.css',
    'html/fonts/*.woff2',
    'html/fonts/*.woff',
    'html/fonts/*.ttf',
    'html/js/listener.js',
}

postal_file 'BigDaddy-postals.json'

server_export 'getPostalServer'

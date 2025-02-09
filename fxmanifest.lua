fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Forlax'
description 'Fishing 4.0'
version '1.0.0'

ui_page 'nui/index.html'

files {
    'nui/**/*',
}

shared_scripts {
	'config.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/core.lua',
	'server/**.lua',
}

client_scripts { 
	'client/core.lua',
	'client/**.lua'
}

escrow_ignore {
	'shared/**',
	'client/**',
	'server/**',
	'locales/**.lua'
}

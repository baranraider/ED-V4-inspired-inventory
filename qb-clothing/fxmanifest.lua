fx_version 'cerulean'
game 'gta5'

description 'QB Clothing edited by wilddev'

ui_page "html/index.html"

server_scripts {
	"server/main.lua",
}

client_scripts {
	'@PolyZone/client.lua',
	"config.lua",
	"client/data.lua",
	"client/main.lua",
}

files {
	'html/index.html',
	'html/style.css',
	'html/reset.css',
	'html/script.js',
}
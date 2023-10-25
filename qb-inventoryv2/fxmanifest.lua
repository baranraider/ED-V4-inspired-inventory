fx_version 'cerulean'
game 'gta5'

description 'Qbus:Inventory'

server_scripts {
	"config.lua",
	"server/main.lua",
}

client_scripts {
	"config.lua",
	"client/main.lua",
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/*.css',
	'html/fontawesome/*.css',
	'html/fontawesome/*.js',
	'html/js/*.js',
	'html/images/*.png',
	'html/images/*.jpg',
	'html/ammo_images/*.png',
	'html/attachment_images/*.png',
	'html/*.ttf',
}

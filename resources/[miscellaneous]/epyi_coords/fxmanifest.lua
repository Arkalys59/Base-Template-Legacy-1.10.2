---
--- @author Epyi - Work FiveM
--- @version 0.1.0
--- created at [18/08/2023 12:44]
---

fx_version("cerulean")
game("gta5")

name("epyi_coords")
description("Fivem coords menu to train me in NUI")
author("Epyi (https://discord.gg/VyRPheG6Es)")
version("0.1.0")

files({
	"html/index.html",
	"html/css/*.css",
	"html/js/*.js",
})

ui_page({
	"html/index.html",
})

client_scripts({
	"client/*.lua",
}) 

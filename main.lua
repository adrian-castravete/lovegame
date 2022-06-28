local fennel = require("fennel")
table.insert(package.loaders or package.searchers, fennel.make_searcher({correlate=true}))
local srcDir = love.filesystem.getSource()
if srcDir:sub(-5, -1) ~= ".love" then
	package.path = string.format(
		"%s;%s?.lua;%s?/init.lua",
		package.path, srcDir, srcDir
	)
	fennel.path = string.format(
		"%s;%s?.fnl;%s?/init.fnl",
		fennel.path, srcDir, srcDir
	)
end

local config = {
  gameModule = "games.one-hit",
  globalShortcuts = true,
  globalEngine = true,
  debugLayer = true,
  inputConfiguration = {
  	keyboard = {
  		left = {"left", "a"},
  		up = {"up", "w"},
  		right = {"right", "d"},
  		down = {"down", "s"},
  		btnA = {"alt", "k"},
  		btnB = {"ctrl", "j"},
  		btnC = {"space", "l"},
  		start = {"enter"},
  		bootstrapReload = {"f10"},
  		bootstrapExit = {"f12"},
  	},
  	joystick = {
  		axis = {
  			[1] = {
  				names = {"left", "right"},
  				threshold = 0.5,
  			},
  			[2] = {
  				names = {"up", "down"},
  				threshold = 0.5,
  			},
  		},
  		buttons = {
  			btnA = {1, 4},
  			btnB = {2, 5},
  			btnC = {3, 6},
  			start = {7, 8, 9, 10},
  		},
  	},
  	touch = {
  		controls = {
  			{
  				kind = "dpad",
  				anchor = "ld",
  				size = 40,
  				gap = 5,
  				deadZone = 0.2,
  			},
  			{
  				name = "bootstrapReload",
  				size = 7,
  				gap = 5,
  				anchor = "lu",
  			},
  			{
  				name = "btnA",
  				size = 20,
  				gapX = 5,
  				gapY = 15,
  				anchor = "rd",
  			},
  			{
  				name = "btnB",
  				size = 20,
  				gapX = 30,
  				gapY = 5,
  				anchor = "rd",
  			},
  			{
  				name = "btnC",
  				size = 20,
  				gapX = 30,
  				gapY = 30,
  				anchor = "rd",
  			},
  			{
  				name = "start",
  				size = 10,
  				gap = 5,
  				anchor = "ru",
  			},
  		},
  	},
  },
}

local bootstrap = require "mylove.bootstrap"
bootstrap(config)
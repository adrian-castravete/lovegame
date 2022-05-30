function love.conf(t)
	t.identity = "fkbm-game"
	t.version = "11.0"
	t.accelerometerjoystick = false
	t.externalstorage = true
	t.gammacorrect = false

	local w = t.window
	w.title = "Game"
	w.icon = nil
	w.width = 480
	w.height = 360
	w.depth = 16
	w.minwidth = 480
	w.minheight = 360
	w.resizable = true
	w.usedpiscale = false
	w.hidpi = false
	w.fullscreentype = "desktop"
	w.fullscreen = false
end

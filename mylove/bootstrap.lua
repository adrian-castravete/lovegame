local cpath = ...
local croot = cpath:gsub("%.[^%.]+$", "")
if cpath == croot then
	croot = ""
end

local _lg = love.graphics

local function bootstrap(config)
  local gameModule = config.gameModule or nil
  local inputConfiguration = config.inputConfiguration or {}
	local whiteColor = love.getVersion() > 10 and {1, 1, 1} or {255, 255, 255}
	local fnt = _lg.newFont(croot .. "/assets/cm.ttf", 24)

	-- Save ("freeze") loaded modules
	local modules = {}
	for key, value in pairs(package.loaded) do
		modules[key] = value
	end

	local inputHooks = {
		"keypressed",
		"joystickpressed",
		"joystickreleased",
		"joystickaxis",
		"touchpressed",
		"touchreleased",
		"touchmoved",
	}

	local function reload()
		-- Restore modules
		for key, value in pairs(package.loaded) do
			if not modules[key] then
				package.loaded[key] = nil
			end
		end
		_lg.setDefaultFilter("nearest", "nearest")
		
		if config.debugLayer then
		  dbg = require("mylove.debugscr")
		end
		if config.globalEngine then
		  myloveEngine = require("mylove.engine")
		  if config.globalShortcuts then
		    me = myloveEngine(gameModule)
		  end
		else
		  myloveEngine = nil
		  me = nil
		end
		if config.globalShortcuts then
		  lg = love.graphics
		else
		  lg = nil
		end

		local function protect(func, level)
			return xpcall(func, function (msg)
				-- Show the error message but let the user press F10 to reload
				local tb = debug.traceback("Error: " .. tostring(msg), level or 1)
				--tb = tb:gsub("%[C%]: in function 'require'%s+age/bootstrap%.lua.*", "")
				tb = tb:gsub("\n+[^\n]+bootstrap%.lua.*", "")
				print(tb)
				love.draw = function ()
					local w, h = _lg.getDimensions()
					_lg.setColor(1, 0.4, 0.2)
					_lg.printf(tb, fnt, 0, 24, w)
				end
				love.touchpressed = function ()
					reload()
				end
				love.touchreleased = function () end
				love.touchmoved = function () end
			end)
		end

		math.randomseed(os.time())
		math.random()
		math.random()
		math.random()

		local input = require(croot .. ".input")
		function love.keyreleased(key)
			if key == "f10" then
			end
			if key == "f12" then
				love.event.quit()
			end
			input.keyreleased(key)
		end

		for _, hook in ipairs(inputHooks) do
			love[hook] = input[hook]
		end

		--[[
		local mouseDown = false
		love.mousepressed = function (...)
		input.touchpressed('x', ...)
		mouseDown = true
		end
		love.mousereleased = function (...)
		mouseDown = false
		input.touchreleased('x', ...)
		end
		love.mousemoved = function (...)
		if mouseDown then
		input.touchmoved('x', ...)
		end
		end
		--]]

		input.setup(inputConfiguration)
		
		-- Should we fail to require the game,
		local ok = protect(function ()
			local game = require(gameModule)
			if not game or type(game) ~= "table" then
			  error("Game module didn't return a table")
			end
			game.start()
			function love.update(dt)
				local ok = protect(function ()
					game.update(dt)
				end, 3)
				if not ok then
					love.update = nil
				end
			end
			
			function love.resize(w, h)
  			game.resize(w, h)
  			input.resize(w, h)
  		end

  		function love.draw()
  			game.draw()
  			input.draw()
  			if dbg then
  			  dbg.draw()
  			end
  		end

			input.onButtonPressed(game.pressed)
			input.onButtonReleased(function (btn)
				if btn == "bootstrapReload" then
					reload()
					print(os.date("Reloaded at %Y-%m-%d %H:%M:%S"))
					return
				end
				if btn == "bootstrapExit" then
					love.event.quit()
					return
				end
				return game.released(btn)
			end)
		end, 3)
		if not ok then
			love.update = nil
		end
	end

	reload()
end

return bootstrap

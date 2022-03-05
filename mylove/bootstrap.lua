local cpath = ...
local croot = cpath:gsub("%.[^%.]+$", "")
if cpath == croot then
	croot = ""
end

local lg = love.graphics

local function bootstrap(gameModule, inputConfiguration, viewportConfiguration)
	local whiteColor = love.getVersion() > 10 and {1, 1, 1} or {255, 255, 255}

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

		local function protect(func, level)
			return xpcall(func, function (msg)
				-- Show the error message but let the user press F10 to reload
				local tb = debug.traceback("Error: " .. tostring(msg), level or 1)
				--tb = tb:gsub("%[C%]: in function 'require'%s+age/bootstrap%.lua.*", "")
				tb = tb:gsub("\n+[^\n]+bootstrap%.lua.*", "")
				print(tb)
				love.draw = function ()
					local w, h = lg.getDimensions()
					lg.push()
					lg.setColor(1.0, 0.75, 0.5)
					lg.scale(2, 2)
					lg.printf(tb, 0, 12, w)
				    lg.pop()
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

		local viewport = require(croot .. ".viewport")
		if viewportConfiguration then
			viewport.setup(viewportConfiguration)
		end

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
			game.start()

			function love.resize(w, h)
				if viewportConfiguration then
					viewport.resize(w, h)
				elseif game.resize then
					game.resize(w, h)
				end
				input.resize(w, h)
			end
	
			function love.draw()
				if viewportConfiguration then
					viewport.draw()
				elseif game.draw then
					game.draw()
				end
				input.draw()
			end
			
			function love.update(dt)
				if viewportConfiguration then
					lg.setCanvas({viewport.canvas, depth = true})
				end
				lg.setColor(whiteColor)
				lg.clear(0, 0, 0)
				local ok = protect(function ()
					game.update(dt)
				end, 3)
				if not ok then
					love.update = nil
				end
				if viewportConfiguration then
					lg.setCanvas()
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

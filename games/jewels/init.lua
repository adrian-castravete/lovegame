lg = love.graphics
lgb = lg.setBackgroundColor
lgp = lg.print

local mpath = ...

local class = require "mylove.class"
local LevelSelector = require(mpath .. ".levelselect")
local Level = require(mpath..".level")

local Game = class()

function Game:init()
	self.levSel = Level(10, 10)
	self.level = nil
	self.curScene = self.levSel
	
	self:_fwdCallbacks(self.curScene)
end

function Game.start()
	lgb(1,0,1)
end

function Game:setScene(to)
	self.curScene = to
	self:_fwdCallbacks(to)
end

function Game:_fwdCallbacks(to)
	for _, name in ipairs{"start", "update", "pressed", "released"} do
		self[name] = function (...)
			local fn = to[name]
			if fn then
				fn(to, ...)
				--lgb(0, 0, math.random())
			end
		end
	end
end

return Game()
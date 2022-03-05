local mpath = ...
mpath = mpath:gsub("%.[^%.]+$", "")
local class = require "mylove.class"
local Level = require(mpath .. ".level")

local LevelSelect = class()

function LevelSelect:init(game)
	game:setScene(Level(10, 10))
end

return LevelSelect

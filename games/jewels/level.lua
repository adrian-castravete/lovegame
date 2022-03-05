local mpath = (...):gsub("%.[^%.]+$", "")
local lg = love.graphics
local tiny = require "tiny"
local class = require "mylove.class"
local msg = require "mylove.messager"

local pieces = require(mpath .. ".piece")
local cursor = require(mpath .. ".cursor")

local Level = class {
	dirs = {
		left = {-1, 0},
		up = {0, -1},
		right = {1, 0},
		down = {0, 1},
	}
}

function Level:init(w, h)
	world = tiny.world()
	self.tinyWorld = world
	
	self.buttons = {}
	self.state = "break"
	
	msg.system(world)
	pieces.systems(world)
	cursor.systems()
	for j=1, h do
		for i=1, w do
			pieces.new(world, i, j)
		end
	end
end

function Level:update(dt)
	if self.state == "move" then
		self:handleInput()
	end
	
	lg.push()
	lg.translate(80, 20)
	self.tinyWorld:update(dt)
	lg.pop()
end

function Level:pressed(btn)
	local dir = self.dirs[btn]
	if dir then
		self.buttons[btn] = true
	end
end

function Level:released(btn)
	local dir = self.dirs[btn]
	if dir then
		self.buttons[btn] = false
	end
end

function Level:handleInput()
	for dir, disp in pairs(self.dirs) do
		if self.buttons[dir] then
			msg.send("cursor", cursor.move, disp)
		end
	end
end

return Level

local mpath = (...):gsub("%.[^%.]+", "")
local lg = love.graphics

local tiny = require "tiny"

local colors = {
	{1, 0, 0},
	{1, 0.67, 0},
	{1, 1, 0},
	{0, 1, 0},
	{0, 0.33, 1},
	{0.67, 0, 1},
}

local shapes = {}

for i=3, 8 do
	local o = {7, 0}
	for j=1, i do
		local a = math.pi * 2 * j / i
		o[#o+1] = math.cos(a) * 7
		o[#o+1] = math.sin(a) * 7
	end
	shapes[#shapes+1] = o
end

local elapsedTime = 0

local pieces = {}

function pieces.new(w, i, j)
	local e = {
		cx = i,
		cy = j,
		kind = "normal",
		color = math.random(1, 6),
		anim = math.random(),
	}
	
	w:add(e)
	
	return e
end

local DrawingSystem = {
	filter = tiny.filter("cx&cy&color"),
	preProcess = function (s, dt)
		elapsedTime = elapsedTime + dt
	end,
	process = function (s, e, dt)
		lg.setColor(colors[e.color])
		lg.push()
		lg.translate((e.cx - 0.5) * 16, (e.cy - 0.5) * 16)
		lg.rotate(math.sin(elapsedTime + e.anim * 6) * (e.anim + 2))
		lg.line(shapes[e.color])
		lg.pop()
	end,
	postProcess = function (dt)
		lg.setColor(1, 1, 1)
	end,
}

local systems = {
	DrawingSystem,
}

function pieces.systems(w)
	for _, s in ipairs(systems) do
		w:add(tiny.processingSystem(s))
	end
end

return pieces

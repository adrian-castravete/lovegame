local mpath = (...):gsub("%.[^%.]+$", "")

local class = require "mylove.class"
local spritesheet = require "mylove.spritesheet"

local wscreen = require(mpath .. ".wscreen")

local util = require "mylove.util"
local pprint = util.pprint
local pmap2 = util.pmap2

local gw, gh = 240, 159

local World = class()

local function dbgPMap(map, pal, dft)
	local h, w = #map, #map[1] or 0
	
	if not (w and h) then return end
	
	local lg = love.graphics
	local s = math.max(1, math.floor(math.min(gw / w, gh / h)))
	for j=1, h do
		for i=1, w do
			local x, y = i-1, j-1
			local c = map[j][i]
			lg.setColor(pal[c] or dft(c))
			lg.rectangle("fill", x*s, y*s, s, s)
		end
	end
	lg.setColor(1, 1, 1)
end

local function dbgDMap(map)
	local h, w = #map, #map[1] or 0
	
	if not (w and h) then return end
	
	local lg = love.graphics
	local ln = lg.line
	local s = math.max(1, math.floor(math.min(gw / w, gh / h)))
	lg.setColor(1, 1, 1)
	lg.setLineStyle("rough")
	for j=1, h do
		for i=1, w do
			local x, y = (i-1) * s + 0.5, (j-1) * s + 0.5
			local c = map[j][i]
			if x == 0.5 then
				ln(x, y, x, y + s)
			end
			if y == 0.5 then
				ln(x, y, x + s, y)
			end
			if bit.band(c, 4) == 0 then
				ln(x + s, y, x + s, y + s + 1)
			end
			if bit.band(c, 8) == 0 then
				ln(x, y + s, x + s + 1, y + s)
			end
		end
	end
end

-- Public {{{
function World:init(fileName, randomSeed, doStep)
	if randomSeed then
		math.randomseed(randomSeed)
	else
		math.randomseed(os.time())
		math.random()
		math.random()
		math.random()
	end

	local sprs = spritesheet.build {
		fileName = fileName,
	}
	self:_analyse(sprs.imageData)
	self:_walkDirMap(doStep)

	self:reset()
	self:showScreen(unpack(self.startPos))
end

function World:reset()
	local x, y = unpack(self.startPos)
	self.currentPos = nil
	self.lastVisited = {}
end

function World:showScreen(x, y)
	local cx, cy = x, y

	if self.currentPos then
		local cx, cy = unpack(self.currentPos)

		if cx == x and cy == y then
			return
		end
	end

	local dx, dy = x - cx, y - cy
	local anim = "fade"

	if math.abs(dx) + math.abs(dy) == 1 then
		anim = "slide"
	end

	local found, screen = 0, nil
	for pos, scr in ipairs(self.lastVisited) do
		if x == scr.x and y == scr.y then
			found = pos
			screen = scr
			break
		end
	end

	if screen then
		table.remove(self.lastVisited, found)
		table.insert(self.lastVisited, 1, screen)
		return screen
	end

	screen = wscreen.generate(self, x, y)
	table.insert(self.lastVisited, 1, screen)
	while #self.lastVisited > 10 do
		table.remove(self.lastVisited)
	end

	self.currentScreen = screen
	self.currentPos = {x, y}
end

function World:update(dt)
	if self.currentScreen then
		self.currentScreen:update(dt)
	end
	dbgPMap(self.pixelMap, self.palette, function (g) 
		if self.showAlones then
			return {1, 0.5, 0}
		end
		return self.palette[g.orig]
	end)
	dbgDMap(self.dirMap)
end

function World:released(btn)
	if btn == "left" then
		self.showAlones = true
	end
	if btn == "right" then
		self.showAlones = false
	end
end
-- }}}

-- Private {{{
function World:_analyse(idata)
	local firstPixel = {idata:getPixel(0, 0)}
	local palette = {firstPixel}
	local gmap = {}
	local pmap = {}
	local pcnt = {}

	-- extract palette
	idata:mapPixel(function (x, y, ...)
		local color = {...}

		local found = false
		local index = 0
		for j=1, #palette do
			local pcol = palette[j]

			local diff = false
			for i=1, 4 do
				if math.floor(color[i] * 255) ~= math.floor(pcol[i] * 255) then
					diff = true
					break
				end
			end

			if not diff then
				found = true
				index = j
				break
			end
		end

		if not found then
			index = #palette+1
			palette[index] = color
		end

		return ...
	end)

	for j=1, #palette-1 do
		for i=j+1, #palette do
			local a = 0
			local b = 0
			for k=1, 4 do
				a = a + palette[j][k]
				b = b + palette[i][k]
			end
			if a > b then
				palette[j], palette[i] = palette[i], palette[j]
			end
		end
	end

	idata:mapPixel(function (x, y, ...)
		local color = {...}

		local index = 0
		for j, palCol in ipairs(palette) do
			local found = true
			for i=1, 4 do
				if palCol[i] ~= color[i] then
					found = false
					break
				end
			end
			if found then
				index = j
				break
			end
		end

		if not pmap[y+1] then
			pmap[y+1] = {}
		end
		pmap[y+1][x+1] = index

		pcnt[index] = (pcnt[index] or 0) + 1

		return ...
	end)

	--local chMap = " ❖░▒▓█"
	--pmap2(pmap, nil, function (c)
	--	return chMap:sub(c, c)
	--end)

	-- find a starting point with the first color
	local w, h = idata:getDimensions()
	local sx, sy = nil
	while not sx do
		sx, sy = math.random(1, w), math.random(1, h)
		if pmap[sy][sx] ~= 1 then
			sx = nil
		end
	end

	self.palette = palette
	self.palCounts = pcnt
	self.pixelMap = pmap
	self.startPos = {sx, sy}
	self.width = w
	self.height = h
end

function World:_walkDirMap()
	local stacks = {{self.startPos}}

	local pmap = self.pixelMap
	local dmap = {}
	for j=1, self.height do
		dmap[j] = {}
		for i=1, self.width do
			dmap[j][i] = 0
		end
	end
	local cIndex = 1
	local border = {}

	local function walkStep(stack)
		local x, y = unpack(stack[#stack])
		local dirs = {}

		local function testDir(dx, dy, d, o)
			local nx, ny = x + dx, y + dy

			if nx < 1 or ny < 1 or nx > self.width or ny > self.height then
				return
			end
			if dmap[ny][nx] == 0 then
				if self.pixelMap[ny][nx] == cIndex then
					table.insert(dirs, {dx, dy, d, o})
				else
					table.insert(border, {x, y, dx, dy, d, o})
				end
			end
		end
		testDir(-1, 0, 1, 4)
		testDir(0, -1, 2, 8)
		testDir(1, 0, 4, 1)
		testDir(0, 1, 8, 2)

		if #dirs < 1 then
			table.remove(stack)
			return
		end

		local function addWalk(cdir, stack)
			local dx, dy, dir, odir = unpack(cdir)
			local nx, ny = x + dx, y + dy
			dmap[y][x] = dmap[y][x] + dir
			dmap[ny][nx] = odir
			table.insert(stack, {nx, ny})
		end

		if #dirs >= 3 and math.random() < 0.2 then
			for _, dir in ipairs(dirs) do
				local nstack = {}
				addWalk(dir, nstack)
				table.insert(stacks, nstack)
			end
		else
			addWalk(dirs[math.random(1, #dirs)], stack)
		end
	end

	local function step()
		if #stacks < 1 then
			if #border == 0 then
				return false
			end

			local chosen = math.random(1, #border)
			local x, y, dx, dy, dir, odir = unpack(table.remove(border, chosen))
			local nx, ny = x + dx, y + dy
			if dmap[ny][nx] > 0 then
				return true
			end
			stacks = {{{nx, ny}}}
			dmap[y][x] = dmap[y][x] + dir
			dmap[ny][nx] = odir
			cIndex = self.pixelMap[y][x]
		end
		for _, stack in ipairs(stacks) do
			walkStep(stack)
		end
		local nstacks = {}
		for _, stack in ipairs(stacks) do
			if #stack > 0 then
				table.insert(nstacks, stack)
			end
		end
		stacks = nstacks
		return true
	end

	while step() do end
	
	local function checkNear(i, j)
		local diff = nil
		local cnt = 0
		local function check(d, dx, dy)
			if bit.band(dmap[j][i], d) > 0 then
				cnt = cnt + 1
				local nd = pmap[j+dy][i+dx]
				if type(nd) ~= "number" then
					return
				end
				diff = pmap[j][i] - nd
			end
		end
		check(1, -1, 0)
		check(2, 0, -1)
		check(4, 1, 0)
		check(8, 0, 1)
		return diff and diff > 0 and cnt == 1
	end
	
	for j=1, self.height do
		for i=1, self.width do
			if checkNear(i, j) then
				pmap[j][i] = {
					kind = "alone",
					orig = pmap[j][i],
				}
			end
		end
	end

	self.dirMap = dmap
end
-- }}}

return World

-- vim: set fdm=marker:

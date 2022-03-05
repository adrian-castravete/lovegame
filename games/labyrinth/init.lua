local mpath = ...
local apath = mpath:gsub("%.", "/")

local World = require(mpath .. ".worldgen")

local overworld = nil

function start()
	overworld = World(apath .. "/assets/moon.png", 1)

end

function update(dt)
	overworld:update(dt)
end

function pressed(btn)
	if overworld.pressed then
		overworld:pressed(btn)
	end
end

function released(btn)
	if overworld.released then
		overworld:released(btn)
	end
end

return {
	start = start,
	update = update,
	pressed = pressed,
	released = released,
}

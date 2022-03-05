local tiny = require "tiny"

local msg = {
	messages = {},
}

local MessagingSystem = {
	process = function (e, dt)
		for key, msgs in pairs(msg.messages) do
			if e[key] then
				for _, m in ipairs(msgs) do
					m.func(e, dt, unpack(m.data))
				end
			end
		end
	end,
	postProcess = function (dt)
		msg.messages = {}
	end,
}

function msg.send(name, func, ...)
	if not msg.messages[name] then msg.messages[name] = {} end
	
	table.insert(msg.messages[name], {
		func = func,
		data = {...},
	})
end

function msg.system(world)
	world:add(tiny.processingSystem(MessagingSystem))
end

return msg
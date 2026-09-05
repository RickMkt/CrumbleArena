--!strict
-- Signal.lua
-- Implementação leve de sinal para comunicação interna entre serviços.

local Signal = {}
Signal.__index = Signal

function Signal.new()
	local self = setmetatable({}, Signal)
	self._handlers = {}
	return self
end

function Signal:Connect(fn: (...any) -> ())
	local handler = { fn = fn, connected = true }
	table.insert(self._handlers, handler)

	local handlers = self._handlers
	local connection = {}
	function connection.Disconnect()
		handler.connected = false
		for i = #handlers, 1, -1 do
			if handlers[i] == handler then
				table.remove(handlers, i)
				break
			end
		end
	end
	return connection
end

function Signal:Fire(...)
	local args = table.pack(...)
	-- copia para evitar problemas se um handler desconectar durante o fire
	local snapshot = table.clone(self._handlers)
	for _, handler in ipairs(snapshot) do
		if handler.connected then
			task.spawn(handler.fn, table.unpack(args, 1, args.n))
		end
	end
end

function Signal:DisconnectAll()
	for _, handler in ipairs(self._handlers) do
		handler.connected = false
	end
	self._handlers = {}
end

function Signal:Destroy()
	self:DisconnectAll()
end

return Signal

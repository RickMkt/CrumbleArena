--!strict
-- Maid.lua
-- Pequeno utilitário para limpar conexões/instâncias/funções.
-- Inspirado no padrão clássico Quenty/Maid, simplificado para o MVP.

local Maid = {}
Maid.__index = Maid

export type MaidTask =
	RBXScriptConnection
	| Instance
	| { Destroy: (any) -> () }
	| { Disconnect: (any) -> () }
	| () -> ()

function Maid.new()
	local self = setmetatable({}, Maid)
	self._tasks = {}
	return self
end

function Maid:GiveTask(task: MaidTask): MaidTask
	if task == nil then
		return task
	end
	table.insert(self._tasks, task)
	return task
end

function Maid:GivePromise(promiseLike)
	-- Espaço reservado para integração futura com promises.
	return self:GiveTask(promiseLike)
end

local function cleanupTask(task)
	if typeof(task) == "RBXScriptConnection" then
		task:Disconnect()
	elseif typeof(task) == "Instance" then
		task:Destroy()
	elseif typeof(task) == "function" then
		task()
	elseif typeof(task) == "table" then
		if typeof(task.Disconnect) == "function" then
			task:Disconnect()
		elseif typeof(task.Destroy) == "function" then
			task:Destroy()
		end
	end
end

function Maid:DoCleaning()
	local tasks = self._tasks
	self._tasks = {}
	for i = #tasks, 1, -1 do
		local ok, err = pcall(cleanupTask, tasks[i])
		if not ok then
			warn("[Maid] cleanup error:", err)
		end
	end
end

Maid.Destroy = Maid.DoCleaning
Maid.Cleanup = Maid.DoCleaning

return Maid

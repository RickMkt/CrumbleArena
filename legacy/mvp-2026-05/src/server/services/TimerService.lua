--!strict
-- TimerService.lua
-- Cria timers controlados que podem ser cancelados.

local TimerService = {}

local activeTimers: { [number]: boolean } = {}
local nextId = 0

-- Cria um timer regressivo. Chama onTick a cada segundo com o tempo restante,
-- e onComplete quando termina (somente se não foi cancelado).
function TimerService.startCountdown(seconds: number, onTick: ((number) -> ())?, onComplete: (() -> ())?)
	nextId += 1
	local id = nextId
	activeTimers[id] = true

	task.spawn(function()
		local remaining = math.max(0, math.floor(seconds))
		while remaining > 0 do
			if not activeTimers[id] then
				return
			end
			if onTick then
				onTick(remaining)
			end
			task.wait(1)
			remaining -= 1
		end
		if not activeTimers[id] then
			return
		end
		if onTick then
			onTick(0)
		end
		activeTimers[id] = nil
		if onComplete then
			onComplete()
		end
	end)

	return {
		id = id,
		cancel = function()
			activeTimers[id] = nil
		end,
	}
end

-- Aguarda até `predicate()` retornar true ou estourar timeout. Retorna true se o
-- predicate ficou satisfeito, false se estourou o timeout.
function TimerService.waitUntil(predicate: () -> boolean, timeout: number, pollInterval: number?): boolean
	local interval = pollInterval or 0.1
	local elapsed = 0
	while elapsed < timeout do
		if predicate() then
			return true
		end
		task.wait(interval)
		elapsed += interval
	end
	return predicate()
end

return TimerService

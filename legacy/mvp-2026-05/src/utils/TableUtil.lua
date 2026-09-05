--!strict
-- TableUtil.lua
-- Helpers de tabela usados em vários serviços.

local TableUtil = {}

function TableUtil.count<K, V>(t: { [K]: V }): number
	local n = 0
	for _ in pairs(t) do
		n += 1
	end
	return n
end

function TableUtil.shallowCopy<K, V>(t: { [K]: V }): { [K]: V }
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = v
	end
	return copy
end

function TableUtil.values<K, V>(t: { [K]: V }): { V }
	local out = {}
	for _, v in pairs(t) do
		table.insert(out, v)
	end
	return out
end

function TableUtil.keys<K, V>(t: { [K]: V }): { K }
	local out = {}
	for k in pairs(t) do
		table.insert(out, k)
	end
	return out
end

function TableUtil.findFirst<V>(arr: { V }, predicate: (V) -> boolean): V?
	for _, v in ipairs(arr) do
		if predicate(v) then
			return v
		end
	end
	return nil
end

function TableUtil.filter<V>(arr: { V }, predicate: (V) -> boolean): { V }
	local out = {}
	for _, v in ipairs(arr) do
		if predicate(v) then
			table.insert(out, v)
		end
	end
	return out
end

function TableUtil.shuffle<V>(arr: { V }): { V }
	local copy = table.clone(arr)
	for i = #copy, 2, -1 do
		local j = math.random(1, i)
		copy[i], copy[j] = copy[j], copy[i]
	end
	return copy
end

return TableUtil

local old_table = table
local table = {}
setmetatable(table, old_table)
old_table.__index = old_table

function table.foreach(t, f)
  for i, v in pairs(t) do
    f(v, i)
  end
end

function table.reverse(t)
	local len = #t
	for i = len - 1, 1, -1 do
		t[len] = table.remove(t, i)
	end
end

function table.ripairs(t)
	return function(t, i)
		i = i - 1
		if i ~= 0 then
			return i, t[i]
		end
	end, t, #t + 1
end

return table

local Prototype = require 'engine.Prototype'

---@class Callbackmanager
---@field callbacks table
local Callbackmanager = Prototype:clone("Callbackmanager")

function Callbackmanager:init()
	self.callbacks = {}
	return self
end

---Declares an id as present. This has to be done before register can be used and allows for runtime checking of incorrect callback usage.
---@param name string
---@return Callbackmanager
function Callbackmanager:declare(name)
	assert(not self.callbacks[name], "Callbackmanager:declare : Callback already exists: " .. name)
	self.callbacks[name] = {}
	return self
end

---comment
---@param name string
---@param f function
---@param p1 any
---@param ... unknown
---@return Callbackmanager
function Callbackmanager:register(name, f, indexed_by_table, default_params)
	assert(f, "Callback requires function.")
	assert(self.callbacks[name], "Callbackmanager:register : No such callback: " .. name)
	table.insert(self.callbacks[name], { f = f, params = default_params or {}, indexed_by_table = indexed_by_table,})
	return self
end
--TODO email antworten hinzufügen
function Callbackmanager:call(name, params_new)
  assert(type(params_new) == "table", "Callbackmanager:call : params_new has to be a table.")
	if self.callbacks[name] then
		for i, c in ipairs(self.callbacks[name]) do
			c.params.__call = c.params
			setmetatable(params_new, c.params)
			if c.indexed_by_table then
				self:callByTable(c, params_new)
			else
				self:callByIndex(c, params_new)
			end
		end
	end
end

function Callbackmanager:callByTable(callback, params_new)
	callback.f(params_new)
end

function Callbackmanager:callByIndex(callback, params_new)
	callback.f(params_new[1], params_new[2], params_new[3], params_new[4], params_new[5], params_new[6], params_new[7], params_new[8], params_new[9])
end

return Callbackmanager

---@class Prototype
---@field type_name string
---@field is boolean Prototype inheritance can be checked by is<TypeName>
local Prototype = {}
Prototype.__index = Prototype

---Creates a clone with self as metatable.
---@param name string
---@return table newInstance
---@overload fun(): table
function Prototype:clone(name)
	local new_instance = {}
	setmetatable(new_instance, self)

	new_instance.__index = new_instance

	new_instance.type_name = name or new_instance:super():type()

	new_instance["is" .. new_instance.type_name] = true

	return new_instance
end

---Returns the name as if it was a type. Clones will have the same type as their parent.
---@return string
function Prototype:type()
	return self.type_name
end

---Returns the parent of the Prototype. The parent is usually the metatable.
---@return table
function Prototype:super()
	return getmetatable(self)
end

---Initializes self as Prototype.
---@return Prototype
function Prototype:init(...)
	return self:init_modules(...)
end

---Helper function that takes care of cloning and initializing
---@param ... unknown
---@return unknown
function Prototype:new(...)
	return self:clone():init(...)
end

function Prototype:init_modules(...)
  if self.hasCallbacks then
    self.callbacks = require 'engine.modules.Callbackmanager':new()
  end
  if self.hasContents then
    self.contents = require 'engine.modules.Contentmanager':new()
  end
  if self.hasJobs then
    self.jobs = require 'engine.modules.Jobmanager':new()
  end
  if self.hasSerialization then
    self.serialization = require 'engine.modules.Serializationmanager':new()
  end
	return self
end

return Prototype

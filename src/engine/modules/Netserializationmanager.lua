local Super = require 'engine.Prototype'
local Self = Super:clone("Netserializationmanager")

function stringToTable(str)
  local func, err = load("return " .. str)
  if not func then
      error("Failed to deserialize table: " .. err)
  end
  return func()
end


function tableToString(tbl, indent, visited)
  visited = visited or {}
  indent = indent or 0
  if tbl.isPrototype then
    error("Cant transform Prototype or similar to string. Try calling serialize() on it.")
  end
  if visited[tbl] then
    error_here()
    return "?"--"<circular reference>"
  end
  visited[tbl] = true

  local indentStr = string.rep("  ", indent)
  local result = "{\n"

  

  for key, value in pairs(tbl) do

    local formattedKey = type(key) == "string" and string.format("[\"%s\"]", key) or string.format("[%s]", tostring(key))
    if type(value) == "table" then
      local t = value
      if value.hasSerialization then
        t = value:serialize()
      end
      result = result .. string.format("%s%s = %s,\n", indentStr .. "  ", formattedKey, tableToString(t, indent + 1, visited))
    elseif type(value) == "string" then
      result = result .. string.format("%s%s = \"%s\",\n", indentStr .. "  ", formattedKey, value)
    else
      result = result .. string.format("%s%s = %s,\n", indentStr .. "  ", formattedKey, tostring(value))
    end
  end

  result = result .. indentStr .. "}"
  visited[tbl] = nil
  return result
end




function Self:init()
  Super.init(self)

  self.vals = {}
  self._requiresSync = true
  self.vals._netID = uuid()
  self.syncTime = 0.01
  self.syncTimer = 0
  
  return self
end

function Self:update(dt)
  self.syncTimer = self.syncTimer + dt
end

function Self:setSyncTime(t)
  self.syncTime = t  
end

function Self:serialize()
  self.vals._NET_TYPE = "update"
  return self.vals
end

function Self:deserialize(raw)
  self.vals = raw
  self:sync()
end

function Self:requiresSync()
  return self._requiresSync and self.syncTimer >= self.syncTime 
end

function Self:sync()
  self._requiresSync = false
  self.syncTimer = 0
end


return Self



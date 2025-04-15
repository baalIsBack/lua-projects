local Super = require 'engine.Prototype'
local Self = Super:clone("Savemanager")
local binser = require 'lib.binser'
--require 'applications.dummy.Mail'

function Self:init(args)
  self.main = args.main
  self.hasCallbacks = true
  Super.init(self, args)

  self:resetValues()
  
  
  
	return self
end

function Self:resetValues()
  self.main.timedmanager.time = 0


end

local function tableToString(tbl, indent, visited)
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

local function saveTableToFile(filename, tbl)
  local fileContent = "return " .. tableToString(tbl)
  local success, message = love.filesystem.write(filename, fileContent)
  if success then
      print("Table successfully saved to " .. filename)
  else
      print("Failed to save table: " .. message)
  end
end

local function loadTableFromFile(filename)
  if love.filesystem.getInfo(filename) then
    local chunk, err = love.filesystem.load(filename)
    if chunk then
      local data = chunk()
      if type(data) == "table" then
        return data
      else
        print("Error: Loaded data is not a table.")
      end
    else
      print("Error loading file: " .. err)
    end
  else
    print("File does not exist: " .. filename)
  end
  return nil
end






function Self:resetSave()
  self:resetValues()
  self:finalize()
end
function Self:save()
  local dummy = {}
  dummy.id = self.id
  dummy.flags = self.main.flags
  dummy.files = self.main.files
  dummy.values = self.main.values
  dummy.mails = self.main.mails
  dummy.terminal = self.main.terminal
  dummy.time = self.main.timedmanager.time
  dummy.notes = self.main.notes
  dummy.apps = self.main.apps
  dummy.contacts = self.main.contacts
  saveTableToFile("save.dat", dummy)
end



function Self:load()
  local master = loadTableFromFile("save.dat")
  local firstTime = false
  if not master then
    self:save()
    master = loadTableFromFile("save.dat")
    firstTime = true
  end

  self:resetValues()
  self.id = master.id or self.id
  self.flags = master.flags or self.flags
  self.files = master.files or self.files
  self.values = master.values or self.values
  self.apps = master.apps or self.apps
  self.contacts = master.contacts or self.contacts
  self.main.timedmanager.time = master.time or self.main.timedmanager.time
  

  self.main.notes:deserialize(master.notes)
  self.main.terminal:deserialize(master.terminal)
  self.main.mails:deserialize(master.mails)
  self.main.flags:deserialize(master.flags)
  self.main.files:deserialize(master.files)
  self.main.values:deserialize(master.values or {})
  self.main.apps:deserialize(master.apps or {})
  self.main.contacts:deserialize(master.contacts or {})

  return firstTime
end

function Self:finalize()
  if not self:load() then
    self.main.terminal.log = {}
    return
  end
  print("first time")

  self.main.apps:installByAppName("terminal")
  self.main.apps:installByAppName("mail")
  self.main.mails:addMailFromID(1)
  
  self:save()
end

return Self

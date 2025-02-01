local Super = require 'engine.Prototype'
local Self = Super:clone("Savemanager")
local binser = require 'lib.binser'
--require 'src.applications.dummy.Mail'

function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)
  self.main = args.main

  self:resetValues()
  
  
  
	return self
end

function Self:resetValues()
  self.flags = {}
  self.main.timedmanager.time = 0


end

function Self:emit(event, value)
  self.flags[event] = value
end


function Self:checkEvents()
  if self.flags["entry_mail_read"] and self.main.timedmanager.time >= self.flags["entry_mail_read"] and not self.flags["entry_mail_read".."_HAPPENED"] then
    self.main.mails:addMailFromID(2)
    self:emit("entry_mail_read".."_HAPPENED", true)
  end
end

local function tableToString(tbl, indent, visited)
  visited = visited or {}
  indent = indent or 0
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
  dummy.flags = self.flags
  dummy.mails = self.main.mails
  dummy.terminal = self.main.terminal
  dummy.time = self.main.timedmanager.time
  dummy.notes = self.main.notes
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
  self.main.timedmanager.time = master.time or self.main.timedmanager.time
  

  self.main.notes:deserialize(master.notes)
  self.main.terminal:deserialize(master.terminal)
  self.main.mails:deserialize(master.mails)

  return firstTime
end

function Self:finalize()
  if not self:load() then
    self.main.terminal.log = {}
    return
  end
  print("first time")

  self.main.terminal:install("terminal")
  self.main.terminal:install("mail")
  self.main.mails:addMailFromID(1)
  self.main.terminal.log = {}
  
  self:save()
end

return Self

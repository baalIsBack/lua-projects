local Super = require 'engine.Prototype'
local Self = Super:clone("Gamestate")
local binser = require 'lib.binser'
require 'src.applications.dummy.Mail'

function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)
  self.main = args.main

  self.callbacks:declare("update")
  self:resetValues()
  
  
  
	return self
end

function Self:resetValues()
  self.id = 1
  self.flags = {}
  self.mails = {}
  self.apps_installed = {}
  self.main.timedmanager.time = 0

end

function Self:emit(event, value)
  self.flags[event] = value
end


function Self:checkEvents()
  if self.flags["entry_mail_read"] and self.main.timedmanager.time >= self.flags["entry_mail_read"] and not self.flags["entry_mail_read".."_HAPPENED"] then
    self.main.gamestate:addMailFromID(2)
    self:emit("entry_mail_read".."_HAPPENED", true)
  end
end

local function tableToString(tbl, indent, visited)
  visited = visited or {}
  indent = indent or 0
  if visited[tbl] then
    return "<circular reference>"
  end
  visited[tbl] = true

  local indentStr = string.rep("  ", indent)
  local result = "{\n"

  for key, value in pairs(tbl) do
      local formattedKey = type(key) == "string" and string.format("[\"%s\"]", key) or string.format("[%s]", tostring(key))

      if type(value) == "table" then
          result = result .. string.format("%s%s = %s,\n", indentStr .. "  ", formattedKey, tableToString(value, indent + 1, visited))
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

function Self:getID()
  local id = self.id
  id = id + 1
  return id
end


function Self:addMailFromID(mail_prototype_id)
  local mail = Mail(mail_prototype_id, self:getID(), false, false)
  table.insert(self.mails, mail)
  self.main.mails:makeMail(mail)
  
  return mail
end

function Self:addMail(mail)
  table.insert(self.mails, mail)
  self.main.mails:makeMail(mail)
  
  return mail
end

function Self:installApp(app_id)
  if CONTAINS(self.apps_installed, app_id) then
    return false
  end
  table.insert(self.apps_installed, app_id)
  if self.main.terminal then
    self.main.terminal:install(app_id)
  end
  self.main["install_"..app_id](self.main, app_id)
  return true
end

function Self:uninstallApp(app_id)
  if not REMOVE(self.apps_installed, app_id) then
    return false
  end
  if self.main.terminal then
    self.main.terminal:uninstall(app_id)
  end
  self.main["uninstall_"..app_id](self.main, app_id)
  return true
end

function Self:readMail(mail)
  self.main.mails:readMail(mail)
  return true
end

function Self:replyMail(mail, message)
  self.main.mails:replyMail(mail, message)
end

function Self:resetSave()
  self:resetValues()
  self:finalize()
end
function Self:save()
  local dummy = {}
  dummy.id = self.id
  dummy.flags = self.flags
  dummy.mails = self.mails
  dummy.apps_installed = self.apps_installed
  dummy.time = self.main.timedmanager.time
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
  
  for index, value in ipairs(master.apps_installed) do
    self:installApp(value)
  end
  for index, value in ipairs(master.mails) do
    self:addMail(Load_Mail(value))
  end
  return firstTime
end

function Self:finalize()
  if not self:load() then
    self.main.terminal.log = {}
    print("been here")
    return
  end
  print("first time")

  self:installApp("terminal")
  self:installApp("mail")
  self:addMailFromID(1)
  self.main.terminal.log = {}
  
  self:save()
end

function Self:update(dt)
  self.callbacks:call("update", {self, dt})
  self:checkEvents()
end

return Self

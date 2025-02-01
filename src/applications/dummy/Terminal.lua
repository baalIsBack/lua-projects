local Super = require 'engine.Prototype'
local Self = Super:clone("Terminal")

APP_LIST = {}
APP_LIST["calc"] = {
  installTime = 4,
}
APP_LIST["terminal"] = {
  installTime = 1,
}
APP_LIST["mail"] = {
  installTime = 3,
}
APP_LIST["editor"] = {
  installTime = 2,
}
APP_LIST["files"] = {
  installTime = 2,
}
APP_LIST["processes"] = {
  installTime = 5,
}
APP_LIST["ressources"] = {
  installTime = 0.1,
}

function Self:init(args)
  self.hasSerialization = true
  Super.init(self)
  self.main = args.main
  self.window = nil
  self.log = {}

  self.apps_installed = {}

  return self
end

function Self:serialize()
  local t = {
    apps_installed = self.apps_installed
  }
  return t
end

function Self:deserialize(raw)
  for index, value in ipairs(raw.apps_installed) do
    self:install(value)
  end
  for index, value in ipairs({
    "calc",
    "terminal",
    "mail",
    "editor",
    "files",
    "processes",
    "ressources"
  }) do
    self:install(value)
  end
  return self
end

function Self:execute(command)
  
  self:appendLog("> " .. command)
  local command_parts = {}
  for part in command:gmatch("%S+") do
    table.insert(command_parts, part)
  end
  if command_parts[1] == "echo" or command_parts[1] == "print" then
    self:appendLog(table.concat(command_parts, " ", 2))
  elseif command_parts[1] == "clear" then
    self.log = {}
  elseif command_parts[1] == "help" then
    self:appendLog("Available commands:")
    self:appendLog("echo <text>")
    self:appendLog("print <text>")
    self:appendLog("clear")
    self:appendLog("help")
    self:appendLog("exit")
  elseif command_parts[1] == "color" then
    self.window.font_color = {tonumber(command_parts[2]) or 1, tonumber(command_parts[3]) or 1, tonumber(command_parts[4]) or 1}
  elseif command_parts[1] == "exit" then
    self:appendLog("Exiting terminal...")
    self.window.visibleAndActive = false
  elseif command_parts[1] == "install" then
    self:initiateInstall(command_parts[2])
  elseif command_parts[1] == "uninstall" then
    self:initiateUninstall(command_parts[2])
  elseif command_parts[1] == "save" then
    self.main.gamestate:save()
  elseif command_parts[1] == "reset" then
    self.main.gamestate:resetSave()
  elseif command_parts[1] == "debugmail" then
    self.main.timedmanager:after(0.2, function() self.main.gamestate:addMailFromID(3) end)
  else
    self:appendLog("Unknown command: " .. (command_parts[1] or ""))
  end
  
end

function Self:appendLog(msg)
  table.insert(self.log, msg)
end

function Self:initiateInstall(app_name)
  if APP_LIST[app_name] == nil then
    self:appendLog("Unknown program: " .. app_name)
    return
  end
  if CONTAINS(self.apps_installed, app_name) then
    self:appendLog(app_name .. " is already installed.")
    return
  end
  self:appendLog("Installing ".. app_name .."...")
  self.window.accepting_input = false
  local installTime = APP_LIST[app_name].installTime * math.random(0.9*10000, 1.4*10000)/10000
  self.main.timedmanager:after(installTime, function()
    self:install(app_name)
    self.window.accepting_input = true
  end)
end

function Self:install(app_name)
  if APP_LIST[app_name] == nil then
    self:appendLog("Unknown program: " .. app_name)
    return
  end
  if CONTAINS(self.apps_installed, app_name) then
    self:appendLog("Error during installation.")
    return
  end
  table.insert(self.apps_installed, app_name)
  self.main["install_"..app_name](self.main, app_name)
  self:appendLog("Success! " .. app_name .. " was installed.")
end

function Self:initiateUninstall(app_name)
  if APP_LIST[app_name] == nil then
    self:appendLog("Unknown program: " .. app_name)
    return
  end
  if not CONTAINS(self.apps_installed, app_name) then
    self:appendLog("Unknown program: " .. app_name)
    return
  end
  self:appendLog("Uninstalling ".. app_name .."...")
  self.window.accepting_input = false
  local uninstallTime = APP_LIST[app_name].installTime * math.random(0.9*10000, 1.4*10000)/10000
  self.main.timedmanager:after(uninstallTime, function()
    self:uninstall(app_name)
    self.window.accepting_input = true
  end)
end

function Self:uninstall(app_name)
  if APP_LIST[app_name] == nil then
    self:appendLog("Unknown program: " .. app_name)
    return
  end
  if not CONTAINS(self.apps_installed, app_name) then
    self:appendLog("Error during deinstallation.")
    return
  end
  REMOVE(self.apps_installed, app_name)
  self.main["uninstall_"..app_name](self.main, app_name)
  self:appendLog("Success! " .. app_name .. " was uninstalled.")
end

function Self:getLogs(last_n_elements)
  local logs = {}
  for i = #self.log, #self.log-last_n_elements+1, -1 do
    table.insert(logs, self.log[i])
  end
  return logs
end

return Self
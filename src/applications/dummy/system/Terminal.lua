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
APP_LIST["stat"] = {
  installTime = 0.1,
}
APP_LIST["contacts"] = {
  installTime = 0.1,
}
APP_LIST["antivirus"] = {
  installTime = 0.1,
}

function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  Super.init(self)
  self.window = nil
  self.log = {}

  return self
end

function Self:serialize()
  local t = {
  }
  return t
end

function Self:deserialize(raw)
  
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
  elseif command_parts[1] == "info" then
    self:appendLog("Employee ID: " .. string.format("%05d", self.main.values:get("employee_id")))
    self:appendLog("Employee Name: ..." .. "REDACTED")
    self:appendLog("Employee Birthday: ..." .. "REDACTED")
    self:appendLog("Employee Adress: ..." .. "REDACTED")
  elseif command_parts[1] == "color" then
    self.window.font_color = {tonumber(command_parts[2]) or 1, tonumber(command_parts[3]) or 1, tonumber(command_parts[4]) or 1}
  elseif command_parts[1] == "exit" then
    self:appendLog("Exiting terminal...")
    self.window.visibleAndActive = false
  elseif command_parts[1] == "install" then
    self:initiateInstall(command_parts[2])
  elseif command_parts[1] == "uninstall" then
    self:initiateUninstall(command_parts[2])
  elseif command_parts[1] == "open" then
    if self.main.apps:isInstalled(command_parts[2]) then
      self.main.processes:getProcess(command_parts[2]):open()
      self:appendLog("Opened " .. command_parts[2])
    else
      self:appendLog("Could not open program: " .. command_parts[2])
    end
  elseif command_parts[1] == "diskspace" then
    self:appendLog(self.main.values:get("rom_current_used") .. "MB/" .. self.main.values:get("rom_total_size") .. "MB")
  elseif command_parts[1] == "close" then
    if self.main.processes:isActive(command_parts[2]) then
      self.main.processes:getProcess(command_parts[2]):close()
      self:appendLog("Closed " .. command_parts[2])
    else
      self:appendLog("Could not close program: " .. command_parts[2])
    end
  elseif command_parts[1] == "save" then
    self.main.gamestate:save()
  elseif command_parts[1] == "popup" then
    local newPopupWindow = require 'applications.dummy.gui.windows.PopupWindow':new{
      main = self.main,
      title = "ERROR",
      text = command_parts[2] or "",
      width = 200,
      height = 100,
      x = 50, y = 50,
    }
    self.main:insert(newPopupWindow)
  elseif command_parts[1] == "reset" then
    self.main.gamestate:resetSave()
  elseif command_parts[1] == "debugmail" then
    self.main.timedmanager:after(0.2, function() self.main.gamestate:addMailFromID(3) end)
  elseif self.main.processes:isActive(command_parts[1]) then
    self.main.processes:getProcess(command_parts[1]):execute(self, command_parts[2])
  else
    self:appendLog("Unknown command: " .. (command_parts[1] or ""))
  end
  
end

function Self:appendLog(msg)
  table.insert(self.log, msg)
end

function Self:initiateInstall(app_name)
  if not self.main.values:exists("install_time_" .. app_name) then
    self:appendLog("Unknown program: " .. app_name)
    return
  end
  if self.main.apps:isInstalled(app_name) then
    self:appendLog(app_name .. " is already installed.")
    return
  end
  self:appendLog("Installing ".. app_name .."...")
  self.window.accepting_input = false
  local installTime = self.main.values:exists("install_time_" .. app_name) * math.random(0.9*10000, 1.4*10000)/10000
  self.main.timedmanager:after(installTime, function()
    self:install(app_name)
    self.window.accepting_input = true
  end)
end

function Self:install(app_name)
  if not self.main.values:exists("install_time_" .. app_name) then
    self:appendLog("Unknown program: " .. app_name)
    return
  end
  if self.main.apps:isInstalled(app_name) then
    self:appendLog("Error during installation.")
    return
  end
  self.main.flags:set("installed_"..app_name, true)
  self.main.apps:install(app_name)
  --self.main["install_"..app_name](self.main, app_name)
  self:appendLog("Success! " .. app_name .. " was installed.")
end

function Self:initiateUninstall(app_name)
  if not self.main.values:exists("install_time_" .. app_name) then
    self:appendLog("Unknown program: " .. app_name)
    return
  end
  if not self.main.apps:isInstalled(app_name) then
    self:appendLog("Unknown program: " .. app_name)
    return
  end
  self:appendLog("Uninstalling ".. app_name .."...")
  self.window.accepting_input = false
  local uninstallTime = self.main.values:get("install_time_" .. app_name) * math.random(0.9*10000, 1.1*10000)/10000
  self.main.timedmanager:after(uninstallTime, function()
    self:uninstall(app_name)
    self.window.accepting_input = true
  end)
end

function Self:uninstall(app_name)
  if not self.main.values:exists("install_time_" .. app_name) then
    self:appendLog("Unknown program: " .. app_name)
    return
  end
  if not self.main.apps:isInstalled(app_name) then
    self:appendLog("Error during deinstallation.")
    return
  end
  self.main.apps:uninstall(app_name)
  --self.main["uninstall_"..app_name](self.main, app_name)
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
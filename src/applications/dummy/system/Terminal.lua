local Super = require 'engine.Prototype'
local Self = Super:clone("Terminal")

local a = require 'applications.dummy.system.CommandDefinitions'
local COMMANDS, PROGRAM_COMMANDS = a[1], a[2]

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

function Self:execute(command, silent)
  if not silent then
    self:appendLog("> " .. command)
  end
  local command_parts = {}
  for part in command:gmatch("%S+") do
    table.insert(command_parts, part)
  end

  for i, command in ipairs(COMMANDS) do
    if command_parts[1] == command.command then
      command.effect(self, command_parts)
      return
    end
    for j, alias in ipairs(command.aliases) do
      if command_parts[1] == alias then
        command.effect(self, command_parts)
        return
      end
    end
  end
  if PROGRAM_COMMANDS[command_parts[1]] then
    for i, command in ipairs(PROGRAM_COMMANDS[command_parts[1]]) do
      if command_parts[2] == command.command then
        command.effect(self, command_parts)
        return
      end
      for j, alias in ipairs(command.aliases) do
        if command_parts[2] == alias then
          command.effect(self, command_parts)
          return
        end
      end
    end
  end

  self:appendLog("Unknown command: " .. (command or ""))
  
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
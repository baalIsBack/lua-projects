local Super = require 'engine.Prototype'
local Self = Super:clone("Processes")



function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  self.hasContents = true
  self.hasCallbacks = true
  Super.init(self)
  
  self.callbacks:declare("onOpen")
  self.callbacks:declare("onClose")

  --self:loadApps()

  return self
end


function Self:loadApps()
  self.stat = self:makeWindow('applications.dummy.gui.windows.StatWindow', 300, 300)
  self.calc = self:makeWindow('applications.dummy.gui.windows.CalcWindow', 300, 300)
  self.mail = self:makeWindow('applications.dummy.gui.windows.MailWindow', 200, 200)
  self.terminal = self:makeWindow('applications.dummy.gui.windows.TerminalWindow', 250, 250)
  self.editor = self:makeWindow('applications.dummy.gui.windows.EditorWindow', 250, 250)
  self.fileserver = self:makeWindow('applications.dummy.gui.windows.FileServerWindow', 250, 250)
  self.filemanager = self:makeWindow('applications.dummy.gui.windows.FileManagerWindow', 250, 250)
  self.processes = self:makeWindow('applications.dummy.gui.windows.ProcessesWindow', 250, 250)
  self.ressources = self:makeWindow('applications.dummy.gui.windows.RessourcesWindow', 250, 250)
  --self.antivirus = self:makeWindow('applications.dummy.gui.windows.AntivirusWindow', 250, 250)
  self.network = self:makeWindow('applications.dummy.gui.windows.NetworkWindow', 250, 250)
  self.patcher = self:makeWindow('applications.dummy.gui.windows.PatcherWindow', 250, 250)
  self.debug = self:makeWindow('applications.dummy.gui.windows.DebugWindow', 250, 250)
  self.contacts = self:makeWindow('applications.dummy.gui.windows.ContactsWindow', 250, 250)
  self.battle = self:makeWindow('applications.dummy.gui.windows.BattleWindow', 250, 250)
  self.softcenter = self:makeWindow('applications.dummy.gui.windows.SoftwareCenterWindow', 250, 250)


  self.main.terminal.window = self.terminal

  self.contents:insert(self.stat)
  self.contents:insert(self.calc)
  self.contents:insert(self.mail)
  self.contents:insert(self.terminal)
  self.contents:insert(self.editor)
  self.contents:insert(self.fileserver)
  self.contents:insert(self.filemanager)
  self.contents:insert(self.processes)
  self.contents:insert(self.ressources)
  --self.contents:insert(self.antivirus)
  self.contents:insert(self.network)
  self.contents:insert(self.patcher)
  self.contents:insert(self.debug)
  self.contents:insert(self.contacts)
  self.contents:insert(self.battle)
  self.contents:insert(self.softcenter)
end


function Self:makeWindow(window_type_name, x, y)
  local w, h = 0, 0
  local _x = math.random(w/2 + 50, 640 - w/2 - 50)
  local _y = math.random(h/2 + 50, 480 - h/2 - 50)
  
  return require(window_type_name):new{
    main = self.main,
    x = x or _x,
    y = y or _y,
    _isReal = false,
  }
end

function Self:getActiveProcesses()
  local list = {}
  for i, process in ipairs(self.contents.content_list) do
    if process:isReal() then
      table.insert(list, process)
    end
  end
  return list
end



function Self:canOpenProcessPrototype(app_window_prototype)
  -- Check if app_window is nil
  if not app_window_prototype then
    print("Warning: Attempted to check if nil window can be opened")
    return false
  end
  
  -- Check if the window has an INTERNAL_NAME
  if not app_window_prototype.INTERNAL_NAME then
    print("Warning: Window has no INTERNAL_NAME: " .. tostring(app_window_prototype))
    return false
  end
  
  local ram_usage_current = self.main.values:get("ram_usage_current")
  local ram_usage = self.main.values:get("ram_usage_"..app_window_prototype.INTERNAL_NAME)
  local ram_usage_total = self.main.values:get("ram_usage_total")
  return (ram_usage_current + ram_usage <= ram_usage_total+0.0001)
end

function Self:canOpenProcess(app_window)
  -- Check if app_window is nil
  if not app_window then
    print("Warning: Attempted to check if nil window can be opened")
    return false
  end
  
  -- Check if the window has an INTERNAL_NAME
  if not app_window.INTERNAL_NAME then
    print("Warning: Window has no INTERNAL_NAME: " .. tostring(app_window))
    return false
  end
  
  local ram_usage_current = self.main.values:get("ram_usage_current")
  local ram_usage = self.main.values:get("ram_usage_"..app_window.INTERNAL_NAME)
  local ram_usage_total = self.main.values:get("ram_usage_total")
  return (ram_usage_current + ram_usage <= ram_usage_total+0.0001)
end

function Self:openProcess(app_window)
  print("deep", self:canOpenProcess(app_window) , self:canOpenProcess(app_window) and not app_window:isOpen())
  if self:canOpenProcess(app_window) and not app_window:isOpen() then
    self.main.values:inc("ram_usage_current", self.main.values:get("ram_usage_"..app_window.INTERNAL_NAME))
    self.callbacks:call("onOpen", {self, app_window})
    app_window:activate()
    app_window:bringToFront()
    app_window:setFocus()
    return true
  end
  return false
end

function Self:killProcess(app_window)
  for i, process in ipairs(self.contents.content_list) do
    if process == app_window then
      table.remove(self.contents.content_list, i)
      break
    end
  end
  self.main.values:inc("ram_usage_current", -self.main.values:get("ram_usage_"..app_window.INTERNAL_NAME))
  self.callbacks:call("onClose", {self, app_window})
  app_window:close()
end

function Self:closeProcess(app_window)
  for i, process in ipairs(self.contents.content_list) do
    if process == app_window then
      table.remove(self.contents.content_list, i)
      break
    end
  end
  self.main.values:inc("ram_usage_current", -self.main.values:get("ram_usage_"..app_window.INTERNAL_NAME))
  self.callbacks:call("onClose", {self, app_window})
  app_window:close()
end

function Self:isActive(name)
  return self:getProcess(name) ~= nil
end

function Self:getProcess(name)
  for i, process in ipairs(self.contents.content_list) do
      print("IS? ", process.INTERNAL_NAME, name)
    if process.INTERNAL_NAME == name then
      return process
    end
  end
  print("COULD NOT FIND", name)
  return nil
end


-- Add this helper method to properly finalize a window
function Self:finalizeWindow(window)
  if window and type(window.finalize) == "function" then
    pcall(function()
      window:finalize()
    end)
  end
  return window
end

function Self:makeProcess(prototype, args)
  local args = args or {
    main=self.main,
    x = math.random(100, 300),
    y = math.random(100, 300),
  }
  local window = prototype:new(args)
  local _x = math.random(window.w/2 + 10, 640 - window.w/2 - 10)
  local _y = math.random(window.h/2 + 10, 480 - window.h/2 - 10)
  window.x = _x
  window.y = _y
  self._isReal = false -- Set to false to prevent window from being drawn
  window:finalize()
  window:setReal(false)--required so it can be set in openProcess
  self.contents:insert(window)
  self:openProcess(window)
  self.main:insert(window)
  print("MAKING", window.INTERNAL_NAME, window)
end

function Self:makePopup(args)
  args.main = self.main
  args.alwaysOnTop = true
  local popup = require('applications.dummy.gui.windows.PopupWindow'):new(args)
  popup:setReal(false)
  self:openProcess(popup)
  self.main:insert(popup)
end

function Self:serialize()
  local t = {}
  return t
end

function Self:deserialize(raw)
  --self.? = raw
  return self
end

function Self:isProcessRunning(prototype)
  -- Check for nil prototype
  if not prototype then
    return false
  end
  
  -- Get all active processes
  local activeProcesses = self:getActiveProcesses()
  
  -- Check if any process is using this prototype
  for _, process in ipairs(activeProcesses) do
    -- Compare prototype names to check if they're the same type
    if process.INTERNAL_NAME == prototype.INTERNAL_NAME or process.__proto == prototype then
      return true
    end
  end
  
  return false
end

return Self
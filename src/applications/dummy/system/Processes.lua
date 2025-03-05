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

  self:loadApps()


  return self
end

function Self:makeWindow(window_type_name, x, y)
  return require(window_type_name):new{
    main = self.main,
    x = x or math.random(100, 300),
    y = y or math.random(100, 300),
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

function Self:loadApps()
  self.stat = self:makeWindow('applications.dummy.gui.windows.StatWindow', 300, 300)
  self.calc = self:makeWindow('applications.dummy.gui.windows.CalcWindow', 300, 300)
  self.mail = self:makeWindow('applications.dummy.gui.windows.MailWindow', 200, 200)
  self.terminal = self:makeWindow('applications.dummy.gui.windows.TerminalWindow', 250, 250)
  self.editor = self:makeWindow('applications.dummy.gui.windows.EditorWindow', 250, 250)
  self.files = self:makeWindow('applications.dummy.gui.windows.FileManagerWindow', 250, 250)
  self.processes = self:makeWindow('applications.dummy.gui.windows.ProcessesWindow', 250, 250)
  self.ressources = self:makeWindow('applications.dummy.gui.windows.RessourcesWindow', 250, 250)
  self.antivirus = self:makeWindow('applications.dummy.gui.windows.AntivirusWindow', 250, 250)
  self.network = self:makeWindow('applications.dummy.gui.windows.NetworkWindow', 250, 250)
  self.debug = self:makeWindow('applications.dummy.gui.windows.DebugWindow', 250, 250)
  self.contacts = self:makeWindow('applications.dummy.gui.windows.ContactsWindow', 250, 250)
  self.battle = self:makeWindow('applications.dummy.gui.windows.BattleWindow', 250, 250)


  self.main.terminal.window = self.terminal

  self.contents:insert(self.stat)
  self.contents:insert(self.calc)
  self.contents:insert(self.mail)
  self.contents:insert(self.terminal)
  self.contents:insert(self.editor)
  self.contents:insert(self.files)
  self.contents:insert(self.processes)
  self.contents:insert(self.ressources)
  self.contents:insert(self.antivirus)
  self.contents:insert(self.network)
  self.contents:insert(self.debug)
  self.contents:insert(self.contacts)
  self.contents:insert(self.battle)
end

function Self:canOpenProcess(app_window)
  local ram_current_used = self.main.values:get("ram_current_used")
  local ram_usage = self.main.values:get("ram_usage_"..app_window.ID_NAME)
  local ram_total_size = self.main.values:get("ram_total_size")
  return (ram_current_used + ram_usage <= ram_total_size+0.0001)
end

function Self:openProcess(app_window)
  if self:canOpenProcess(app_window) and not app_window:isOpen() then
    self.main.values:inc("ram_current_used", self.main.values:get("ram_usage_"..app_window.ID_NAME))
    self.callbacks:call("onOpen", {self, app_window})
    app_window:activate()
    app_window:bringToFront()
    app_window:setFocus()
    return true
  end
  return false
end

function Self:closeProcess(app_window)
  self.main.values:inc("ram_current_used", -self.main.values:get("ram_usage_"..app_window.ID_NAME))
  self.callbacks:call("onClose", {self, app_window})
  app_window:close()
end

function Self:isActive(name)
  return self[name] ~= nil
end

function Self:getProcess(name)
  return self[name]
end

function Self:finalize()
  self:finalizeWindows()
end

function Self:finalizeWindows()
  self.stat:finalize()
  self.calc:finalize()
  self.mail:finalize()
  self.terminal:finalize()
  self.editor:finalize()
  self.files:finalize()
  self.processes:finalize()
  self.ressources:finalize()
  self.antivirus:finalize()
  self.network:finalize()
  self.debug:finalize()
  self.contacts:finalize()
  self.battle:finalize()
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



return Self
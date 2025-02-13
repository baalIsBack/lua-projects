local Super = require 'engine.Prototype'
local Self = Super:clone("Processes")



function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  self.hasContents = true
  Super.init(self)
  
  
  self:loadApps()


  return self
end

function Self:makeWindow(window_type_name, x, y)
  return require(window_type_name):new{
    main = self.main,
    x = x or math.random(100, 300),
    y = y or math.random(100, 300),
    visibleAndActive = false
  }
end

function Self:loadApps()
  self.stat = self:makeWindow('applications.dummy.gui.windows.StatWindow', 300, 300)
  self.calc = self:makeWindow('applications.dummy.gui.windows.CalcWindow', 300, 300)
  self.mail = self:makeWindow('applications.dummy.gui.windows.MailWindow', 200, 200)
  self.terminal = self:makeWindow('applications.dummy.gui.windows.TerminalWindow', 250, 250)
  self.editor = self:makeWindow('applications.dummy.gui.windows.EditorWindow', 250, 250)
  self.files = self:makeWindow('applications.dummy.gui.windows.FileManagerWindow', 250, 250)
  self.processes = self:makeWindow('applications.dummy.gui.windows.TODO_ProcessesWindow', 250, 250)
  self.ressources = self:makeWindow('applications.dummy.gui.windows.TODO_RessourcesWindow', 250, 250)
  self.antivirus = self:makeWindow('applications.dummy.gui.windows.AntivirusWindow', 250, 250)
  self.contacts = self:makeWindow('applications.dummy.gui.windows.ContactsWindow', 250, 250)


  self.main.terminal.window = self.terminal

  self.contents:insert(self.stat)
  self.contents:insert(self.calc)
  self.contents:insert(self.mail)
  self.contents:insert(self.terminal)
  self.contents:insert(self.editor)
  self.contents:insert(self.files)
  self.contents:insert(self.processes)
  self.contents:insert(self.ressources)
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
end

function Self:makePopup(args)
  args.main = self.main
  args.alwaysOnTop = true
  local popup = require('applications.dummy.gui.windows.PopupWindow'):new(args)
  self.main:insert(popup)
end

function Self:update(dt)
  
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
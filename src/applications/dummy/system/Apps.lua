local Super = require 'engine.Prototype'
local Self = Super:clone("Processes")



function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  self.hasContents = true
  Super.init(self)
  
  
  self:loadAppIcons()


  return self
end

function Self:makeIcon(icon_type_name, x, y)
  return require(icon_type_name):new{
    x = 32 + x*(64),
    y = 32 + y*(64),
    w = 64,
    h = 64,
  }
end

function Self:loadAppIcons()
  self.calc = self:makeIcon('applications.dummy.gui.elements.Icon_Calc', 0, 6)
  self.calc:setTargetApp(self.main.processes.calc)

  self.stat = self:makeIcon('applications.dummy.gui.elements.Icon_Stat', 1, 0)
  self.stat:setTargetApp(self.main.processes.stat)

  self.mail = self:makeIcon('applications.dummy.gui.elements.Icon_Mail', 0, 0)
  self.mail:setTargetApp(self.main.processes.mail)

  self.terminal = self:makeIcon('applications.dummy.gui.elements.Icon_Terminal', 0, 1)
  self.terminal:setTargetApp(self.main.processes.terminal)

  self.editor = self:makeIcon('applications.dummy.gui.elements.Icon_Editor', 0, 2)
  self.editor:setTargetApp(self.main.processes.editor)

  self.files = self:makeIcon('applications.dummy.gui.elements.Icon_FileManager', 0, 3)
  self.files:setTargetApp(self.main.processes.files)

  self.processes = self:makeIcon('applications.dummy.gui.elements.Icon_Processes', 0, 4)
  self.processes:setTargetApp(self.main.processes.processes)

  self.ressources = self:makeIcon('applications.dummy.gui.elements.Icon_Ressources', 0, 5)
  self.ressources:setTargetApp(self.main.processes.ressources)
end

function Self:install(app_name)
  self.main:insert(self.main.processes[app_name])
  self.main:insert(self:getIcon(app_name))
  self.contents:insert(app_name)
end

function Self:uninstall(app_name)
  self.main:remove(self.main.processes[app_name])
  self.main:remove(self:getIcon(app_name))
  self.contents:remove(app_name)
end

function Self:isInstalled(app_name)
  return self.contents:contains(app_name)
end

function Self:getIcon(app_name)
  return self[app_name]
end

function Self:update(dt)
  
end

function Self:serialize()
  local t = {
    apps_installed = self.contents.content_list
  }
  return t
end

function Self:deserialize(raw)
  for index, value in ipairs(raw.apps_installed) do
    self:install(value)
  end
  return self
end



return Self
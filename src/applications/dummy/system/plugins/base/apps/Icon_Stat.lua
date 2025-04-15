local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Stat")

Self.ID_NAME = "stat"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_calendar-3.png")
Self.NAME = "Documents"
Self.targetPrototype = require 'applications.dummy.gui.windows.StatWindow'

function Self:init(args)
  Super.init(self, args)


  self:setTargetApp(self.main.processes.stat)
  
	return self
end



return Self

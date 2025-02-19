local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Calc")

Self.ID_NAME = "calc"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_calendar-3.png")
Self.NAME = "Calc"

function Self:init(args)
  Super.init(self, args)

  self:setTargetApp(self.main.processes.calc)
  


  
	return self
end



return Self

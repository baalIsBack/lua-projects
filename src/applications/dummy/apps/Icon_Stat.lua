local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Stat")

Self.INTERNAL_NAME = "stat"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_calendar-3.png")
Self.DISPLAY_NAME = "Documents"
Self.TARGET_PROTOTYPE = StatWindow

function Self:init(args)
  Super.init(self, args)


  self:setTargetApp(self.main.processes.stat)
  
	return self
end



return Self

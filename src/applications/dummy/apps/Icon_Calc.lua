local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Calc")

Self.INTERNAL_NAME = "calc"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_calendar-3.png")
Self.DISPLAY_NAME = "Calc"
Self.TARGET_PROTOTYPE = CalcWindow

function Self:init(args)
  Super.init(self, args)


  
	return self
end



return Self

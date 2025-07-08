local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Battle")

Self.INTERNAL_NAME = "battle"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_calendar-3.png")
Self.DISPLAY_NAME = "Battle"
Self.TARGET_PROTOTYPE = BattleWindow

function Self:init(args)
  Super.init(self, args)


  
	return self
end



return Self

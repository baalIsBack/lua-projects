local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Virus")

Self.INTERNAL_NAME = "battle"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_stop-0.png")
Self.TARGET_PROTOTYPE = require 'applications.dummy.system.Battle'
Self.DISPLAY_NAME = "Buster"

function Self:init(args)
  Super.init(self, args)

  
  


  
	return self
end



return Self

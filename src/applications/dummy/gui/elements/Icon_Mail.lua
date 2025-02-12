local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Mail")

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_computer_explorer-3.png")
Self.NAME = "Mail"

function Self:init(args)
  Super.init(self, args)

  
  

  
	return self
end



return Self

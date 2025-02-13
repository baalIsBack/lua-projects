local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Contacts")

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_cardfile-1.png")
Self.NAME = "Contacts"

function Self:init(args)
  Super.init(self, args)

  self:setTargetApp(self.main.processes.contacts)
  


  
	return self
end



return Self

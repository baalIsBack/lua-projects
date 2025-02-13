local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Mail")

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_message_envelope_open-0.png")

Self.NAME = "Mail"

function Self:init(args)
  Super.init(self, args)

  self:setTargetApp(self.main.processes.mail)
  
  

  
	return self
end



return Self

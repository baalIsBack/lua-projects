local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Patcher")

Self.INTERNAL_NAME = "patcher"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_network_normal_two_pcs-0.png")
Self.DISPLAY_NAME = "Patcher"
Self.TARGET_PROTOTYPE = PatcherWindow

function Self:init(args)
  Super.init(self, args)

  self:setTargetApp(self.main.processes.patcher)
  


  
	return self
end



return Self

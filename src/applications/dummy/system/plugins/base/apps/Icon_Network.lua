local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Network")

Self.ID_NAME = "network"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_network_normal_two_pcs-0.png")
Self.NAME = "Network"
Self.targetPrototype = require 'applications.dummy.gui.windows.NetworkWindow'

function Self:init(args)
  Super.init(self, args)

  self:setTargetApp(self.main.processes.network)
  


  
	return self
end



return Self

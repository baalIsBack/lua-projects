local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Debug")

Self.ID_NAME = "debug"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_unknown_drive-3.png")
Self.NAME = "Debug"
Self.targetPrototype = require 'applications.dummy.gui.windows.DebugWindow'

function Self:init(args)
  Super.init(self, args)


  self:setTargetApp(self.main.processes.debug)

  
	return self
end



return Self

local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Virus")
--wxp_1-4.png
Self.ID_NAME = "antivirus"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_msagent-2.png")
Self.NAME = "Antivirus"
Self.targetPrototype = require 'applications.dummy.system.plugins.base.windows.AntivirusWindow'

function Self:init(args)
  Super.init(self, args)

  --self:setTargetApp(self.main.processes.antivirus)

  
  

  
	return self
end

return Self

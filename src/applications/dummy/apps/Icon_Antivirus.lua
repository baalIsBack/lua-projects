local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Virus")
--wxp_1-4.png
Self.INTERNAL_NAME = "antivirus"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_msagent-2.png")
Self.DISPLAY_NAME = "Antivirus"
Self.TARGET_PROTOTYPE = AntivirusWindow

function Self:init(args)
  Super.init(self, args)

  self:setTargetApp(self.main.processes.antivirus)
  print(" whyy", self.TARGET_PROTOTYPE, self.targetApp)
  
  

  
	return self
end

return Self

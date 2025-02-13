local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Stat")

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_computer_taskmgr-0.png")
Self.NAME = "Processes"


function Self:init(args)
  Super.init(self, args)

  self:setTargetApp(self.main.processes.processes)
  
	return self
end



return Self

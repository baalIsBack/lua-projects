local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Files")

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_folder_open-0.png")
Self.NAME = "Files"

function Self:init(args)
  Super.init(self, args)

  
  self:setTargetApp(self.main.processes.files)
  

  
	return self
end



return Self

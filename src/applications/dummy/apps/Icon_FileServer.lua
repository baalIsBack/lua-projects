local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_FileServer")

Self.INTERNAL_NAME = "fileserver"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_folder_open-0.png")
Self.DISPLAY_NAME = "Server"
Self.TARGET_PROTOTYPE = FileServerWindow

function Self:init(args)
  Super.init(self, args)
  
  self:setTargetApp(self.main.processes.fileserver)
  

  
	return self
end



return Self

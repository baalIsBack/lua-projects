local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_FileManager")

Self.INTERNAL_NAME = "filemanager"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_folder_open-0.png")
Self.DISPLAY_NAME = "Files"
Self.TARGET_PROTOTYPE = FileManagerWindow

function Self:init(args)
  Super.init(self, args)

  self:setTargetApp(self.main.processes.filemanager)
  

  
	return self
end



return Self

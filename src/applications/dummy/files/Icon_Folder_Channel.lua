local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Folder_Channel")

--contains only folders and channels(like poe chest that only contains X)(has to contain folder to prevent deadlock)
Self.INTERNAL_NAME = "folder_channel"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_channels-5.png")
Self.DISPLAY_NAME = "Folder"
Self.filetype = "folder"

function Self:init(args)
  
  Super.init(self, args)


  self.callbacks:register("onClicked", function(selff)
    self.main.processes:getProcess("fileserver"):switchLocation()
  end)
  
  
	return self
end




return Self

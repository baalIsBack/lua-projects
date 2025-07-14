local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Folder")

Self.INTERNAL_NAME = "folder"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_closed-0.png")
Self.DISPLAY_NAME = "Folder"
Self.filetype = "folder"

function Self:init(args)
  
  Super.init(self, args)


  self.callbacks:register("onClicked", function(selff)
    self.main.filegenerator:setLootTable("folder")
    local window = self.main.processes:getProcess("fileserver")
    
    window:switchLocation()
  end)
  
  
	return self
end



return Self

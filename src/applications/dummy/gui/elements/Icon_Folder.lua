local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Folder")

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_closed-0.png")
Self.NAME = "Folder"

function Self:init(args)
  
  Super.init(self, args)


  self.callbacks:register("onClicked", function(selff)
    self.main.processes:getProcess("files"):switchLocation()
  end)
  
  
	return self
end



return Self

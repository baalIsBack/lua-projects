local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_File_Image")

Self.ID_NAME = "image"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_image_old_jpeg-0.png")
Self.NAME = "Image"
Self.filetype = "image"

function Self:init(args)
  
  Super.init(self, args)
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    self:open()
  end)
  
  
  
  
	return self
end



return Self

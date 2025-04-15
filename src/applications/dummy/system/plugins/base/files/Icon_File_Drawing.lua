local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Drawing")

Self.ID_NAME = "drawing"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_bitmap_image-0.png")
Self.NAME = "Drawing"
Self.filetype = "drawing"

function Self:init(args)
  
  Super.init(self, args)
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    self:open()
  end)
  
  
	return self
end



return Self

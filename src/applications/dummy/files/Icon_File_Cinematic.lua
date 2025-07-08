local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Cinematic")

Self.INTERNAL_NAME = "cinematic"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_2-0.png")
Self.DISPLAY_NAME = "Cinematic"
Self.filetype = "cinematic"

function Self:init(args)
  
  Super.init(self, args)
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    self:open()
  end)
  
  
	return self
end



return Self

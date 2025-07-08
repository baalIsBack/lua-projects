local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Music")

Self.INTERNAL_NAME = "music"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_6-0.png")
Self.DISPLAY_NAME = "Music"
Self.filetype = "music"

function Self:init(args)
  
  Super.init(self, args)
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    self:open()
  end)
  
  
	return self
end



return Self

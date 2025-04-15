local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Sound")

Self.ID_NAME = "sound"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_3-0.png")
Self.NAME = "Sound"
Self.filetype = "sound"

function Self:init(args)
  
  Super.init(self, args)
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    self:open()
  end)
  
  
	return self
end



return Self

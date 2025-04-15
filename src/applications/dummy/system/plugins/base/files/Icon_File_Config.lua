local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_File_Config")

Self.ID_NAME = "config"
Self.IMG =  love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w95_59-0.png")
Self.NAME = "Config"
Self.filetype = "config"

function Self:init(args)
  Super.init(self, args)
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    self:open()
  end)
  
  
	return self
end



return Self

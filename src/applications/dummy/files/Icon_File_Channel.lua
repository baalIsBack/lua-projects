local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_File_Channel")

Self.INTERNAL_NAME = "channel"
Self.IMG =  love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_channels_file-0.png")
Self.DISPLAY_NAME = "Channel"
Self.filetype = "channel"

function Self:init(args)
  Super.init(self, args)
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    self:open()
  end)
  
  
	return self
end



return Self

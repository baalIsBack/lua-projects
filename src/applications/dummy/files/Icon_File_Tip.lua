local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_File_Tip")

Self.INTERNAL_NAME = "tip"
Self.IMG =  love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k-help-0.png")
Self.DISPLAY_NAME = "Tip"
Self.filetype = "tip"

function Self:init(args)
  Super.init(self, args)
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    self:open()
  end)
  
  
	return self
end


return Self

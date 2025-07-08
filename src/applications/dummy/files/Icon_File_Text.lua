local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_File_Text")

Self.INTERNAL_NAME = "text"
Self.IMG =  love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_text_file-0.png")
Self.DISPLAY_NAME = "Text"
Self.filetype = "text"

function Self:init(args)
  Super.init(self, args)
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    self:open()
  end)
  
  
	return self
end



return Self

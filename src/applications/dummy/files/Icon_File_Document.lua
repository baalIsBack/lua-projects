local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_File_Document")

Self.INTERNAL_NAME = "document"
Self.IMG =  love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_default_document-0.png")
Self.DISPLAY_NAME = "Document"
Self.filetype = "document"

function Self:init(args)
  Super.init(self, args)
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    print("Opening document: " .. self.INTERNAL_NAME)
    self:open()
  end)
  
  
	return self
end



return Self

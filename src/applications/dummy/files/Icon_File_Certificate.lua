local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_File_Certificate")

Self.INTERNAL_NAME = "certificate"
Self.IMG_VALID =  love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_certificate_2-0.png")
Self.IMG_EXPIRING =  love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_certificate_2_excl-0.png")
Self.IMG_EXPIRED =  love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_certificate_2_no-1.png")
Self.IMG_FAKE =  love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_certificate_3-0.png")
Self.IMG =  Self.IMG_VALID
Self.DISPLAY_NAME = "Certificate"
Self.filetype = "certificate"



function Self:init(args)
  Super.init(self, args)
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    self:open()
  end)
  
  
	return self
end



return Self

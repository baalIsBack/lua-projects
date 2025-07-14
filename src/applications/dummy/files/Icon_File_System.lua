local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_System")

Self.INTERNAL_NAME = "system"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_unknown_19-0.png")
Self.DISPLAY_NAME = "System"
--set filetype to something for system files
Self.filetype = "system"


function Self:init(args)
  Super.init(self, args)
  
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    self:open()
  end)
  
  
  
  
	return self
end



return Self

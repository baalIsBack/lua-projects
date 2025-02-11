local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Brick")

function Self:init(args)
  args.img = args.img or love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_unknown_19-0.png")
  Super.init(self, args)
  
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    self:open()
  end)
  
  
  
  
	return self
end



return Self

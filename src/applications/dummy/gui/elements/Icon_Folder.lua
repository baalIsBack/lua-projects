local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Folder")

function Self:init(args)
  args.img = args.img or love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_closed-0.png")
  Super.init(self, args)


  self.callbacks:register("onClicked", function(selff)
    self.main.app_files:switchLocation()
  end)
  
  
	return self
end



return Self

local Super = require 'applications.dummy.Icon'
local Self = Super:clone("Icon_Folder")

function Self:init(args)
  args.img = args.img or love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons/w98_directory_closed.png")
  Super.init(self, args)

  self.callbacks:register("onClicked", function(selff)
    local popup = require 'applications.dummy.PopupWindow':new{
      main = self.main,
      x = math.random(0+50, 640-50),
      y = math.random(0+50, 480-50),
      visibleAndActive = true,
      alwaysOnTop = true,
      z = MAX_Z,
      title = "" .. math.random(0, 1000),
    }
    MAX_Z = MAX_Z + 1
    self.main:insert(popup)
  end)
  
  
  
	return self
end



return Self

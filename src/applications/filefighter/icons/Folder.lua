local Super = require 'src.applications.filefighter.BaseIcon'
local Self = Super:clone("Icon_Folder")

Self.INTERNAL_NAME = "folder"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_closed-0.png")
Self.DISPLAY_NAME = "Folder"
Self.filetype = "folder"

function Self:init(args)
  Super.init(self, args)

  self.callbacks:register("onOpen", function(selff)
    self.main.windowManager:makeWindow(ExplorerWindow, {main=self.main, x = 200, y = 200})

  end)
  
  return self
end



return Self

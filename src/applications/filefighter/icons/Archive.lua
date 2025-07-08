local Super = require 'src.applications.filefighter.BaseIcon'
local Self = Super:clone("Icon_File_Archive")

Self.INTERNAL_NAME = "archive"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_zipper-1.png")
Self.DISPLAY_NAME = "Archive"
Self.filetype = "archive"

function Self:init(args)
  Super.init(self, args)

  self.hardness = args.hardness or 10
  self.locks = args.locks or math.random(1, 10) + self.hardness
  self.callbacks:register("onClicked", function(selff)
    self:tryUnlock()
  end)

  self.callbacks:register("onOpen", function(selff)
    print("Wahoy")
  end)

  self.callbacks:register("update", function(selff, dt)
    --print("dt", dt)
  end)
  
  
	return self
end

function Self:canOpen()
  return self.locks <= 0
end

function Self:tryUnlock()
  if self.locks > 0 then
    self.locks = self.locks - 1
  end
end



return Self

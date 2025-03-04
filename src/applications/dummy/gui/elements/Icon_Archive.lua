local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Archive")

Self.ID_NAME = "archive"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_zipper-1.png")
Self.NAME = "Archive"

function Self:init(args)
  
  Super.init(self, args)

  self.hardness = args.hardness or 10
  self.callbacks:register("onClicked", function(selff)
    --self.main.files:remove(self.name)
    if math.random(1, self.hardness) == 1 then
      self.main.processes:getProcess("files"):switchLocation()--self:open()
    end
  end)
  
  
  
  
	return self
end



return Self

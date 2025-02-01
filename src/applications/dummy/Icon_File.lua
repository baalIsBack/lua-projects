local Super = require 'applications.dummy.Icon'
local Self = Super:clone("Icon_File")

function Self:init(args)
  args.img = args.img or love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons/w98_directory_closed.png")
  Super.init(self, args)

  self.callbacks:register("onClicked", function(selff)
    if self.main.notes:isMemorable(self.name) then
      self.main.notes:addNote(self.name)
    end
  end)
  
  
  
	return self
end



return Self

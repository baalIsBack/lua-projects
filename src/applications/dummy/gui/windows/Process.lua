local Super = require 'engine.gui.Window'
local Self = Super:clone("Process")

Self.INTERNAL_NAME = "undefined"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_unknown_drive-3.png")

function Self:init(args)
  args.title = args.title or "undefined"
  args._isReal = false
  Super.init(self, args)
  


  

  self.bar.close_button.callbacks:register("onClicked", function(x, y)
    self.main.processes:closeProcess(self)
  end)


  return self
end



function Self:getTopBorder()
  return self:getY() - self.h/2 + 160
end

function Self:getCycles()
  return -1
end




return Self

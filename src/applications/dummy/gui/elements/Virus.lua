local Super = require 'engine.gui.Node'
local Self = Super:clone("Virus")

local IMG_VIRUS = love.graphics.newImage("submodules/lua-projects-private/gfx/spider.png")--w98_game_spider-0.png,w98_game_mine_1-0.png

function Self:init(args)
  Super.init(self, args)

  self.w = 20
  self.h = 22

  self.callbacks:register("onClicked", function(self)
    self:markForDeletion()
  end)
  

	return self
end


function Self:draw()
  if not self:isReal() then
    return
  end
  self:applySelectionColorTransformation()
  
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  

  love.graphics.setLineWidth(2)

  love.graphics.draw(IMG_VIRUS, -32/2, -32/2, 0, 1, 1, 0, 0)
  --love.graphics.rectangle("line", -self.w/2, -self.h/2, self.w, self.h)
  
  self.contents:callall("draw")

  love.graphics.pop()
end

return Self

local Super = require 'engine.gui.Node'
local Self = Super:clone("Virus")


local IMG_EXPLOSION = love.graphics.newImage("submodules/lua-projects-private/gfx/Mini Pixel Pack 3/Effects/Explosion (16 x 16).png")
local IMG_SPARKLE = love.graphics.newImage("submodules/lua-projects-private/gfx/Mini Pixel Pack 3/Effects/Sparkle (16 x 16).png")



function Self:init(args)
  Super.init(self, args)

  self.cage = args.cage

  self.img = IMG_EXPLOSION

  self.w = 16
  self.h = 16

  self.callbacks:declare("onKill")

  local quads = require 'engine.Animation':quadsFromSheet(IMG_EXPLOSION, 16, 16)
  self.animation = require 'engine.Animation':new(18, quads, false)
  self.animation:play()
  self.animation.callbacks:register("finish", function(selff)
    self.animation:stop()
    self.callbacks:call("onKill", {self})
  end)

  self.callbacks:register("onKill", function(self)
    self:markForDeletion()
  end)

  
  self.callbacks:register("update", function(self, dt)
    self.animation:update(dt)
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

  love.graphics.draw(self.img, self.animation:getQuad(), -16/2, -16/2, 0, 1, 1, 0, 0)
  --love.graphics.rectangle("line", -self.w/2, -self.h/2, self.w, self.h)
  
  self.contents:callall("draw")

  love.graphics.pop()
end

return Self

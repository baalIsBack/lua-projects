local Super = require 'applications.farm.objects.Object'
local Self = Super:clone("Tuff")

local IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/Hana Caraka - Farming n Foraging [sample]/misc.png")
local QUADS = {
  love.graphics.newQuad(0, 0, 16, 16, IMG:getDimensions()),
  love.graphics.newQuad(16, 0, 16, 16, IMG:getDimensions()),
  love.graphics.newQuad(32, 0, 16, 16, IMG:getDimensions()),
}

function Self:init(args)
  Super.init(self, args)

  self.quad = QUADS[1]

  self.callbacks:register("onClick", function (self)
    if self.quad == QUADS[1] then
      self.quad = QUADS[2]
    end
  end)
  
  self.callbacks:register("onDraw", self.onDraw)

  
	return self
end

function Self:onDraw()
  love.graphics.draw(IMG, self.quad, 0, 0)
end

return Self

local Super = require 'applications.farm.objects.Object'
local Self = Super:clone("Tuff")

local IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/Hana Caraka - Topdown Tileset [sample]/Tileset/Tufts and Lumps.png")
local QUADS = {
  love.graphics.newQuad(0, 0, 16, 16, IMG:getDimensions()),
  love.graphics.newQuad(16, 0, 16, 16, IMG:getDimensions()),
  love.graphics.newQuad(0, 16, 16, 16, IMG:getDimensions()),
  love.graphics.newQuad(16, 16, 16, 16, IMG:getDimensions()),
}

function Self:init(args)
  Super.init(self, args)

  self.callbacks:register("onTick", self.onTick)
  self.callbacks:register("onUpdate", self.onUpdate)
  self.callbacks:register("onDraw", self.onDraw)

  self.quad = QUADS[math.random(1, #QUADS)]
  
	return self
end

function Self:onTick()
end

function Self:onUpdate(dt)
end

function Self:onDraw()
  love.graphics.draw(IMG, self.quad, 0, 0)
end

return Self

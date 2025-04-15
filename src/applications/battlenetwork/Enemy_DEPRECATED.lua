local Super = require 'applications.battlenetwork.Entity'
local Self = Super:clone("Enemy")

local Animation = require 'engine.Animation'

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/Enemy.png")

function Self:init(args)
  Super.init(self, args)


  self.img = Self.IMG
  self.quad = nil
  self.hp = 40


  self.animation_idle = Animation:new(12, Animation:quadsFromSheet(self.img, 26, 50), true)


  
  self.quadOffsetX = 14
  self.quadOffsetY = 44

  self.animation = self.animation_idle
  self.callbacks:register("onDraw", self.draw2)
  self.callbacks:register("onDestroy", self.spawnExplosion)
  self.callbacks:register("onUpdate", self.lifeCheck)

  return self
end

function Self:lifeCheck(dt)
  if self.hp <= 0 then
    self:destroy()
  end
end

function Self:draw2()
  love.graphics.push()
  self:translateOffset()
  local x, y = self.battle:getDrawPosition(self.x+0.5, self.y+0.5)
  self.quad = self.animation:getQuad()
  love.graphics.draw(self.img, self.quad, x, y)
  love.graphics.pop()
  self:drawHP()
end



return Self
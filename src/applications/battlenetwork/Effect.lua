local Super = require 'applications.battlenetwork.Entity'
local Self = Super:clone("Effect")

local Animation = require 'engine.Animation'

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/Super Package Retro Pixel Effects/01.png")

function Self:init(args)
  Super.init(self, args)

  self.transient = true

  self.img = Self.IMG
  self.quad = nil

  --in lua i want to check that self.once is the reverse of args.once but if no args.once is givven it should be true
  
  self.once = (args.once == nil or args.once ~= false)

  if args.effectNumber then
    local str = ""..args.effectNumber
    if #str == 1 then
      str = "0"..str
    end
    self.img = love.graphics.newImage("submodules/lua-projects-private/gfx/Super Package Retro Pixel Effects/"..str..".png")
  end

  self.animation = Animation:new(24, {
    love.graphics.newQuad(0*32, 0*32, 32, 32, self.img:getDimensions()),
    love.graphics.newQuad(1*32, 0*32, 32, 32, self.img:getDimensions()),
    love.graphics.newQuad(2*32, 0*32, 32, 32, self.img:getDimensions()),
    love.graphics.newQuad(3*32, 0*32, 32, 32, self.img:getDimensions()),
    love.graphics.newQuad(4*32, 0*32, 32, 32, self.img:getDimensions()),
    love.graphics.newQuad(5*32, 0*32, 32, 32, self.img:getDimensions()),
    love.graphics.newQuad(0*32, 1*32, 32, 32, self.img:getDimensions()),
    love.graphics.newQuad(1*32, 1*32, 32, 32, self.img:getDimensions()),
  }, not self.once)

  if self.once then
    self.animation.callbacks:register("finish", function()
      self:destroy()
    end)
  end
  
  self.quadOffsetX = 16
  self.quadOffsetY = 24

  self.callbacks:register("onDraw", self.draw2)

  return self
end

function Self:draw2()
  love.graphics.push()
  self:translateOffset()
  local x, y = self.battle:getDrawPosition(self.x+0.5, self.y+0.5)
  self.quad = self.animation:getQuad()
  love.graphics.draw(self.img, self.quad, x, y)
  love.graphics.pop()
end



return Self
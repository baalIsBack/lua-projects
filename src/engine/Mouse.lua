local Super = require 'engine.Prototype'
local Self = Super:clone("Mouse")

local IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/Mouse.png")

function Self:init(args)
  Super.init(self, args)
  

  love.mouse.setRelativeMode( true )

  self.x = 640/2
  self.y = 480/2
  

	return self
end

function Self:getPosition()
  local sx, sy = require 'engine.Screen':getScale()
  return self.x/sx, self.y/sy
end

function Self:draw()
  love.graphics.setColor(1, 1, 1)
  --love.graphics.circle("fill", self.x, self.y, 5)
  love.graphics.draw(IMG, self.x, self.y)
end

function Self:mousemoved(x, y, dx, dy, istouch)
  self.x = math.max(0, math.min(640, self.x + dx))
  self.y = math.max(0, math.min(480, self.y + dy))
  --love.mouse.setPosition(self.x, self.y)
end

function Self:setPosition(x, y)
  self.x = x
  self.y = y
end

return Self:new()

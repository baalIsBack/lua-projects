local Super = require 'engine.Prototype'
local Self = Super:clone("Button")



function Self:init(args)
  Super.init(self, args)

  self.x = args.x
  self.y = args.y
  self.w = args.w
  self.h = args.h
  self.f = args.f
  self.text = args.text

  return self
end

function Self:draw()
  local x, y = love.mouse.getPosition()
  if x >= self.x and x <= (self.x + self.w) and y >= self.y and y <= (self.y + self.h) then
    love.graphics.setColor(0.6, 0.6, 0.6)
  else
    love.graphics.setColor(0.8, 0.8, 0.8)
  end
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
  if self.text then
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(self.text, self.x, self.y + (self.h / 2) - 8, self.w, "center")
  end
end

function Self:update(dt)
  
end

function Self:mousepressed(x, y, button, istouch, presses)
  if button == 1 then
    if x >= self.x and x <= (self.x + self.w) and y >= self.y and y <= (self.y + self.h) then
      if self.f then
        self.f(self)
      end
    end
  end
  
end

return Self
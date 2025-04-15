local Super = require 'applications.battlenetwork.KeyboardControllableLayout'
local Self = Super:clone("Selectable")


function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)

  self.callbacks:declare("onTrigger")
  
  self.img = args.img or (args.content and args.content.img) or nil
  self.quad = args.quad or (args.content and args.content.quad) or nil

  local qx, qy, qw, qh = (self.quad and self.quad:getViewport())
  local iw, ih = (self.img and self.img:getWidth()), (self.img and self.img:getHeight())

  self.x = args.x or 0
  self.y = args.y or 0
  self.w = args.w or qw or iw or 1
  self.h = args.h or qh or ih or 1

  self.sx = args.sx or 1
  self.sy = args.sy or 1

  self.greyOut = false


  return self
end

function Self:draw()
  if self.selected then
    love.graphics.setColor(1, 0, 0)
  else
    love.graphics.setColor(1, 1, 1)
  end
  love.graphics.rectangle("line", self.x - (self.w*self.sx)/2, self.y - (self.h*self.sy)/2, (self.w*self.sx), (self.h*self.sy))
  if self.greyOut then
    love.graphics.setColor(0.5, 0.5, 0.5)
  else
    love.graphics.setColor(1, 1, 1)
  end
  if self.quad then
    love.graphics.draw(self.img, self.quad, self.x - (self.w*self.sx)/2, self.y - (self.h*self.sy)/2, 0, self.sx, self.sy)
  else
    love.graphics.draw(self.img, self.x - (self.w*self.sx)/2, self.y - (self.h*self.sy)/2, 0, self.sx, self.sy)
  end
end

function Self:update(dt)
  if self.selected then
    if love.keyboard.isDown("space") then
      self.callbacks:call("onTrigger", {self})
    end
  end
end

return Self
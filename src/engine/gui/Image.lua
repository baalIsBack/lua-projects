local Super = require 'engine.gui.Node'
local Self = Super:clone("Image")


function Self:init(args)
  Super.init(self, args)

  self.img = nil
  self:setImage(args.img)

  self.alignment = args.alignment or "center"

	return self
end

function Self:setImage(img)
  self.img = img
  local w, h = img:getWidth(), img:getHeight()
  self.w = w
  self.h = h
end

function Self:getImage()
  return self.img
end

function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(self.color)
  love.graphics.draw(self.img, -self.w/2, -self.h/2)
  love.graphics.setColor(1, 1, 1)
  
  self.contents:callall("draw")

  love.graphics.pop()
end

function Self:isLeaf(x, y)
  return false
end

return Self

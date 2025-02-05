local Super = require 'engine.gui.Node'
local Self = Super:clone("Button")

function Self:init(args)
  Super.init(self, args)

  self.wasDown = false
  self.isDown = false

	return self
end

function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)
  
  love.graphics.setColor(192/255, 192/255, 192/255)
  if not self.enabled then
    love.graphics.setColor((192/1.2)/255, (192/1.2)/255, (192/1.2)/255)
  end
  
  
  if self.isStillClicking and self.enabled then
    local pressedHeightDifference = 2
    love.graphics.translate(0, pressedHeightDifference)
    love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
    love.graphics.setColor(128/255, 128/255, 128/255)
    love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  else
    love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
    love.graphics.setColor(128/255, 128/255, 128/255)
    love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
    love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)
  end

  
  
  
  self.contents:callall("draw")

  love.graphics.pop()
end


return Self

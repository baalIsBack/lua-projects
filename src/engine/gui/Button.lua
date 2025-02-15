local Super = require 'engine.gui.Node'
local Self = Super:clone("Button")

function Self:init(args)
  args.color = args.color or {192/255, 192/255, 192/255, 1}
  Super.init(self, args)

  self.wasDown = false
  self.isDown = false
  if args.text then
    self.text = require 'engine.gui.Text':new{
      main = self.main,
      x = 0,
      y = 0,
      text = args.text,
      alignment = "center",
    }
    if args.text_color then
      self.text:setColor(args.text_color)
    end
    self:insert(self.text)
  end

	return self
end

function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)
  
  love.graphics.setColor(self.color)
  if not self.enabled then
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor((r/1.2), (g/1.2), (b/1.2), a)
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

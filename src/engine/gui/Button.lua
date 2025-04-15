local Super = require 'engine.gui.Node'
local Self = Super:clone("Button")

function Self:init(args)
  args.color = args.color or {192/255, 192/255, 192/255, 1}
  args.h = args.h or 16
  local prior_w = args.w
  Super.init(self, args)
  self._invisible = args._invisible

  self._wasDown = false
  self._isDown = false
  if args.text then
    self.text = require 'engine.gui.Text':new{
      main = self.main,
      x = 0,
      y = -2,
      text = args.text,
      alignment = "center",
    }
    if args.text_color then
      self.text:setColor(args.text_color)
    end
    self:insert(self.text)
  end
  --calculate width of button by taking self.text and the font
  if self.text and not prior_w then
    self.w = self.text:getWidth() + 6
  end
  
	return self
end

function Self:draw()
  if not self:isReal() then
    return
  end
  self:applySelectionColorTransformation()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)
    
  if not self._invisible then
    love.graphics.setColor(self.color)
    if not self.enabled then
      local r, g, b, a = love.graphics.getColor()
      love.graphics.setColor((r/1.2), (g/1.2), (b/1.2), a)
    end
    
    
    if self._isStillClicking and self.enabled then
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

    
    
    

  end
  self.contents:callall("draw")
  love.graphics.pop()
end


return Self

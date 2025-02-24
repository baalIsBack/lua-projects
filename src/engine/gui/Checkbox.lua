local Super = require 'engine.gui.Button'
local Self = Super:clone("Checkbox")

function Self:init(args)
  Super.init(self, args)
  self.w = 14
  self.h = 14
  if self.text then
    self.text.x = 10 + self.text:getWidth()/2
  end

  self.text_checkmark = require 'engine.gui.Text':new{
    main = self.main,
    x = 0,
    y = -2,
    text = "x",
    alignment = "center",
  }
  self.text_checkmark:setFont(FONTS["dialog"])
  self.text_checkmark.x = 1
  self.text_checkmark.y = -2
  --self:insert(self.text_checkmark)

  self.checked = args.checked or false

  self.callbacks:register("onClicked", function(x, y)
    if self:isChecked() then
      self:uncheck()
    else
      self:check()
    end
  end)

	return self
end

function Self:isChecked()
  return self.checked
end

function Self:check()
  self.checked = true
end

function Self:uncheck()
  self.checked = false
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
  
  self.text_checkmark.visibleAndActive = self.checked
  local pressedHeightDifference = 0
  if self.isStillClicking and self.enabled then
    pressedHeightDifference = 2
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
  self.text_checkmark:draw()

  love.graphics.translate(0, -pressedHeightDifference)
  
  
  self.contents:callall("draw")

  love.graphics.pop()
end


return Self

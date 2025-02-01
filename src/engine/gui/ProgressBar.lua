local Super = require 'engine.gui.Node'
local Self = Super:clone("ProgressBar")

function Self:init(args)
  Super.init(self, args)

  self.title = args.title or ""
  self.w = args.w
  self.h = 16

  self.wasDown = false
  self.isDown = false

  
  self.progress = 0

  self.legalDrag = false

  --add small button 14 x 14 at the right end
  self.callbacks:register("onDragBegin", function(selff, x, y)
    if self:isLeaf(x, y) then
      self.legalDrag = true
    end
  end)

  self.callbacks:register("onDrag", function(selff, dx, dy)
    local _x, _y = require 'engine.Screen':getMousePosition()
    if self:isLeaf(_x-dx, _y-dy) then
      if self.legalDrag then
        self.parent.x = self.parent.x + dx
        self.parent.y = self.parent.y + dy
      end
    else
      self.legalDrag = false
    end
  end)

  self.callbacks:register("onDragEnd", function(selff, x, y)
    self.legalDrag = false
  end)

  self:insert(require 'engine.gui.Text':new{x=0, y=0, text=self.title, color={1,1,1}, alignment="center"})
  

	return self
end


function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  
 
  love.graphics.setLineWidth(2)

  --love.graphics.setColor(1/255, 0/255, 129/255)
  love.graphics.setColor(192/255, 192/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)

  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2)+2 ), math.floor( -(self.h/2)+2 ), (self.w-4)*1, self.h-4)
  
  love.graphics.setColor(1/255, 0/255, 129/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2)+2 ), math.floor( -(self.h/2)+2 ), (self.w-4)*self.progress, self.h-4)
  
  love.graphics.setColor(1, 1, 1)
  local font = love.graphics.getFont()
  local str = string.format("%.0f%%", self.progress*100)
  love.graphics.print(str, -font:getWidth(str)/2, -font:getHeight(str)/2)
  
  self.contents:callall("draw")

  love.graphics.pop()
end

function Self:setProgress(value)
  self.progress = value
  if self.progress < 0 then
    self.progress = 0
  end
  if self.progress > 1 then
    self.progress = 1
  end  
end

return Self

local Super = require 'engine.gui.Node'
local Self = Super:clone("Bar")

function Self:init(args)
  Super.init(self, args)

  self.color = args.color or {0/255, 0/255, 129/255}
  self.title = args.title or ""
  self.w = args.w
  self.h = 16

  self._wasDown = false
  self._isDown = false

  self.legalDrag = false

  --add small button 14 x 14 at the right end
  self.callbacks:register("onDragBegin", function(selff, x, y)
    if self:getTopNode("Window"):isTopWindow(x, y) and self:isLeaf(x, y) then
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

  self:insert(require 'engine.gui.Text':new{main=self.main,x=0, y=0, text=self.title, color={1,1,1}, alignment="center"})
  

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

  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)
  
  self.contents:callall("draw")

  love.graphics.pop()
end



return Self

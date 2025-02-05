local Super = require 'engine.gui.Node'
local Self = Super:clone("Window")

function Self:init(args)
  Super.init(self, args)
  
  self.alwaysOnTop = args.alwaysOnTop
  self.w = args.w
  self.h = args.h
  self.z = args.z or MAX_Z
  if not args.z then
    MAX_Z = MAX_Z + 1
  end

  self.wasDown = false
  self.isDown = false

  self.bar = require 'engine.gui.Bar':new{x = 0, y = -self.h/2 - 8+16 , w = self.w, h = 32, title = args.title}
  self:insert(self.bar)
  self.bar.close_button = require 'engine.gui.Button':new{x = self.bar.w/2 - 8, y = 0, w = 10, h = 10}
  self.bar.close_button:insert(require 'engine.gui.Text':new{text = "x", color={0,0,0}, x = 1, y = -1})
  self.bar.close_button.callbacks:register("onClicked", function(x, y)
    self.visibleAndActive = false
    self:setFocus()
  end)
  self.bar:insert(self.bar.close_button)
  self.callbacks:register("onMousePressed", function(self)
    local mx, my = require 'engine.Screen':getMousePosition()
    if self:isTopNode(mx, my) then
      self:getTopNode("Window"):bringToFront(self)
      --self:setFocus()
    end
  end)

  


	return self
end



function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)

  --c0c0c0 192/255
  love.graphics.setColor(192/255, 192/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)

  self.contents:callall("draw")

  love.graphics.pop()
end

function Self:isOnlyWindow(x, y)
  for index, window in ipairs(self.main.contents.content_list) do
    if window ~= self and window.visibleAndActive and window:hasPointCollision(x, y) then
      return false
    end
  end
  return true
end

function Self:isTopWindow(x, y)
  for index, window in ipairs(self.main.contents.content_list) do
    if window.isWindow then
      if window ~= self and window.visibleAndActive and window:hasPointCollision(x, y) then
        if (window.z >= self.z and self.alwaysOnTop == window.alwaysOnTop) or (window.alwaysOnTop and not self.alwaysOnTop) then
          return false
        end
      end
    end
  end
  return true
end

function Self:checkCallbacks()
  local mx, my = require 'engine.Screen':getMousePosition()
  local isMouseDown = love.mouse.isDown(1)
  local isMouseColliding = CHECK_COLLISION(mx, my, 0, 0, self:getX()-self.w/2, self:getY()-self.h/2, self.w, self.h)
  local wasStillColliding = self.isStillColliding
  local wasStillClicking = self.isStillClicking
  local wasStillDragging = self.isStillDragging
  local deltaColliding = isMouseColliding ~= self.isStillColliding
  local deltaClicking = isMouseDown ~= self.wasMouseDown
  local isLeaf = self:isLeaf(mx, my)
  self.isStillColliding = self.isStillColliding and isMouseColliding
  self.isStillClicking = self.isStillClicking and isMouseDown
  self.isStillDragging = self.isStillDragging and isMouseDown

  if isMouseColliding and deltaColliding then
    self.isStillColliding = true--begin collision tracking
    self.callbacks:call("onMouseEnter", {self, mx, my})
  end
  if self.isStillColliding then
    self.callbacks:call("onHover", {self, mx, my})
  end
  if not isMouseColliding and deltaColliding then
    self.isStillColliding = false--end collision tracking
    self.callbacks:call("onMouseExit", {self, mx, my})
  end

  if isMouseColliding and isMouseDown and deltaClicking then
    self.isStillClicking = true--begin click
    self.isStillDragging = true--begin drag
    self.callbacks:call("onMousePressed", {self, mx, my})
    self.callbacks:call("onDragBegin", {self, mx, my})
    self.drag_start_x = mx
    self.drag_start_y = my
  end
  if not isMouseDown and deltaClicking and isMouseColliding and wasStillClicking then
    if self:isTopWindow(mx, my) and not self:hasFocus() then self:setFocus() end
    self.callbacks:call("onClicked", {self, mx, my})
  end
  if (not isMouseDown and deltaClicking) or (isMouseDown and deltaColliding) then
    self.isStillClicking = false--end click
    self.callbacks:call("onMouseReleased", {self, mx, my})
  end

  if not isMouseDown and deltaClicking and self.wasStillDragging then
    self.callbacks:call("onDragEnd", {self, mx, my})
  end

  if self.isStillDragging then
    self.callbacks:call("onDrag", {self, mx - self.drag_start_x, my - self.drag_start_y})
    self.drag_start_x = mx
    self.drag_start_y = my
  end


  self.wasMouseDown = isMouseDown
  self.wasColliding = isMouseColliding
end



return Self

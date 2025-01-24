local Super = require 'engine.Prototype'
local Self = Super:clone("Node")

Self.FOCUS_LIST = {}

function Self:init(args)
  self.hasCallbacks = true
  self.hasContents = true
  Super.init(self)
  self.main = args.main

  self.callbacks:declare("onInsert")
  self.callbacks:declare("onDraw")
  
  self.callbacks:declare("onMouseEnter")
  self.callbacks:declare("onHover")
  self.callbacks:declare("onMouseExit")
  self.callbacks:declare("onMousePressed")
  self.callbacks:declare("onClicked")
  self.callbacks:declare("onMouseReleased")
  self.callbacks:declare("onDragBegin")
  self.callbacks:declare("onDrag")
  self.callbacks:declare("onDragEnd")

  self.callbacks:declare("update")
  self.callbacks:declare("keypressed")
  self.callbacks:declare("textinput")

--  self.callbacks:register("onMouseEnter", function(self, x, y) print("onMouseEnter", x, y) end)
--  self.callbacks:register("onHover", function(self, x, y) print("onHover", x, y) end)
--  self.callbacks:register("onMouseExit", function(self, x, y) print("onMouseExit", x, y) end)
--  self.callbacks:register("onMousePressed", function(self, x, y) print("onMousePressed", x, y) end)
--  self.callbacks:register("onClicked", function(self, x, y) print("onClicked", x, y) end)
--  self.callbacks:register("onMouseReleased", function(self, x, y) print("onMouseReleased", x, y) end)
--  self.callbacks:register("onDragBegin", function(self, x, y) print("onDragBegin", x, y) end)
--  self.callbacks:register("onDrag", function(self, dx, dy) print("onDrag", dx, dy) end)
--  self.callbacks:register("onDragEnd", function(self, x, y) print("onDragEnd", x, y) end)
  --onMouseEnter
  --onHover: called every frame the mouse is over the button
  --onMouseExit
  --onMousePressed
  --onClicked: called when the mouse is pressed and released while always over the button
  --onMouseReleased
  --onDragBegin
  --onDrag
  --onDragEnd
  self.isStillColliding = false
  self.isStillClicking = false
  self.isStillDragging = false
  
  self.focused = false

  self.color = args.color or {1, 1, 1}

  self.isDown = false
  self.wasDown = false
  self.drag_start_x = nil
  self.drag_start_y = nil

  self._triggeredCallbackThisCycle = false

  self.visibleAndActive = args.visibleAndActive or (args.visibleAndActive == nil and true)
  self.enabled = args.enabled or (args.enabled == nil and true)
  self.debug = false

  self.x = args.x or 0
  self.y = args.y or 0
  self.w = args.w or 0
  self.h = args.h or 0

	return self
end

function Self:setColor(r, g, b, a)
  self.color = {r, g, b, a}
end

function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(self.color)

  if self.debug then
    love.graphics.circle("fill", self.x, self.y, 4)
    love.graphics.rectangle("line", -self.w/2, -self.h/2, self.w, self.h)
  end
  self.callbacks:call("onDraw", {self})
  self.contents:callall("draw")
  
  love.graphics.pop()
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
  local isLeaf = self:isLeaf(mx, my) and self:getTopNode("Window"):isTopNode(mx, my)
  self.isStillColliding = self.isStillColliding and isMouseColliding and isLeaf
  self.isStillClicking = self.isStillClicking and isMouseDown
  self.isStillDragging = self.isStillDragging and isMouseDown

  if isMouseColliding and deltaColliding and isLeaf then
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

  if isMouseColliding and isMouseDown and deltaClicking and isLeaf then
    self.isStillClicking = true--begin click
    self.isStillDragging = true--begin drag
    self.callbacks:call("onMousePressed", {self, mx, my})
    self.callbacks:call("onDragBegin", {self, mx, my})
    self.drag_start_x = mx
    self.drag_start_y = my
  end
  
  if not isMouseDown and deltaClicking and isMouseColliding and wasStillClicking then
    self:setFocus()
    self.callbacks:call("onClicked", {self, mx, my})
  end
  if ((not isMouseDown and deltaClicking) or (isMouseDown and deltaColliding)) and self.isStillClicking then
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

function Self:isTopNode(x, y)
  if not self.z then
    return false
  end
  for index, otherNode in ipairs(self.main.contents.content_list) do
    if otherNode ~= self and otherNode.visibleAndActive and otherNode:hasPointCollision(x, y) and otherNode.z >= self.z then
      return false
    end
  end
  return true
end

function Self:activate()
  self.visibleAndActive = true
end

function Self:deactivate()
  self.visibleAndActive = false
end

function Self:checkCallbacks_old()
  local calledCallback = false
  local mx, my = require 'engine.Screen':getMousePosition()
  if love.mouse.isDown(1) then
    if CHECK_COLLISION(mx, my, 1, 1, self:getX()-self.w/2, self:getY()-self.h/2, self.w, self.h) then
      if self.drag_start_x == nil then
        self.drag_start_x = mx
        self.drag_start_y = my
      end
      if not self.wasDown then
        self.isDown = true
        self.callbacks:call("onClick", {self, mx, my})
      end
    else
      self.isDown = false
    end
    if self.drag_start_x ~= nil then
      self.callbacks:call("onDrag", {self, mx - self.drag_start_x, my - self.drag_start_y})
      calledCallback = true
      self.drag_start_x = mx
      self.drag_start_y = my
    end
    self.wasDown = true
  else
    if self.isDown and CHECK_COLLISION(mx, my, 1, 1, self:getX()-self.w/2, self:getY()-self.h/2, self.w, self.h) then
      self.callbacks:call("onClicked", {self})
      calledCallback = true
    end
    self.isDown = false
    self.wasDown = false
    self.drag_start_x = nil
    self.drag_start_y = nil
  end
  return calledCallback
end

function Self:keypressed(key, scancode, isrepeat)
  --if not self.visibleAndActive then
  --  return
  --end
  self.callbacks:call("keypressed", {self, key, scancode, isrepeat})
  self.contents:callall("keypressed", key, scancode, isrepeat)
end

function Self:textinput(text)
  --if not self.visibleAndActive then
  --  return
  --end
  self.callbacks:call("textinput", {self, text})
  self.contents:callall("textinput", text)
end

function Self:update(dt)
  if not self.visibleAndActive then
    return
  end
  self.callbacks:call("update", {self, dt})
  self.contents:callall("update", dt)
  self:checkCallbacks()
end

function Self:insert(child, id)
  self.contents:insert(child, id)
  child.parent = self
  self.callbacks:call("onInsert", {self, child, id})
end

function Self:getX()
  if not self.parent then
    return self.x
  else
    return self.x + self.parent:getX()
  end
end

function Self:getY()
  if not self.parent then
    return self.y
  else
    return self.y + self.parent:getY()
  end
end

function Self:getTopNode(type)
  if not self.parent or self:type() == type then
    return self
  else
    return self.parent:getTopNode(type)
  end
end

function Self:hasPointCollision(x, y)
  return CHECK_COLLISION(x, y, 0, 0, self:getX()-self.w/2, self:getY()-self.h/2, self.w, self.h)
end

function Self:isLeaf(x, y)
  return self:hasPointCollision(x, y) and (not self.contents:all("isLeaf", x, y) or self.contents:isEmpty())
end

function Self:bringToFront()
  --bring the node to front by accessing the z coordinate
  self.z = MAX_Z
  MAX_Z = MAX_Z + 1
end

function Self:hasFocus()
  return self.focused or self.contents:any("hasFocus")
end

function Self:setFocus()
  for i, node in ipairs(self.FOCUS_LIST) do
    node.focused = false
  end
  CLEAR(self.FOCUS_LIST)
  self.focused = true
  table.insert(self.FOCUS_LIST, self)
end

return Self

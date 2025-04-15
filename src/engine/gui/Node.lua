local Super = require 'engine.Prototype'
local Self = Super:clone("Node")

Self.FOCUS_LIST = {}

function Self:init(args)
  assert(args.main, "Node requires a main argument")
  self.main = args.main
  self.hasCallbacks = true
  self.hasContents = true
  Super.init(self)

  self.callbacks:declare("onInsert")
  self.callbacks:declare("onRemove")
  self.callbacks:declare("onDestroy")
  self.callbacks:declare("onDraw")
  
  self.callbacks:declare("onActivate")
  self.callbacks:declare("onDeactivate")
  
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
  self._isStillColliding = false
  self._isStillClicking = false
  self._isStillDragging = false
  self._isDown = false
  self._wasDown = false
  self._dragStartX = nil
  self._dragStartY = nil
  self._triggeredCallbackThisCycle = false

  self._hasFocus = false


  if args._isReal ~= nil then--unreal nodes are not drawn or interacted with
    self._isReal = args._isReal
  else
    self._isReal = true
  end
  self.enabled = args.enabled or (args.enabled == nil and true) --special state that allows nodes to have disabled behavior and look like a button
  self._invisible = args._invisible or false
  self._selected = args._selected or false --hint used for coloration
  
  self.debug = false

  self.x = args.x or 0
  self.y = args.y or 0
  self.w = args.w or 0
  self.h = args.h or 0


  
  

  self.color = args.color or {1, 1, 1}

	return self
end

function Self:destroy()
  self.contents:callall("destroy")
  self.callbacks:call("onDestroy", {self})
  self.contents:clear()
end

function Self:applySelectionColorTransformation()
  if self._selected then
    local color = love.graphics.getColor()
    love.graphics.setColor(color[1]*0.9, color[2]*0.9, color[3]*0.9)
  end
end

function Self:setPosition(x, y)
  self.x = x
  self.y = y
  self.x_starting_value = self.x
  self.y_starting_value = self.y
end

function Self:setColor(r, g, b, a)
  if type(r) == "table" then
    self.color = r
  else
    self.color = {r, g, b, a}
  end    
end

function Self:setReal(val)
  self._isReal = val
end

function Self:isReal()
  return self._isReal
end

function Self:draw()
  if not self:isReal() then
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
  local mx, my = require 'engine.Mouse':getPosition()
  local isMouseDown = love.mouse.isDown(1)
  local isMouseColliding = CHECK_COLLISION(mx, my, 0, 0, self:getX()-self.w/2, self:getY()-self.h/2, self.w, self.h)
  local wasStillColliding = self._isStillColliding
  local wasStillClicking = self._isStillClicking
  local wasStillDragging = self._isStillDragging
  local deltaColliding = isMouseColliding ~= self._isStillColliding
  local deltaClicking = isMouseDown ~= self.wasMouseDown
  local isTopNode = self:isTopNode(mx, my)
  local isWindowTopNode = self:getTopNode("Window").isWindow and self:getTopNode("Window"):isTopWindow(mx, my)
  local isLeaf = self:isLeaf(mx, my) and (isTopNode or isWindowTopNode)
  self._isStillColliding = self._isStillColliding and isMouseColliding and isLeaf
  self._isStillClicking = self._isStillClicking and isMouseDown
  self._isStillDragging = self._isStillDragging and isMouseDown

  if isMouseColliding and deltaColliding and isLeaf and not self.mouseDisabled then
    self._isStillColliding = true--begin collision tracking
    self.callbacks:call("onMouseEnter", {self, mx, my})
  end
  if self._isStillColliding and not self.mouseDisabled then
    self.callbacks:call("onHover", {self, mx, my})
  end
  if not isMouseColliding and deltaColliding and not self.mouseDisabled then
    self._isStillColliding = false--end collision tracking
    self.callbacks:call("onMouseExit", {self, mx, my})
  end

  if isMouseColliding and isMouseDown and deltaClicking and isLeaf and not self.mouseDisabled then
    self._isStillClicking = true--begin click
    self._isStillDragging = true--begin drag
    self.callbacks:call("onMousePressed", {self, mx, my})
    self.callbacks:call("onDragBegin", {self, mx, my})
    self._dragStartX = mx
    self._dragStartY = my
  end
  
  if not isMouseDown and deltaClicking and isMouseColliding and wasStillClicking and not self.mouseDisabled then
    self:setFocus()
    self.callbacks:call("onClicked", {self, mx, my})
  end
  if ((not isMouseDown and deltaClicking) or (isMouseDown and deltaColliding)) and self._isStillClicking and not self.mouseDisabled then
    self._isStillClicking = false--end click
    self.callbacks:call("onMouseReleased", {self, mx, my})
  end

  if not isMouseDown and deltaClicking and self.wasStillDragging and not self.mouseDisabled then
    self.callbacks:call("onDragEnd", {self, mx, my})
  end

  if self._isStillDragging and not self.mouseDisabled then
    self.callbacks:call("onDrag", {self, mx - self._dragStartX, my - self._dragStartY})
    self._dragStartX = mx
    self._dragStartY = my
  end


  self.wasMouseDown = isMouseDown
  self.wasColliding = isMouseColliding
end

function Self:isTopNode(x, y)
  if not self.z then
    return false
  end
  for index, otherNode in ipairs(self.main.contents.content_list) do
    if otherNode ~= self and otherNode._isReal and otherNode:hasPointCollision(x, y) then
      if (otherNode.z >= self.z and self.alwaysOnTop == otherNode.alwaysOnTop) or (otherNode.alwaysOnTop and not self.alwaysOnTop) then
        return false
      end
    end
  end
  return true
end

function Self:markForDeletion()
  self.contents:callall("markForDeletion")
  self._markedForDeletion = true
end

function Self:activate()
  self:setReal(true)
  self.callbacks:call("onActivate", {self})
end

function Self:deactivate()
  self:setReal(false)
  self.callbacks:call("onDeactivate", {self})
end
--[[
function Self:checkCallbacks_old()
  local calledCallback = false
  local mx, my = require 'engine.Mouse':getPosition()
  if love.mouse.isDown(1) then
    if CHECK_COLLISION(mx, my, 1, 1, self:getX()-self.w/2, self:getY()-self.h/2, self.w, self.h) then
      if self._dragStartX == nil then
        self._dragStartX = mx
        self._dragStartY = my
      end
      if not self._wasDown then
        self._isDown = true
        self.callbacks:call("onClick", {self, mx, my})
      end
    else
      self._isDown = false
    end
    if self._dragStartX ~= nil then
      self.callbacks:call("onDrag", {self, mx - self._dragStartX, my - self._dragStartY})
      calledCallback = true
      self._dragStartX = mx
      self._dragStartY = my
    end
    self._wasDown = true
  else
    if self._isDown and CHECK_COLLISION(mx, my, 1, 1, self:getX()-self.w/2, self:getY()-self.h/2, self.w, self.h) then
      self.callbacks:call("onClicked", {self, mx, my})
      calledCallback = true
    end
    self._isDown = false
    self._wasDown = false
    self._dragStartX = nil
    self._dragStartY = nil
  end
  return calledCallback
end]]

function Self:keypressed(key, scancode, isrepeat)
  --if not self:isReal() then
  --  return
  --end
  self.callbacks:call("keypressed", {self, key, scancode, isrepeat})
  self.contents:callall("keypressed", key, scancode, isrepeat)
end

function Self:textinput(text)
  --if not self:isReal() then
  --  return
  --end
  self.callbacks:call("textinput", {self, text})
  self.contents:callall("textinput", text)
end

function Self:update(dt)
  if not self:isReal() then
    return
  end
  self:applySelectionColorTransformation()
  self.callbacks:call("update", {self, dt})
  self.contents:callall("update", dt)
  self.contents:removeall(function(node) return node._markedForDeletion end)
  
  if not self.enabled then
    return
  end
  self:checkCallbacks()
end

function Self:insert(child, id)
  self.contents:insert(child, id)
  child.parent = self
  self.callbacks:call("onInsert", {self, child, id})
end

function Self:remove(child)
  self.contents:remove(child)
  child.parent = nil
  self.callbacks:call("onRemove", {self, child})
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
  return self:hasPointCollision(x, y) and (not self.contents:any("isLeaf", x, y) or self.contents:isEmpty())
end

function Self:bringToFront()
  --bring the node to front by accessing the z coordinate
  self.z = MAX_Z
  MAX_Z = MAX_Z + 1
end

function Self:hasFocus()
  return self._hasFocus or self.contents:any("hasFocus")
end

function Self:setFocus()
  for i, node in ipairs(self.FOCUS_LIST) do
    node._hasFocus = false
  end
  CLEAR(self.FOCUS_LIST)
  self._hasFocus = true
  table.insert(self.FOCUS_LIST, self)
end

function Self:getTopBorder()
  return self:getY() - self.h/2
end

function Self:getBottomBorder()
  return self:getY() + self.h/2
end

function Self:getLeftBorder()
  return self:getX() - self.w/2
end

function Self:getRightBorder()
  return self:getX() + self.w/2
end

function Self:mousemoved(x, y, dx, dy, istouch)
  self.contents:callall("mousemoved", x, y, dx, dy, istouch)
  
end

return Self

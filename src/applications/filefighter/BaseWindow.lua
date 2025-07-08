local Super = require 'engine.gui.Window'
local Self = Super:clone("Process")

Self.INTERNAL_NAME = "undefined"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_unknown_drive-3.png")

Self.reference = {}
setmetatable(Self.reference, {__mode = "v"})


function Self:init(args)
  args.title = args.title or "undefined"
  args._isReal = true
  Super.init(self, args)



  self.bar.close_button.callbacks:register("onClicked", function(x, y)
    self:setReal(false)
  end)

  self.callbacks:register("onMouseReleased", function(self, x, y)
    if self.main.desktop.hand then
        self.callbacks:call("onDropped", {self, self.main.desktop.hand, x, y})
    end
  end)

  return self
end



function Self:getTopBorder()
  return self:getY() - self.h/2 + 160
end

function Self:getCycles()
  return -1
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
  
  -- FIX: Add this check to prevent interaction when blocked by windows
  local isBlocked = self:isBlockedByWindow(mx, my)
  
  self._isStillColliding = self._isStillColliding and isMouseColliding and isLeaf and not isBlocked
  self._isStillClicking = self._isStillClicking and isMouseDown
  
  -- FIX: Only update dragging state if mouse is still down
  if isMouseDown then
    self._isStillDragging = self._isStillDragging and isMouseDown
  end

  if isMouseColliding and deltaColliding and isLeaf and not self.mouseDisabled and not isBlocked then
    self._isStillColliding = true--begin collision tracking
    self.callbacks:call("onMouseEnter", {self, mx, my})
  end
  
  if self._isStillColliding and not self.mouseDisabled and not isBlocked then
    self.callbacks:call("onHover", {self, mx, my})
    
    -- Handle static hover detection
    if mx == self._lastMouseX and my == self._lastMouseY then
      -- Mouse is stationary, increment timer
      self._hoverTimer = self._hoverTimer + love.timer.getDelta()
      
      if self._hoverTimer >= self._hoverDelay and not self._hoverStaticTriggered then
        -- Timer threshold reached, trigger static hover
        self._hoverStaticTriggered = true
        self.callbacks:call("onHoverStatic", {self, mx, my, self._hoverTimer})
      end
    else
      -- Mouse moved, reset timer
      self._hoverTimer = 0
      self._hoverStaticTriggered = false
      self._lastMouseX = mx
      self._lastMouseY = my
    end
  else
    -- Not hovering, reset timer state
    self._hoverTimer = 0
    self._hoverStaticTriggered = false
  end
  
  if not isMouseColliding and deltaColliding and not self.mouseDisabled then
    self._isStillColliding = false--end collision tracking
    self.callbacks:call("onMouseExit", {self, mx, my})
  end

  if isMouseColliding and isMouseDown and deltaClicking and isLeaf and not self.mouseDisabled and not isBlocked then
    self._isStillClicking = true--begin click
    self._isStillDragging = true--begin drag
    self.callbacks:call("onMousePressed", {self, mx, my})
    self.callbacks:call("onDragBegin", {self, mx, my})
    self._dragStartX = mx
    self._dragStartY = my
  end
  
  if not isMouseDown and deltaClicking and isMouseColliding and wasStillClicking and not self.mouseDisabled and not isBlocked then
    self:setFocus()
    self.callbacks:call("onClicked", {self, mx, my})
  end
  
  if ((not isMouseDown and deltaClicking) or (isMouseDown and deltaColliding)) and self._isStillClicking and not self.mouseDisabled then
    self._isStillClicking = false--end click
    self.callbacks:call("onMouseReleased", {self, mx, my})
  end

  -- FIX: This is the critical change - properly handle drag end
  if wasStillDragging and (not isMouseDown or (deltaClicking and not isMouseDown)) and not self.mouseDisabled then
    self._isStillDragging = false -- End dragging
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

function Self:isBlockedByWindow(x, y)
  -- Skip check if this node is already part of a window
  if self:getTopNode("Window").isWindow then
    return false
  end
  
  -- Check if any window is blocking this node
  for index, otherNode in ipairs(self.main.contents.content_list) do
    if otherNode ~= self and otherNode._isReal and otherNode.isWindow and otherNode:hasPointCollision(x, y) then
      -- If there's a window at this position with higher or equal z-order, we're blocked
      if otherNode.z >= (self.z or 0) then
        return true
      end
    end
  end
  return false
end

return Self

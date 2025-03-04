local Super = require 'engine.gui.Node'
local Self = Super:clone("Window")

function Self:init(args)
  Super.init(self, args)

  
  self.alwaysOnTop = args.alwaysOnTop
  self.w = args.w
  self.h = args.h
  self.z = args.z or MAX_Z
  self.title = args.title
  if not args.z then
    MAX_Z = MAX_Z + 1
  end

  self._wasDown = false
  self._isDown = false
  self.bar = require 'engine.gui.Bar':new{main=args.main,x = 0, y = -self.h/2 - 8+16 , w = self.w, h = 32, title = self.title}
  self:insert(self.bar)
  self.bar.close_button = require 'engine.gui.Button':new{main=self.main,x = self.bar.w/2 - 8, y = 0, w = 10, h = 10, text = "x", text_color = {0,0,0}}
  self.bar.close_button.text:setFont(FONTS["dialog"])
  self.bar.close_button.text.x = 1
  self.bar.close_button.text.y = -2
  self.bar.close_button.callbacks:register("onClicked", function(x, y)
    self:close()
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

function Self:finalize()
end

function Self:open()
  self:activate()
end

function Self:isOpen()
  return self._isReal
end

function Self:close()
  self:deactivate()
  self:setFocus()
end


function Self:execute(terminal, command)
  terminal:appendLog("Unknown command: " .. (command or ""))
end

function Self:draw()
  if not self:isReal() then
    return
  end
  self:applySelectionColorTransformation()
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
    if window ~= self and window._isReal and window:hasPointCollision(x, y) then
      return false
    end
  end
  return true
end

function Self:isTopWindow(x, y)
  for index, window in ipairs(self.main.contents.content_list) do
    if window.isWindow then
      if window ~= self and window._isReal and window:hasPointCollision(x, y) then
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
  local wasStillColliding = self._isStillColliding
  local wasStillClicking = self._isStillClicking
  local wasStillDragging = self._isStillDragging
  local deltaColliding = isMouseColliding ~= self._isStillColliding
  local deltaClicking = isMouseDown ~= self.wasMouseDown
  local isLeaf = self:isLeaf(mx, my)
  self._isStillColliding = self._isStillColliding and isMouseColliding
  self._isStillClicking = self._isStillClicking and isMouseDown
  self._isStillDragging = self._isStillDragging and isMouseDown

  if isMouseColliding and deltaColliding then
    self._isStillColliding = true--begin collision tracking
    self.callbacks:call("onMouseEnter", {self, mx, my})
  end
  if self._isStillColliding then
    self.callbacks:call("onHover", {self, mx, my})
  end
  if not isMouseColliding and deltaColliding then
    self._isStillColliding = false--end collision tracking
    self.callbacks:call("onMouseExit", {self, mx, my})
  end

  if isMouseColliding and isMouseDown and deltaClicking then
    self._isStillClicking = true--begin click
    self._isStillDragging = true--begin drag
    self.callbacks:call("onMousePressed", {self, mx, my})
    self.callbacks:call("onDragBegin", {self, mx, my})
    self._dragStartX = mx
    self._dragStartY = my
  end
  if not isMouseDown and deltaClicking and isMouseColliding and wasStillClicking then
    if self:isTopWindow(mx, my) and not self:hasFocus() then self:setFocus() end
    self.callbacks:call("onClicked", {self, mx, my})
  end
  if (not isMouseDown and deltaClicking) or (isMouseDown and deltaColliding) then
    self._isStillClicking = false--end click
    self.callbacks:call("onMouseReleased", {self, mx, my})
  end

  if not isMouseDown and deltaClicking and self.wasStillDragging then
    self.callbacks:call("onDragEnd", {self, mx, my})
  end

  if self._isStillDragging then
    self.callbacks:call("onDrag", {self, mx - self._dragStartX, my - self._dragStartY})
    self._dragStartX = mx
    self._dragStartY = my
  end


  self.wasMouseDown = isMouseDown
  self.wasColliding = isMouseColliding
end



return Self

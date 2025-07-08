local Super = require 'engine.gui.Node'
local Self = Super:clone("Cage")


local function closestPointOnRectangleBorder(px, py, cx, cy, w, h)
  -- Calculate half dimensions
  local hw, hh = w / 2, h / 2

  -- Compute rectangle borders based on the center
  local left   = cx - hw
  local right  = cx + hw
  local top    = cy - hh
  local bottom = cy + hh

  -- Clamp the point to the rectangle boundaries
  local clampedX = math.max(left, math.min(px, right))
  local clampedY = math.max(top,  math.min(py, bottom))

  -- If the point is inside the rectangle, calculate which border is closest
  if px >= left and px <= right and py >= top and py <= bottom then
      local dTop    = math.abs(py - top)
      local dBottom = math.abs(py - bottom)
      local dLeft   = math.abs(px - left)
      local dRight  = math.abs(px - right)

      local minDist = math.min(dTop, dBottom, dLeft, dRight)
      if minDist == dTop then
          return px, top
      elseif minDist == dBottom then
          return px, bottom
      elseif minDist == dLeft then
          return left, py
      else -- minDist == dRight
          return right, py
      end
  end

  -- If the point is outside, return the clamped position (which lies on the border)
  return clampedX, clampedY
end


-- Function to find closest point on rectangle border to a given point
function Self:closestBorderPoint(px, py)
  return closestPointOnRectangleBorder(px, py, self:getX(), self:getY(), self.w, self.h)
end

function Self:init(args)
  Super.init(self, args)


  self.captureMouse = false

  self.exitPoint = args.exitPoint or {x = 0, y = 0}
  self.blast_timer_max = 5
  self.blast_timer = self.blast_timer_max
  
  self.callbacks:register("onInsert", function(self, node, id)
    node.mouseDisabled = true
  end)

  self.callbacks:register("onMousePressed", function(self)
  end)
  
  self.callbacks:register("update", function(self, dt)
    if self.blast_timer > 0 and self.captureMouse then
      self.blast_timer = self.blast_timer - dt
    end
    if self.blast_timer <= 0 and self.captureMouse then
      self:exitMouse()
    end
  end)

  local virus_count = self.main.values:get(VALUE_VIRUS_FOUND_COUNT) or 0
  for i=1, virus_count do
    self:makeVirus()
  end

	return self
end

function Self:makeVirus()
  self:insert(require 'src.applications.dummy.gui.elements.viruses.Alan':new{
    main = self.main,
    cage = self,
    x = math.random(-self.w/2 + 5, self.w/2 - 5),
    y = math.random(-self.h/2 + 5, self.h/2 - 5),
  })
end

function Self:enterMouse()
  self.captureMouse = true
  require 'engine.Mouse':setPosition(self:getX(), self:getY())
  self.blast_timer = self.blast_timer_max

  self.contents:forall(function(node)
    node.mouseDisabled = false
  end)
end

function Self:exitMouse()
  self.captureMouse = false
  self.blast_timer = self.blast_timer_max
  require 'engine.Mouse':setPosition(self.exitPoint.x, self.exitPoint.y)

  self.contents:forall(function(node)
    node.mouseDisabled = true
  end)
end



function Self:draw()
  if not self:isReal() then
    return
  end
  self:applySelectionColorTransformation()
  
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", -self.w/2, -self.h/2, self.w, self.h)
  
  love.graphics.setColor((255)/255, 128/255, 128/255)
  love.graphics.rectangle("line", -self.w/2, -self.h/2, self.w, self.h)


  love.graphics.setColor(1, 1, 1)
  self.contents:callall("draw")

  love.graphics.pop()

end

local function xor(a, b)
  return (a or b) and not (a and b)
end



function Self:mousemoved(x, y, dx, dy, istouch)
  local mx, my = require'engine.Mouse':getPosition()
  if self:hasPointCollision(mx, my) and not self.captureMouse then
    local tx, ty = self:closestBorderPoint(mx, my)
    --require 'engine.Mouse':setPosition(tx, ty)
  end
  if not self:hasPointCollision(mx, my) and self.captureMouse then
    local tx, ty = self:closestBorderPoint(mx, my)
    require 'engine.Mouse':setPosition(tx, ty)
  end
  self.contents:callall("mousemoved", x, y, dx, dy, istouch)
end

return Self

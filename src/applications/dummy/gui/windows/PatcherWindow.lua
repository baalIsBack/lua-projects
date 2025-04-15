local Super = require 'applications.dummy.gui.windows.Process'
local Self = Super:clone("PatcherWindow")

Self.ID_NAME = "patcher"

function Self:init(args)
  args.w = 320
  args.h = 240
  Super.init(self, args)
  

  self.callbacks:register("update", self._update)
  self.callbacks:register("onActivate", self._onOpen)
  self.callbacks:register("onDrag", self._onDrag)

  self.callbacks:register("onDragBegin", function(selff, x, y)
    if self:getTopNode("Window"):isTopWindow(x, y) and self:isLeaf(x, y) then
      self.legalDrag = true
    else
      self.legalDrag = false
    end
  end)
  self.callbacks:register("onDragEnd", function(selff, x, y)
    self.legalDrag = false
  end)

  self.translation = {x = 0, y = 0}

  return self
end

function Self:_onDrag(dx, dy)
  if self.legalDrag then
    self.translation.x = self.translation.x + dx
    self.translation.y = self.translation.y + dy
  end
end

function Self:_onOpen()
  self.translation = {x = 0, y = 0}
end


function Self:draw()
  if not self:isReal() then
    return
  end
  local p = self.main.patcher
  self:applySelectionColorTransformation()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)
  local previous_font = love.graphics.getFont()
  love.graphics.setFont(FONT_DEFAULT)

  --c0c0c0 192/255
  love.graphics.setColor(192/255, 192/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)
  
  -- Define the stencil function to restrict drawing to window area
  local stencilFunc = function()
    -- Use the same rectangle as the window's inner area
    love.graphics.rectangle("fill", math.floor(-(self.w/2)), math.floor(-(self.h/2)), self.w, self.h)
  end
  
  -- Enable stencil testing - only draw where stencil function drew
  love.graphics.stencil(stencilFunc, "replace", 1)
  love.graphics.setStencilTest("greater", 0)

  -- All drawing that should be clipped by stencil goes here
  love.graphics.push()
  love.graphics.translate(self.translation.x, self.translation.y)
  for q, v in pairs(p.hexes) do
    for r, w in pairs(v) do
      for s, hex in pairs(w) do
        local corners = polygon_corners_flattened(p.layout, hex)
        love.graphics.polygon("line", corners)

      end
    end
  end
  love.graphics.pop()
  
  -- Disable stencil testing
  love.graphics.setStencilTest()
  
  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end


function Self:_update(dt)
  local p = self.main.patcher
  local mx, my = require 'engine.Mouse':getPosition()
  local rmx, rmy = mx - self.x - self.translation.x, my - self.y - self.translation.y
  if love.mouse.isDown(2) then
    local h = pixel_to_hex(p.layout, Point(rmx, rmy))
    h = hex_round(h)
    if not p.hexes[h.q] then
      p.hexes[h.q] = {}
    end
    if not p.hexes[h.q][h.r] then
      p.hexes[h.q][h.r] = {}
    end
    if not p.hexes[h.q][h.r][h.s] then
      p.hexes[h.q][h.r][h.s] = h
    end
  end
end


return Self
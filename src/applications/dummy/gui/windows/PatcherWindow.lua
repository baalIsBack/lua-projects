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


  self.export_button = require 'engine.gui.Button':new{main=self.main, text = "Export", x = self.w/2 - 50/2 - 4, y = -self.h/2 + 16 + 14/2 + 4, w = 50, h = 14,}
  self:insert(self.export_button)
  self.export_button.callbacks:register("onClicked", function()
    love.system.setClipboardText(self.main.patcher:exportStructureToString())
  end)

  self.import_button = require 'engine.gui.Button':new{main=self.main, text = "Import", x = self.w/2 - 50/2 - 4, y = -self.h/2 + 16 + 14/2 + 4 + 14+4, w = 50, h = 14,}
  self:insert(self.import_button)
  self.import_button.callbacks:register("onClicked", function()
    local str = love.system.getClipboardText()
    self.main.patcher:importStructureFromString(str)
  end)
  

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
        love.graphics.push()
        love.graphics.polygon("line", corners)
        love.graphics.pop()
      end
    end
  end
  for q, v in pairs(p.connections) do
    for r, w in pairs(v) do
      for s, hex in pairs(w) do
        --local corners = polygon_corners_flattened(p.layout, hex)
        local hexPosition = hex_to_pixel(p.layout, hex)
        love.graphics.push()
        love.graphics.circle("line", hexPosition.x, hexPosition.y, 5)
        for i = 1, 6, 1 do
          if hex.links[i] then
            love.graphics.push()
            love.graphics.translate(hexPosition.x, hexPosition.y)
            love.graphics.rotate(i * 2 * math.pi / 6)
            love.graphics.translate(-hexPosition.x, -hexPosition.y)
            love.graphics.line(hexPosition.x, hexPosition.y, hexPosition.x+p.layout.size.x, hexPosition.y)
            love.graphics.pop()
          end
        end
        love.graphics.pop()
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
  local mx, my = require 'engine.Mouse':getPosition()
  local rmx, rmy = mx - self.x - self.translation.x, my - self.y - self.translation.y
  if love.keyboard.isDown("a") then
    if not self.main.patcher:getHex(rmx, rmy) then
      self.main.patcher:makeHex(rmx, rmy)
    end
  end
  if love.keyboard.isDown("s") then
    self.main.patcher:removeHex(rmx, rmy)
  end
  if love.keyboard.isDown("q") then
    if not self.main.patcher:getTransition(rmx, rmy) then
      self.main.patcher:makeTransition(rmx, rmy)
    end
  end
  if love.keyboard.isDown("w") then
    self.main.patcher:removeTransition(rmx, rmy)
  end
  
  
  if love.keyboard.isDown("1") then
    local trans = self.main.patcher:getTransition(rmx, rmy)
    if trans then
      trans.links[1] = not trans.links[1]
    end
  end
  if love.keyboard.isDown("2") then
    local trans = self.main.patcher:getTransition(rmx, rmy)
    if trans then
      trans.links[2] = not trans.links[2]
    end
  end
  if love.keyboard.isDown("3") then
    local trans = self.main.patcher:getTransition(rmx, rmy)
    if trans then
      trans.links[3] = not trans.links[3]
    end
  end
  if love.keyboard.isDown("4") then
    local trans = self.main.patcher:getTransition(rmx, rmy)
    if trans then
      trans.links[4] = not trans.links[4]
    end
  end
  if love.keyboard.isDown("5") then
    local trans = self.main.patcher:getTransition(rmx, rmy)
    if trans then
      trans.links[5] = not trans.links[5]
    end
  end
  if love.keyboard.isDown("6") then
    local trans = self.main.patcher:getTransition(rmx, rmy)
    if trans then
      trans.links[6] = not trans.links[6]
    end
  end
end


return Self
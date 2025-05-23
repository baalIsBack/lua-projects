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
  self.debug = true


  self.export_button = require 'engine.gui.Button':new{main=self.main, text = "Export", x = self.w/2 - 50/2 - 4, y = -self.h/2 + 16 + 14/2 + 4, w = 50, h = 14,}
  self:insert(self.export_button)
  self.export_button.callbacks:register("onClicked", function()
    local str = self.main.patcher:exportStructureToString()
    love.system.setClipboardText(str)
    success, message = love.filesystem.write( "skilltree.dat", str )
  end)

  self.import_button = require 'engine.gui.Button':new{main=self.main, text = "Import", x = self.w/2 - 50/2 - 4, y = -self.h/2 + 16 + 14/2 + 4 + 14+4, w = 50, h = 14,}
  self:insert(self.import_button)
  self.import_button.callbacks:register("onClicked", function()
    local str = love.system.getClipboardText()
    local str, size = love.filesystem.read( "skilltree.dat" )
    self.main.patcher:importStructureFromString(str)
  end)

  self.debug_button = require 'engine.gui.Button':new{main=self.main, text = "Debug", x = self.w/2 - 50/2 - 4, y = -self.h/2 + 16 + 14/2 + 4 + 2*(14+4), w = 50, h = 14,}
  self:insert(self.debug_button)
  self.debug_button.callbacks:register("onClicked", function()
    self.debug = not self.debug
    print("debug", self.debug)
  end)

  self.link_button = require 'engine.gui.Button':new{main=self.main, text = "Link", x = self.w/2 - 50/2 - 4, y = -self.h/2 + 16 + 14/2 + 4 + 3*(14+4), w = 50, h = 14,}
  self:insert(self.link_button)
  self.link_button.callbacks:register("onClicked", function()
    self.main.patcher:createFullLinks()
  end)

  self.selectedTransition = nil


  self.callbacks:register("onClicked", function(selff, x, y)
    local mx, my = require 'engine.Mouse':getPosition()
    local rmx, rmy = mx - self.x - self.translation.x, my - self.y - self.translation.y
    if self.debug then
      local transition = self.main.patcher:getTile(rmx, rmy)
      local hex = self.main.patcher:getTile(rmx, rmy)
      if transition then
        if transition == self.selectedTransition then
          self.selectedTransition = nil
        elseif self.selectedTransition then
          local dir = self.main.patcher:getTileDirection(self.selectedTransition, transition)
          local isNeighbor = self.main.patcher:isNeighbor(self.selectedTransition, transition)
          if dir then
            self.selectedTransition.links[dir] = not self.selectedTransition.links[dir]
            local antiDir = (dir + 3-1) % 6 + 1
            transition.links[antiDir] = not transition.links[antiDir]
            self.selectedTransition = transition
          end
        else
          self.selectedTransition = transition
        end
      end
      if hex and self.selectedTransition then
        local isContained = nil
        for i, v in ipairs(self.selectedTransition.sources) do
          if v.q == hex.q and v.r == hex.r and v.s == hex.s then
            isContained = i
            break
          end
        end
        if isContained then
          table.remove(self.selectedTransition.sources, isContained)
          print("remove")
          print("selectedTransition", self.selectedTransition.q, self.selectedTransition.r, self.selectedTransition.s)
          print("hex", hex.q, hex.r, hex.s)
        else
          table.insert(self.selectedTransition.sources, hex)
          print("added")
          print("selectedTransition", self.selectedTransition.q, self.selectedTransition.r, self.selectedTransition.s)
          print("hex", hex.q, hex.r, hex.s)
        end
      end
    end
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
  for q, v in pairs(p.tiles) do
    for r, w in pairs(v) do
      for s, hex in pairs(w) do
        if hex.kind == "hex" then
          self:drawHex(hex, q, r, s)
        elseif hex.kind == "transition" then
          self:drawTransition(hex, q, r, s)
        
        else
          local hexPosition = hex_to_pixel(p.layout, hex)
          love.graphics.setColor(1, 0, 0, 0.5)
          love.graphics.push()
          love.graphics.translate(hexPosition.x, hexPosition.y)
          love.graphics.rotate(1 * 2 * math.pi / 6)
          love.graphics.translate(-hexPosition.x, -hexPosition.y)
          love.graphics.line(hexPosition.x, hexPosition.y, hexPosition.x+p.layout.size.x, hexPosition.y)
          love.graphics.pop()
        end
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

function Self:drawHex(hex, q, r, s)
  local p = self.main.patcher
  local corners = polygon_corners_flattened(p.layout, hex)
  local hexPosition = hex_to_pixel(p.layout, hex)
  if p:isBought(hex) then
    love.graphics.setColor(0, 1, 0, 0.5)
  elseif p:isUnlocked(hex) then
    love.graphics.setColor(0.25, 0.5, 0.25, 0.5)
  else
    love.graphics.setColor(1, 1, 1, 0.5)
  end
  love.graphics.polygon("fill", corners)


  if self.debug and self.selectedTransition and self.selectedTransition.q == hex.q and self.selectedTransition.r == hex.r and self.selectedTransition.s == hex.s then
    love.graphics.setColor(1, 0, 0, 0.5)
  else
    love.graphics.setColor(1, 1, 1, 0.5)
  end
  love.graphics.polygon("line", corners)

  if self.debug then
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(hex.id, hexPosition.x-8, hexPosition.y)
  end
  self:drawLinks(hex)
end

function Self:drawTransition(hex, q, r, s)
  local p = self.main.patcher
  --local corners = polygon_corners_flattened(p.layout, hex)
  local hexPosition = hex_to_pixel(p.layout, hex)
  love.graphics.push()
  love.graphics.setColor(1, 1, 1, 0.5)
  if self.debug and self.selectedTransition and self.selectedTransition.q == hex.q and self.selectedTransition.r == hex.r and self.selectedTransition.s == hex.s then
    for i, a in ipairs(self.selectedTransition.sources) do
      love.graphics.setColor(1, 0, 0, 0.5)
      love.graphics.push()
      local aPosition = hex_to_pixel(p.layout, a)
      local transitionPosition = hex_to_pixel(p.layout, self.selectedTransition)
      --love.graphics.line(aPosition.x, aPosition.y, transitionPosition.x, transitionPosition.y)
      love.graphics.pop()
    end
    love.graphics.setColor(1, 0, 0, 0.5)
  end
  love.graphics.circle("line", hexPosition.x, hexPosition.y, 5)
  if self.debug then
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(hex.id, hexPosition.x-8, hexPosition.y)
  end
  self:drawLinks(hex)
  love.graphics.pop()
end

function Self:drawLinks(hex)
  local p = self.main.patcher
  local hexPosition = hex_to_pixel(p.layout, hex)
  love.graphics.setColor(1, 1, 1, 0.5)
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
end


function Self:_update(dt)
  local mx, my = require 'engine.Mouse':getPosition()
  local rmx, rmy = mx - self.x - self.translation.x, my - self.y - self.translation.y
  
  if love.keyboard.isDown("b") then
    local t = self.main.patcher:getTile(rmx, rmy)
    if t then
      self.main.patcher:buy(t)
      self.selectedTransition = nil
    end
  end
  if love.keyboard.isDown("r") then
    local t = self.main.patcher:getTile(rmx, rmy)
    if t then
      self.main.patcher:sell(t)
      self.selectedTransition = nil
    end
  end
  
  if self.debug then
    if love.keyboard.isDown("a") then
      if not self.main.patcher:getTile(rmx, rmy) then
        self.main.patcher:makeTile("hex", {x=rmx, y=rmy})
      self.selectedTransition = nil
      end
    end
    if love.keyboard.isDown("s") then
      self.main.patcher:removeTile(rmx, rmy)
      self.selectedTransition = nil
    end
    if love.keyboard.isDown("q") then
      if not self.main.patcher:getTile(rmx, rmy) then
        self.main.patcher:makeTile("transition", {x=rmx, y=rmy})
      self.selectedTransition = nil
      end
    end
    if love.keyboard.isDown("w") then
      self.main.patcher:removeTile(rmx, rmy)
      self.selectedTransition = nil
    end
    
    if love.keyboard.isDown("y") then
      if not self.main.patcher:getTile(rmx, rmy) then
        local h = self.main.patcher:makeTile("hex", {x=rmx, y=rmy})
        h.startingNode = true
        self.selectedTransition = nil
      end
    end


    
    
    if love.keyboard.isDown("1") then
      local trans = self.main.patcher:getTile(rmx, rmy)
      if trans then
        trans.links[1] = not trans.links[1]
      end
    end
    if love.keyboard.isDown("2") then
      local trans = self.main.patcher:getTile(rmx, rmy)
      if trans then
        trans.links[2] = not trans.links[2]
      end
    end
    if love.keyboard.isDown("3") then
      local trans = self.main.patcher:getTile(rmx, rmy)
      if trans then
        trans.links[3] = not trans.links[3]
      end
    end
    if love.keyboard.isDown("4") then
      local trans = self.main.patcher:getTile(rmx, rmy)
      if trans then
        trans.links[4] = not trans.links[4]
      end
    end
    if love.keyboard.isDown("5") then
      local trans = self.main.patcher:getTile(rmx, rmy)
      if trans then
        trans.links[5] = not trans.links[5]
      end
    end
    if love.keyboard.isDown("6") then
      local trans = self.main.patcher:getTile(rmx, rmy)
      if trans then
        trans.links[6] = not trans.links[6]
      end
    end
  end

  
end


return Self
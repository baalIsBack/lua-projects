local Super = require 'engine.Prototype'
local Self = Super:clone("Grid")


local originHexes = {
  {0, 3, -3},
  {0, 4, -4},
  {0, 5, -5},
  {0, 6, -6},
  {0, 7, -7},
}

local middleHex = Hex(0, 5, -5)

function Self:init()
  self.layout = Layout(layout_flat, Point(24, 24), Point(24, 24))
  
  self.translation_x = 300

  self.points = 0

  self.hexes = {}
  self.hexlist = {}

  self.tweens = {}

  self.mapDots = {}
  for i=1, 400 do
    table.insert(self.mapDots, {
      x = math.random(0, 800),
      y = math.random(0, 600),
      size = 1
    })
  end

  for dist = 0, 3, 1 do
    for _, hex in ipairs(originHexes) do
      local h = Hex(hex[1], hex[2], hex[3])
      local neighbors = hex_circle(h, dist)
      for i, v in ipairs(neighbors) do
        if self.hexes[v.q] == nil or self.hexes[v.q][v.r] == nil or self.hexes[v.q][v.r][v.s] == nil then
          table.insert(self.hexlist, v)
          self:addHex(v)
          v.distanceFromMiddle = hex_distance(v, middleHex)
          v.distanceFromBorder = math.min(
            hex_distance(v, Hex(-3, 3, 0)),
            hex_distance(v, Hex(0, 0, -0)),
            hex_distance(v, Hex(3, 0, -3)),
            hex_distance(v, Hex(-3, 10, -7)),
            hex_distance(v, Hex(0, 10, -10)),
            hex_distance(v, Hex(3, 7, -10))
          )
        end        
      end
    end
  end


  self:setupGameboard()

  self.selection = nil

  self.freeElements = {}

  return self
end

function Self:determineGamepieces()
  local pieces = {}

  for i = 1, 3 do
    table.insert(pieces, require 'applications.hex.elements.TriangleUp')
  end

  for i = 1, 5 do
    table.insert(pieces, require 'applications.hex.elements.Heptagon')
  end
  for i = 1, 5 do
    table.insert(pieces, require 'applications.hex.elements.Pentagon')
  end
  for i = 1, 5 do
    table.insert(pieces, require 'applications.hex.elements.Square')
  end
  for i = 1, 5 do
    table.insert(pieces, require 'applications.hex.elements.Octagon')
  end
  for i = 1, 5 do
    table.insert(pieces, require 'applications.hex.elements.Nonagon')
  end

  local table_shuffle = require 'lib.shuffle'
  table_shuffle(pieces)
  for i=1, 4 do
    table.insert(pieces, math.random(1, #pieces), require 'applications.hex.elements.Lock')
  end

  return pieces
end



function Self:setupGameboard()
  self.locklevel = 1
  local hexLayers = {}
  for _, hex in ipairs(self.hexlist) do
    if not hexLayers[hex.distanceFromBorder] then
      hexLayers[hex.distanceFromBorder] = {}
    end
    table.insert(hexLayers[hex.distanceFromBorder], hex)
  end

  local entitys = self:determineGamepieces()
  local entityPairs = {}
  for i=1, math.floor(#self.hexlist/2) do
    -- make random char
    local Element = entitys[1]
    table.remove(entitys, 1)
    local a = Element:new{grid=self}
    local b = nil
    if a:type() == "TriangleUp" then
      b = require 'applications.hex.elements.TriangleDown':new{grid=self}
    elseif a:type() == "Lock" then
      b = require 'applications.hex.elements.Key':new{grid=self}
    else
      b = Element:new{grid=self}
    end
    table.insert(entityPairs, {a, b})
  end

  local entityPairsFlattened = {}
  for i, pair in ipairs(entityPairs) do
    table.insert(entityPairsFlattened, pair[1])
    table.insert(entityPairsFlattened, pair[2])
  end

  for i, layer in pairs(hexLayers) do
    local table_shuffle = require 'lib.shuffle'
    table_shuffle(layer)
    for j, hex in ipairs(layer) do
      hex.content = entityPairsFlattened[1]
      if hex.content then
        hex.content.hex = hex
        hex.content.tween.x = hex_to_pixel(self.layout, hex).x
        hex.content.tween.y = hex_to_pixel(self.layout, hex).y
      end
      table.remove(entityPairsFlattened, 1)
    end
  end

  local middleHex = self:get(middleHex)
  local position = hex_to_pixel(self.layout, middleHex)
  middleHex.content = require 'applications.hex.elements.Omega':new{grid=self, x = position.x, y = position.y}
  middleHex.content.hex = middleHex
end

function Self:draw()

  love.graphics.setBackgroundColor(232/255, 210/255, 130/255)

  for i, dot in ipairs(self.mapDots) do
    --love.graphics.setColor(218/255, 177/255, 99/255)
    love.graphics.setColor(206/255, 146/255, 72/255)
    love.graphics.rectangle("fill", dot.x, dot.y, dot.size*2, 2*dot.size)
  end

  love.graphics.push()
  love.graphics.translate(self.translation_x, 0)
  

  for q, v in pairs(self.hexes) do
    for r, w in pairs(v) do
      for s, hex in pairs(w) do
        love.graphics.setColor(218/255, 177/255, 99/255)
        local corners = polygon_corners_flattened(self.layout, hex)
        love.graphics.polygon("line", corners)
        local p = hex_to_pixel(self.layout, hex)
        local hx, hy = p.x, p.y
        if hex.content then
          hex.content:draw()
        end
        --love.graphics.circle("line", corners[5], corners[6], 50, 50)

      end
    end
  end

  for i, element in ipairs(self.freeElements) do
    element:draw()
  end

  love.graphics.push()
  love.graphics.setColor(0, 0, 0)

  local corners = polygon_corners_flattened(self.layout, middleHex)
  local p = hex_to_pixel(self.layout, middleHex)
  love.graphics.translate(p.x, p.y)
  love.graphics.scale(0.9, 0.9)
  love.graphics.translate(-p.x, -p.y)
  love.graphics.polygon("fill", corners)
  
  love.graphics.pop()

  love.graphics.setColor(1, 1, 1)
  local middleHex = self:get(middleHex)
  local corners = polygon_corners_flattened(self.layout, middleHex)
  love.graphics.polygon("line", corners)
  local p = hex_to_pixel(self.layout, middleHex)
  local hx, hy = p.x, p.y
  if middleHex.content then
    middleHex.content.x = hx
    middleHex.content.y = hy
    middleHex.content:draw()
  end

  love.graphics.setColor(0.2, 0.2, 0.2)
  local midPoint = hex_to_pixel(self.layout, middleHex)
  local pointsText = love.graphics.newText(love.graphics.getFont(), tostring(self.points))
  love.graphics.draw(pointsText, midPoint.x, midPoint.y + 200+40, 0, 1, 1, pointsText:getWidth()/2, pointsText:getHeight()/2)

  love.graphics.pop()
end

function Self:update(dt)
  local mx, my = love.mouse.getPosition()--require 'engine.Mouse':getPosition()
  mx = mx - self.translation_x
  if love.mouse.isDown(1) then
    local h = pixel_to_hex(self.layout, Point(mx, my))
    h = hex_round(h)
    --self:addHex(h)
  end

  for i=#self.tweens, 1, -1 do
    local tween = self.tweens[i]
    local complete = tween:set(love.timer.getTime() - tween.startTime)
    if complete then
      table.remove(self.tweens, i)
    end
  end

  for i, hex in ipairs(self.hexlist) do
    if hex.content then
      hex.content:update(dt)
    end
  end

  for i, element in ipairs(self.freeElements) do
    element:update(dt)
  end

  if self.finalTween and self.finalTween:isDone() then
    self.finalTween = nil
    self:finishLevel()
  end
end

function Self:mousepressed(x, y, button, istouch, presses)

  local mx, my = love.mouse.getPosition()--require 'engine.Mouse':getPosition()
  mx = mx - self.translation_x
  local h = pixel_to_hex(self.layout, Point(mx, my))
  h = hex_round(h)
  h = self.hexes[h.q] and self.hexes[h.q][h.r] and self.hexes[h.q][h.r][h.s]
  if not h and self.selection then
    self:deselectHex()
  elseif h and self.selection == nil and h.content and not self:isBlocked(h) and h.content:isOpen() and h.content:canResolveItself() then
    self:resolveSingle(h)
  elseif h and self.selection == nil and h.content and love.keyboard.isDown("a") then
    h.content = nil
  elseif h and self.selection == nil and h.content and not self:isBlocked(h) and h.content:isOpen() then
    self:selectHex(h)
  elseif h and self.selection == h then
    self:deselectHex()
  elseif h and not self:isBlocked(h) and h.content and not self:isBlocked(h) and h.content:isOpen()  then
    self:resolve(h)
  end
end

function Self:get(hex)
  return self.hexes[hex.q] and self.hexes[hex.q][hex.r] and self.hexes[hex.q][hex.r][hex.s]
end

function Self:addHex(hex)
  assert(hex, "Hex cannot be nil")
  assert(hex.q and hex.r and hex.s, "Hex must have q, r, and s coordinates")
  if not self.hexes[hex.q] then
    self.hexes[hex.q] = {}
  end
  if not self.hexes[hex.q][hex.r] then
    self.hexes[hex.q][hex.r] = {}
  end
  if not self.hexes[hex.q][hex.r][hex.s] then
    self.hexes[hex.q][hex.r][hex.s] = hex
  end
end

function Self:isBlocked(hex)
  assert(hex, "Hex cannot be nil")
  assert(self:get(hex), "Hex must be in hexes")
  local neighbors = hex_neighbors(hex)
  return  (self:get(neighbors[1]) and self:get(neighbors[1]).content and
            self:get(neighbors[1+3]) and self:get(neighbors[1+3]).content) or
          (self:get(neighbors[2]) and self:get(neighbors[2]).content and
            self:get(neighbors[2+3]) and self:get(neighbors[2+3]).content) or
          (self:get(neighbors[3]) and self:get(neighbors[3]).content and
            self:get(neighbors[3+3]) and self:get(neighbors[3+3]).content) 
end

function tweenFuseRightPriority(tween1, tween2)
  for i, v in pairs(tween1.target) do
    if tween2.target[i] == nil then
      tween2.target[i] = v
    end
  end
end

function Self:newTween(duration, subject, target, easing)
  for i, tween in ipairs(self.tweens) do
    if tween.subject == subject and false then
      tween:set(tween.duration)
      local oldTween = self.tweens[i]
      local newTween = Tween.new(duration, subject, target, easing)
      tweenFuseRightPriority(oldTween, newTween)
      self.tweens[i] = newTween
      newTween.startTime = love.timer.getTime()
      return self.tweens[i]
    end
  end
  local tween = Tween.new(duration, subject, target, easing)
  tween.startTime = love.timer.getTime()
  table.insert(self.tweens, tween)
  return tween
end

function Self:selectHex(hex)
  if self:isBlocked(hex) then
    return false
  end

  self.selection = hex
  self.selection.content.selected = true
  self.selection.content:select()
  

  return true
end

function Self:deselectHex()
  

  if self.selection.content then
    self.selection.content:deselect()
    self.selection.content.selected = nil
  end
  self.selection = nil

  return false
end

function Self:resolve(hex)
  local elementSelected = self.selection and self.selection.content
  local elementToResolve = hex and hex.content
  if elementSelected:canSolve(elementToResolve) then
    -- remove both elements

    local e1, e2 = self.selection.content, hex.content
    local midPoint = hex_to_pixel(self.layout, middleHex)
    midPoint[1] = midPoint.x
    midPoint[2] = midPoint.y
    table.insert(self.freeElements, e1)
    table.insert(self.freeElements, e2)
    
    self:newTween(0.3, e1.tween, {x=midPoint[1], y=midPoint[2], sx=1, sy=1}, 'outCubic')
    self:newTween(0.3, e2.tween, {x=midPoint[1], y=midPoint[2], sx=1, sy=1}, 'outCubic')

    e1:deselect()
    e2:deselect()
    e1:resolve()
    e2:resolve()
    e1.selected = true
    e2.selected = true
    e1.particleIntensity = 2
    e2.particleIntensity = 2
    self.points = self.points + self:calculatePoints(e1) + self:calculatePoints(e2)

    self:removeElement(self.selection)
    self:removeElement(hex)
    self.selection = nil
  else
    self:deselectHex()
  end
end

function Self:resolveSingle(hex)
    -- remove both elements

  local e1 = hex.content
  local midPoint = hex_to_pixel(self.layout, middleHex)
  midPoint[1] = midPoint.x
  midPoint[2] = midPoint.y
  table.insert(self.freeElements, e1)

  self.finalTween = self:newTween(3, e1.tween, {sx=10, sy=10}, 'outCubic')
  

  e1:resolve()
  self.points = self.points + self:calculatePoints(e1)

  self:removeElement(hex)
  if self.selection then
    self:deselectHex()
  end
  self.selection = nil
  --
end

function Self:calculatePoints(e1)
  if e1:type() == "Omega" then
    return 200
  end

  if e1:type() == "Lock" or e1:type() == "Key" then
    return 25
  end

  if e1:type() == "TriangleUp" or e1:type() == "TriangleDown" then
    return 10
  end

  return 5
end

function Self:removeElement(hex)
  self.hexes[hex.q][hex.r][hex.s].content = nil
end

function Self:finishLevel()
  for i, hex in ipairs(self.hexlist) do
    if hex.content then
      self.points = self.points + 2*self:calculatePoints(hex.content)
    end
  end
  require 'applications.hex.elements.Lock':reset()
  self.tweens = {}
  self.freeElements = {}
  self.selection = nil
  self:setupGameboard()
end

return Self
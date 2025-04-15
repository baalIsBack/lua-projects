local Super = require 'engine.Scene'
local Self = Super:clone("Main")

require 'lib.hexgrid'


function Self:init()
  Super.init(self)

  

  math.randomseed(os.time())
  require 'engine.Screen':setScale(1, 1)

  self.layout = Layout(layout_pointy, Point(100, 100), Point(100, 100))
  self.hex = Hex(0, 0, 0)
  self.offset_x = 0
  self.offset_y = 0
  
  self.hexes = {}

  return self
end

function Self:draw()
  self.contents:callall("draw")
  
  for q, v in pairs(self.hexes) do
    for r, w in pairs(v) do
      for s, hex in pairs(w) do
        local corners = polygon_corners_flattened(self.layout, hex)
        love.graphics.polygon("line", corners)
        --love.graphics.circle("line", corners[5], corners[6], 50, 50)

      end
    end
  end
end

function Self:update(dt)
  local mx, my = require 'engine.Mouse':getPosition()
  if love.mouse.isDown(1) then
    local h = pixel_to_hex(self.layout, Point(mx, my))
    h = hex_round(h)
    if not self.hexes[h.q] then
      self.hexes[h.q] = {}
    end
    if not self.hexes[h.q][h.r] then
      self.hexes[h.q][h.r] = {}
    end
    if not self.hexes[h.q][h.r][h.s] then
      self.hexes[h.q][h.r][h.s] = h
    end
  end
  self.contents:callall("update", dt)
end

function Self:keypressed(key, scancode, isrepeat)
  self.contents:callall("keypressed", key, scancode, isrepeat)
end

function Self:textinput(text)
  self.contents:callall("textinput", text)
end

function Self:insert(node)
  self.contents:insert(node)
  node.main = self
end

function Self:remove(node)
  self.contents:remove(node)
end



return Self



local Super = require 'engine.Grid'
local Self = Super:clone("TileGrid")

local IMG_TILESET = love.graphics.newImage("submodules/lua-projects-private/gfx/Hana Caraka - Topdown Tileset [sample]/Tileset/Spring - simplified.png")
local QUADS = {}

--require 'applications.farm.Tileset'

for x = -1, 3 do
  QUADS[x] = {}
  for y = -1, 1 do
    QUADS[x][y] = love.graphics.newQuad((x+1)*16, (y+1)*16, 16, 16, IMG_TILESET:getDimensions())
  end
end

function Self:init(args)
  Super.init(self, args)

  self.tileWidth = 16
  self.tileHeight = 16
  
  -- Initialize the tick counter system
  self.tickCounter = 0
  self.tickThreshold = args.tickThreshold or 1  -- Default to 1 second if not specified
  
  self.holeW = 1
  self.holeH = 1

  self:makeHole()

  return self
end


function Self:defaultCreationFunction(x, y)
  local quad = QUADS[0][0]
  if x == 1 then
    quad = QUADS[-1][0]
  end
  if x == self.width then
    quad = QUADS[1][0]
  end
  if y == 1 then
    quad = QUADS[0][-1]
  end
  if y == self.height then
    quad = QUADS[0][1]
  end
  if x == 1 and y == 1 then
    quad = QUADS[-1][-1]
  end
  if x == self.width and y == 1 then
    quad = QUADS[1][-1]
  end
  if x == 1 and y == self.height then
    quad = QUADS[-1][1]
  end
  if x == self.width and y == self.height then
    quad = QUADS[1][1]
  end

  local tileType = "grass"
  if quad ~= QUADS[0][0] then
    tileType = "border"
  end

  local tile = {
    quad = quad,
    tileType = tileType,
    img = IMG_TILESET,
    backgroundColor = {65/255,107/255,223/255},
    content = nil,
    x = x,
    y = y,
  }

  if self:isBorder(x, y) then
    tile.backgroundColor = {65/255,107/255,223/255}
  else
    tile.backgroundColor = {194/255,153/255,121/255}
  end

  if math.random(0, 7) == 1 and not self:isBorder(x, y) then
    tile.content = require 'applications.farm.objects.Tuff':new{
      grid = self,
      x = x,
      y = y,
    }
  end

  return tile
end

function Self:isBorder(x, y)
  return x == 1 or x == self.width or y == 1 or y == self.height
end

function Self:drawTile(tile, x, y)
  local img = tile.img
  local quad = tile.quad
  love.graphics.setColor(tile.backgroundColor)
  love.graphics.rectangle("fill", x*self.tileWidth, y*self.tileHeight, 16, 16)

  love.graphics.setColor(1, 1, 1)
  if quad then
    love.graphics.draw(img, quad, x*self.tileWidth, y*self.tileHeight)
  end
  
end



function Self:drawObjects(tile, x, y)
  love.graphics.push()
  love.graphics.translate(x * self.tileWidth, y * self.tileHeight)
  local object = tile.content
  if object then
    object:draw()
  end
  love.graphics.pop()
end

function Self:draw()
  love.graphics.push()
  love.graphics.translate(-16, -16)
  self:foreach(self.drawTile)
  self:foreach(self.drawObjects)

  
  local mx, my = require 'engine.Mouse':getPosition()
  local x = math.floor(mx / self.tileWidth) + 1
  local y = math.floor(my / self.tileHeight) + 1
  love.graphics.setColor(1, 1, 1, 0.1)
  love.graphics.rectangle("fill", x*self.tileWidth, y*self.tileHeight, self.tileWidth, self.tileHeight)

  love.graphics.pop()
end

function Self:update(dt)
  self:foreach(function(self, tile, x, y)
    local object = tile.content
    if object then
      object:update(dt)
    end
  end)
  
  -- Increment tick counter
  self.tickCounter = self.tickCounter + dt
  
  -- Check if we've reached the threshold
  if self.tickCounter >= self.tickThreshold then
    -- Call tick on all objects
    self:foreach(function(self, tile, x, y)
      local object = tile.content
      if object then
        object:tick()
      end
    end)
    
    -- Reset counter
    self.tickCounter = self.tickCounter - self.tickThreshold
  end

  
end

function Self:flattenGround(tile, x, y)
  local quad = QUADS[0][0]
  if x == 1 then
    quad = QUADS[-1][0]
  end
  if x == self.width then
    quad = QUADS[1][0]
  end
  if y == 1 then
    quad = QUADS[0][-1]
  end
  if y == self.height then
    quad = QUADS[0][1]
  end
  if x == 1 and y == 1 then
    quad = QUADS[-1][-1]
  end
  if x == self.width and y == 1 then
    quad = QUADS[1][-1]
  end
  if x == 1 and y == self.height then
    quad = QUADS[-1][1]
  end
  if x == self.width and y == self.height then
    quad = QUADS[1][1]
  end

  tile.quad = quad

  if self:isBorder(x, y) then
    tile.backgroundColor = {65/255,107/255,223/255}
  else
    tile.backgroundColor = {194/255,153/255,121/255}
  end
end

function Self:makeHoleBorder(tile, x, y, w, h)
  local w = w -1
  local h = h -1
  if self:isBorder(x, y) then
    return
  end
  local quad
  if x >= 2 and y >= 2 and x <= 2+w+1 and y <= 2+h+1 then
    quad = false
  end
  if x == 2 and y <= 2+h+1 then
    quad = QUADS[1][0]
  end
  if y == 2 and x <= 2+w+1 then
    quad = QUADS[0][1]
  end
  if x == 2+w+2 and y <= 2+h+1 then
    quad = QUADS[-1][0]
  end
  if y == 2+h+2 and x <= 2+w+1 then
    quad = QUADS[0][-1]
  end
  if x == 2 and y == 2 then
    quad = QUADS[2][-1]
  end
  if x == 2+w+2 and y == 2 then
    quad = QUADS[3][-1]
  end
  if x == 2 and y == 2+h+2 then
    quad = QUADS[2][0]
  end
  if x == 2+w+2 and y == 2+h+2 then
    quad = QUADS[3][0]
  end
  if quad ~= nil then
    if tile.quad ~= quad then
      tile.content = nil
    end
    tile.quad = quad
    if quad == false then
      tile.tileType = "hole"
      if not tile.content then
        tile.content = require 'applications.farm.objects.Dirt':new{
          grid = self,
          x = x,
          y = y,
        }
      end
    elseif tile.quad == QUADS[0][0] then
      tile.tileType = "grass"
    else
      tile.tileType = "border"
    end
  end
end

function Self:makeHole()
  --self:foreach(self.flattenGround)
  self:foreach(self.makeHoleBorder, self.holeW, self.holeH)
  
end

function Self:keypressed(key, scancode, isrepeat)
  if key == "space" then
    self.holeW = math.min(self.holeW + 1, self.width - 4)
    self.holeH = math.min(self.holeH + 1, self.height - 4)
    self:makeHole()
  end
end

return Self

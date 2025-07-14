local Super = require 'engine.Grid'
local Self = Super:clone("TileGrid")

Self.TILE_WIDTH = 32
Self.TILE_HEIGHT = 32


function Self:init(args)
  Super.init(self, args)
  self.x = args.x or 0
  self.y = args.y or 0
  self.TILE_WIDTH = 32
  self.TILE_HEIGHT = 32
  


  return self
end


function Self:defaultCreationFunction(x, y)

  local tile = require 'applications.idle_factory.tiles.Empty':new{
    x = x,
    y = y,
  }

  return tile
end

function Self:drawTile(tile, x, y)
  local timestamp = love.timer.getTime()
  tile:draw(timestamp)
end

function Self:getMousePositionInTiles()
  local mx, my = love.mouse.getPosition()--require 'engine.Mouse':getPosition()
  mx, my = mx*2, my*2 -- Adjust for pixel scaling if necessary
  local x = math.floor(mx / self.TILE_WIDTH/2)
  local y = math.floor(my / self.TILE_HEIGHT/2)

  return x, y
end

function Self:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  self:foreach(self.drawTile)
  --self:foreach(self.drawObjects)

  
  local x, y = Self:getMousePositionInTiles()


  love.graphics.pop()
  love.graphics.rectangle("fill", x*16*2, y*16*2, 32, 32)
end

function Self:update(dt)
    local x, y = Self:getMousePositionInTiles()
    if love.mouse.isDown(1) then
      local tile = require 'applications.idle_factory.tiles.Belt':new{
        x = x,
        y = y,
      }
      if self:isValidPosition(x, y) then
        self:setTile(tile, x, y)
      end
      
    end
  --[[
  self:foreach(function(self, tile, x, y)
    local object = tile.content
    if object then
      object:update(dt)
    end
  end)
  ]]
  

  
end

function S

return Self

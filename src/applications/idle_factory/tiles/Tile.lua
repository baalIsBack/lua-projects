local Super = require 'engine.Prototype'
local Self = Super:clone("Tile")

Self.TILE_WIDTH = 32
Self.TILE_HEIGHT = 32


function Self:init(args)
  assert(args.x and args.y, "Tile must be initialized with x and y coordinates")
  Super.init(self, args)

  self.x = args.x
  self.y = args.y
  --[[
  return {
    tileID = 0,
    content = {},
    x = x,
    y = y,
  }]]


  return self
end


function Self:draw()
  local x, y = self.x, self.y
  love.graphics.setColor(1, 0, 1)
  love.graphics.rectangle("fill", (x-0.5)*self.TILE_WIDTH, (y-0.5)*self.TILE_HEIGHT, 16, 16)

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", (x-0.5)*self.TILE_WIDTH, (y-0.5)*self.TILE_HEIGHT, self.TILE_WIDTH, self.TILE_HEIGHT)
  
end


function Self:update(dt)
  --[[
  self:foreach(function(self, tile, x, y)
    local object = tile.content
    if object then
      object:update(dt)
    end
  end)
  ]]
  

  
end

return Self
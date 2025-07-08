local Super = require 'applications.idle_factory.tiles.Tile'
local Self = Super:clone("AnimatedTile")



function Self:init(args)
  assert((args.quads or self.quads) and (args.img or self.img), "AnimatedTile must be initialized with quads and img ", args.quads, args.img, self.quads, self.img)
  Super.init(self, args)

  self.quads = args.quads
  self.img = args.img

  self.rotation = 0--math.random(0, 3) * math.pi/2 -- Random rotation for the tile
  return self
end

function Self:draw(timestamp)
  local x, y = self.x, self.y
  love.graphics.setColor(1, 1, 1)
  local quadId = math.floor(timestamp*20) % #self.quads + 1
  love.graphics.draw(self.img, self.quads[quadId], (x)*self.TILE_WIDTH, (y)*self.TILE_HEIGHT, self.rotation, 2, 2, self.ox, self.oy)
  
  
end


return Self
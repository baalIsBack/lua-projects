local Super = require 'engine.Prototype'
local Self = Super:clone("Grid")

function Self:init(args)
  Super.init(self, args)

  self.width = args.width
  self.height = args.height

  self.internalGrid =  {}
  for y = 1, args.height do
    self.internalGrid[y] = {}
    for x = 1, args.width do
      self.internalGrid[y][x] = (args.creationFunction or self.defaultCreationFunction)(self, x, y)
    end
  end
  
	return self
end

function Self:defaultCreationFunction(x, y)
  return {
    tileID = 0,
    content = {},
    x = x,
    y = y,
  }
end

function Self:isValidPosition(x, y)
  return x > 0 and x <= self.width and y > 0 and y <= self.height
end

function Self:getTile(x, y)
  return self.internalGrid[y][x]
end

function Self:setTile(tile, x, y)
  assert(tile, "Tile cannot be nil")
  assert(x > 0 and x <= self.width, "X coordinate out of bounds: " .. x)
  assert(y > 0 and y <= self.height, "Y coordinate out of bounds: " .. y)
  self.internalGrid[y][x] = tile
end

function Self:foreach(f, ...)
  for y = 1, #self.internalGrid do
    for x = 1, #self.internalGrid[y] do
      f(self, self.internalGrid[y][x], x, y, ...)
    end
  end
end


return Self

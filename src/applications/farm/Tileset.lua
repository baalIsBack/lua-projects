local Super = require 'engine.Grid'
local Self = Super:clone("TileGrid")

local GRID_OFFSETS = {}
for c = 0, 31, 1 do
  local i = math.floor(c / 1)%2
  local j = math.floor(c / 2)%2
  local k = math.floor(c / 4)%2
  local l = math.floor(c / 8)%2
  if not GRID_OFFSETS[i] then
    GRID_OFFSETS[i] = {}
  end
  if not GRID_OFFSETS[i][j] then
    GRID_OFFSETS[i][j] = {}
  end
  if not GRID_OFFSETS[i][j][k] then
    GRID_OFFSETS[i][j][k] = {}
  end
  GRID_OFFSETS[i][j][k][l] = {x = 0, y = 0,}
  --GRID_OFFSETS[i][j][k][l]
end


GRID_OFFSETS[0][0][0][0] = {x = 0, y = 0,}
GRID_OFFSETS[0][0][0][1] = {x = 0, y = 1,}
GRID_OFFSETS[0][0][1][0] = {x = 0, y = 1,}
GRID_OFFSETS[0][0][1][1] = {x = 0, y = 1,}
GRID_OFFSETS[0][1][0][0] = {x = 0, y = 1,}
GRID_OFFSETS[0][1][0][1] = {x = 0, y = 1,}
GRID_OFFSETS[0][1][1][0] = {x = 0, y = 1,}
GRID_OFFSETS[0][1][1][1] = {x = 0, y = 1,}
GRID_OFFSETS[1][0][0][0] = {x = 0, y = 1,}
GRID_OFFSETS[1][0][0][1] = {x = 0, y = 1,}
GRID_OFFSETS[1][0][1][0] = {x = 0, y = 1,}
GRID_OFFSETS[1][0][1][1] = {x = 0, y = 1,}
GRID_OFFSETS[1][1][0][0] = {x = 0, y = 1,}
GRID_OFFSETS[1][1][0][1] = {x = 0, y = 1,}
GRID_OFFSETS[1][1][1][0] = {x = 0, y = 1,}
GRID_OFFSETS[1][1][1][1] = {x = 0, y = 1,}

function Self:init(args)
  Super.init(self, args)

  return self
end


return Self
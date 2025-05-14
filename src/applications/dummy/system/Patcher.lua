local Super = require 'engine.Prototype'
local Self = Super:clone("Patcher")

require 'lib.hexgrid'

function Self:init(args)
  self.main = args.main
  Super.init(self, args)
  
  self.layout = Layout(layout_pointy, Point(12, 12), Point(20, 20))
  self.hex = Hex(0, 0, 0)
  self.offset_x = 0
  self.offset_y = 0

  self.tiles = {}


  self.idGenerator = 0

  

  return self
end


function Self:makeTile(tileType, args)
  --local sourceHex = pixel_to_hex(self.layout, Point(sourceHexX, sourceHexY))
  --local targetTile = pixel_to_hex(self.layout, Point(targetTileX, targetTileY))
  local h
  if args.x and args.y then
    h = pixel_to_hex(self.layout, Point(args.x, args.y))
    h = hex_round(h)
    h.kind = tileType
    h.id = self:generateId()
    h.startingNode = args.startingNode
  elseif args.q and args.r and args.s and args.id then
    h = Hex(args.q, args.r, args.s)
    h = hex_round(h)
    h.kind = tileType
    h.id = self:generateId()
    h.startingNode = args.startingNode
  elseif args.h then
    h = args.h
  else
    asd()
  end

  if not self.tiles[h.q] then
    self.tiles[h.q] = {}
  end
  if not self.tiles[h.q][h.r] then
    self.tiles[h.q][h.r] = {}
  end
  if not self.tiles[h.q][h.r][h.s] then
    self.tiles[h.q][h.r][h.s] = h
  end
  h = self.tiles[h.q][h.r][h.s]
  h.sources = {}
  h.links = {} -- visual
  return h
end

function Self:getTransition(x, y)
  local h = pixel_to_hex(self.layout, Point(x, y))
  h = hex_round(h)
  local result = self.tiles[h.q] and self.tiles[h.q][h.r] and self.tiles[h.q][h.r][h.s]
  if result and result.kind == "transition" then
    return result
  end
end

function Self:getTile(x, y)
  local h = pixel_to_hex(self.layout, Point(x, y))
  h = hex_round(h)
  local result = self.tiles[h.q] and self.tiles[h.q][h.r] and self.tiles[h.q][h.r][h.s]
  return result
end

function Self:getTileByQRS(q, r, s)
  local result = self.tiles[q] and self.tiles[q][r] and self.tiles[q][r][s]
  return result
end

function Self:getHex(x, y)
  local h = pixel_to_hex(self.layout, Point(x, y))
  h = hex_round(h)
  local result = self.tiles[h.q] and self.tiles[h.q][h.r] and self.tiles[h.q][h.r][h.s]
  if result and result.kind == "hex" then
    return result
  end
end

function Self:getHexByQRS(q, r, s)
  local result = self.tiles[q] and self.tiles[q][r] and self.tiles[q][r][s]
  if result and result.kind == "hex" then
    return result
  end
end

function Self:getTransitionByQRS(q, r, s)
  local result = self.tiles[q] and self.tiles[q][r] and self.tiles[q][r][s]
  if result and result.kind == "transition" then
    return result
  end
end


function Self:generateId()
  self.idGenerator = self.idGenerator + 1
  return self.idGenerator
end


function Self:removeTile(x, y)
  local h = pixel_to_hex(self.layout, Point(x, y))
  h = hex_round(h)
  
  for i=1, 6 do
    local neighbor = hex_neighbor(h, i-1)
    local tile = self:getTileByQRS(neighbor.q, neighbor.r, neighbor.s)
    if tile then
      tile.links[((3-i) % 6)+1] = false
    end
  end

  if self:getTileByQRS(h.q, h.r, h.s) then
    self.tiles[h.q][h.r][h.s] = nil
  end
end



function Self:exportStructure()
  local structure = {}
  for q, r in pairs(self.tiles) do
    for r, s in pairs(r) do
      for s, h in pairs(s) do
        table.insert(structure, self:getTileByQRS(h.q, h.r, h.s))
      end
    end
  end
  return structure
end

function Self:exportStructureToString()
  local structure = self:exportStructure()
  local str = ""
  str = str .. string.format((self.idGenerator+1) .. "\n")
  for i, v in ipairs(structure) do
    str = str .. string.format("%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n", v.kind, v.q, v.r, v.s, v.id, v.links[1] and 1 or 0, v.links[2] and 1 or 0, v.links[3] and 1 or 0, v.links[4] and 1 or 0, v.links[5] and 1 or 0, v.links[6] and 1 or 0, v.startingNode and 1 or 0)
  end
  print("exportStructureToString", str)
  return str
end

function Self:importStructureFromString(s)
  local first_line = s:match("([^\n]+)")
  if first_line then
    s = s:sub(#first_line + 1)
  end
  local structure = {}
  self.tiles = {}
  for line in s:gmatch("[^\n]+") do
    local kind, q, r, s, id, link1, link2, link3, link4, link5, link6, startingNode = line:match("(%a+),(%-?%d+),(%-?%d+),(%-?%d+),(%d+),(%d),(%d),(%d),(%d),(%d),(%d),(%d)")
    
    if not kind then
      kind, q, r, s, id = line:match("(%a+),(%-?%d+),(%-?%d+),(%-?%d+),(%d+)")
    end
    if q and r and s then
      local links = {}
      links[1] = tonumber(link1) == 1
      links[2] = tonumber(link2) == 1
      links[3] = tonumber(link3) == 1
      links[4] = tonumber(link4) == 1
      links[5] = tonumber(link5) == 1
      links[6] = tonumber(link6) == 1
      table.insert(structure, {kind = kind, q = tonumber(q), r = tonumber(r), s = tonumber(s), id = tonumber(id), links = links, startingNode = tonumber(startingNode) == 1})
    end
  end
  
  for i, v in ipairs(structure) do
    self:makeTile(v.kind, {q=v.q, r=v.r, s=v.s, id=v.id, links=v.links, startingNode=v.startingNode})
    self.tiles[v.q][v.r][v.s].id = v.id
    self.tiles[v.q][v.r][v.s].links = v.links
  end
  
  self.idGenerator = tonumber(first_line)
end


function Self:getTileDirection(sourceHex, targetHex)
  if not self:isNeighbor(sourceHex, targetHex) then
    return nil
  end
  for i = 1, 6 do
    if hex_equal(hex_neighbor(sourceHex, i-1), targetHex) then
      return 6-i+1
    end
  end
end
function Self:isNeighbor(sourceHex, targetHex)
  return sourceHex and targetHex and hex_distance(sourceHex, targetHex) == 1
end

function Self:createFullLinks()
  for i, v in pairs(self.tiles) do
    for j, w in pairs(v) do
      for k, h in pairs(w) do

        local hex = self:getTileByQRS(h.q, h.r, h.s)
        if hex then
          if self:getTileByQRS(h.q, h.r+1, h.s-1) or self:getTileByQRS(h.q, h.r+1, h.s-1) then
            hex.links[1] = true
          else
            hex.links[1] = false
          end
          if self:getTileByQRS(h.q-1, h.r+1, h.s) or self:getTileByQRS(h.q-1, h.r+1, h.s) then
            hex.links[2] = true
          else
            hex.links[2] = false
          end
          if self:getTileByQRS(h.q-1, h.r, h.s+1) or self:getTileByQRS(h.q-1, h.r, h.s+1) then
            hex.links[3] = true
          else
            hex.links[3] = false
          end
          if self:getTileByQRS(h.q, h.r-1, h.s+1) or self:getTileByQRS(h.q, h.r-1, h.s+1) then
            hex.links[4] = true
          else
            hex.links[4] = false
          end
          if self:getTileByQRS(h.q+1, h.r-1, h.s) or self:getTileByQRS(h.q+1, h.r-1, h.s) then
            hex.links[5] = true
          else
            hex.links[5] = false
          end
          if self:getTileByQRS(h.q+1, h.r, h.s-1) or self:getTileByQRS(h.q+1, h.r, h.s-1) then
            hex.links[6] = true
          else
            hex.links[6] = false
          end
        end
      end
    end
  end
end

function Self:getAllLinkedNeighbors(hex, neighbors, visited)
  local neighbors = neighbors or {}
  local visited = visited or {}
  if visited[hex.id] then
    return neighbors
  end
  visited[hex.id] = true
  for i = 1, 6 do
    local neighbor_raw = hex_neighbor(hex, i-1)
    local neighbor = self:getTileByQRS(neighbor_raw.q, neighbor_raw.r, neighbor_raw.s)
    if hex.links[6-i+1] and neighbor then
      if neighbor.kind == "hex" then
        if not visited[neighbor.id] then
          table.insert(neighbors, neighbor)
        end
      elseif neighbor.kind == "transition" then
        if not visited[neighbor.id] then
          neighbors = self:getAllLinkedNeighbors(neighbor, neighbors, visited)
        end
      end
    end
  end
  return neighbors
end

function Self:isUnlocked(hex)
  assert(hex, "hex is nil")
  return hex.canBeBought or hex.startingNode
end

function Self:isBought(hex)
  assert(hex, "hex is nil")
  return hex.bought
end

function Self:buy(hex)
  assert(hex, "hex is nil")
  print("isBought", hex.id, hex.canBeBought, hex.bought)
  if self:isUnlocked(hex) and not hex.bought then
    hex.bought = true
    local neighbors = self:getAllLinkedNeighbors(hex)
    for i, h in ipairs(neighbors) do
      h.canBeBought = true
    end
    return true
  end
  return false
end

function Self:refresh(hex)
  assert(hex, "hex is nil")
  local neighbors = self:getAllLinkedNeighbors(hex)
  local foundOne = false
  for i, h in ipairs(neighbors) do
    if self:isBought(h) then
      foundOne = true
    end
  end
  hex.canBeBought = foundOne
  return true
end

function Self:sell(hex)
  assert(hex, "hex is nil")
  if hex.bought then
    hex.bought = false
    hex.canBeBought = true
    local neighbors = self:getAllLinkedNeighbors(hex)
    local count = 1
    for i, h in ipairs(neighbors) do
      local cluster = self:getBoughtCluster(h)
      if not self:hasStartingNodeInCluster(h, cluster) then
        for k, ch in ipairs(cluster) do
          if ch.bought then
            count = count + 1
          end
          self:rawSell(ch)
          local neighbors2 = self:getAllLinkedNeighbors(ch)
          for l, cch in ipairs(neighbors2) do
            self:refresh(cch)
          end
        end
        self:refresh(h)
      end
    end
    print(count)
    return count
  end
  return false
end

function Self:rawSell(hex)
  assert(hex, "hex is nil")
  if hex.bought then
    hex.bought = false
    hex.canBeBought = false
    return true
  end
  return false
end


function Self:hasStartingNodeInCluster(hex, cluster)
  assert(hex, "hex is nil")
  local cluster = cluster or self:getBoughtCluster(hex)
  for i, v in ipairs(cluster) do
    if v.startingNode then
      return true
    end
  end
  return false
end

function Self:getBoughtCluster(hex)
  assert(hex, "hex is nil")
  local notVisited = {hex}
  local visited = {}

  local boughtCluster = {}

  while #notVisited > 0 do
    local currentHex = table.remove(notVisited, 1)
    if not visited[currentHex.id] then
      visited[currentHex.id] = true
      if currentHex.bought then
        table.insert(boughtCluster, currentHex)
        local neighbors = self:getAllLinkedNeighbors(currentHex)
        for i, v in ipairs(neighbors) do
          if not visited[v.id] and v.bought then
            table.insert(notVisited, v)
          end
        end
      end
    end
  end

  return boughtCluster
end



return Self
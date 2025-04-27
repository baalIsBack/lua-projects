local Super = require 'engine.Prototype'
local Self = Super:clone("Patcher")

require 'lib.hexgrid'

function Self:init(args)
  self.main = args.main
  Super.init(self, args)
  
  self.layout = Layout(layout_pointy, Point(20, 20), Point(20, 20))
  self.hex = Hex(0, 0, 0)
  self.offset_x = 0
  self.offset_y = 0

  self.hexes = {}
  self.connections = {}


  self.idGenerator = 0

  

  return self
end

function Self:makeTransition(x, y)
  --local sourceHex = pixel_to_hex(self.layout, Point(sourceHexX, sourceHexY))
  --local targetHex = pixel_to_hex(self.layout, Point(targetHexX, targetHexY))

  local h
  if y then
    h = pixel_to_hex(self.layout, Point(x, y))
    h = hex_round(h)
    h.kind = "transition"
    h.id = self:generateId()
  else
    h = x
  end
  if not self.connections[h.q] then
    self.connections[h.q] = {}
  end
  if not self.connections[h.q][h.r] then
    self.connections[h.q][h.r] = {}
  end
  if not self.connections[h.q][h.r][h.s] then
    self.connections[h.q][h.r][h.s] = h
  end
  h = self.connections[h.q][h.r][h.s]
  h.sources = {}
  h.links = {} -- visual
  return h
end



function Self:makeTransitionByQRS(q, r, s, id)
  local h
  h = Hex(q, r, s)
  h = hex_round(h)
  h.kind = "transition"
  h.id = id or self:generateId()
  if not self.connections[h.q] then
    self.connections[h.q] = {}
  end
  if not self.connections[h.q][h.r] then
    self.connections[h.q][h.r] = {}
  end
  if not self.connections[h.q][h.r][h.s] then
    self.connections[h.q][h.r][h.s] = h
  end
  h = self.connections[h.q][h.r][h.s]
  h.sources = {}
  h.links = {} -- visual
  return h
end

function Self:getTransition(x, y)
  local h = pixel_to_hex(self.layout, Point(x, y))
  h = hex_round(h)
  return self.connections[h.q] and self.connections[h.q][h.r] and self.connections[h.q][h.r][h.s]
end

function Self:getHex(x, y)
  local h = pixel_to_hex(self.layout, Point(x, y))
  h = hex_round(h)
  return self.hexes[h.q] and self.hexes[h.q][h.r] and self.hexes[h.q][h.r][h.s]
end

function Self:getHexByQRS(q, r, s)
  return self.hexes[q] and self.hexes[q][r] and self.hexes[q][r][s]
end

function Self:getTransitionByQRS(q, r, s)
  return self.connections[q] and self.connections[q][r] and self.connections[q][r][s]
end

function Self:makeHexByQRS(q, r, s, id)
  local h
  h = Hex(q, r, s)
  h = hex_round(h)
  h.kind = "hex"
  h.id = id or self:generateId()
  
  if not self.hexes[h.q] then
    self.hexes[h.q] = {}
  end
  if not self.hexes[h.q][h.r] then
    self.hexes[h.q][h.r] = {}
  end
  if not self.hexes[h.q][h.r][h.s] then
    self.hexes[h.q][h.r][h.s] = h
  end
  return h
end


function Self:makeHex(x, y)
  local h
  if y then
    h = pixel_to_hex(self.layout, Point(x, y))
    h = hex_round(h)
    h.kind = "hex"
    h.id = self:generateId()
  else
    h = x
  end
  
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

function Self:generateId()
  self.idGenerator = self.idGenerator + 1
  return self.idGenerator
end


function Self:removeHex(x, y)
  local h = pixel_to_hex(self.layout, Point(x, y))
  h = hex_round(h)
  if self.hexes[h.q] and self.hexes[h.q][h.r] and self.hexes[h.q][h.r][h.s] then
    self.hexes[h.q][h.r][h.s] = nil
  end
end


function Self:removeTransition(x, y)
  local h = pixel_to_hex(self.layout, Point(x, y))
  h = hex_round(h)
  if self.connections[h.q] and self.connections[h.q][h.r] and self.connections[h.q][h.r][h.s] then
    self.connections[h.q][h.r][h.s] = nil
  end
end

function Self:exportStructure()
  local structure = {}
  for q, r in pairs(self.hexes) do
    for r, s in pairs(r) do
      for s, h in pairs(s) do
        table.insert(structure, self:getHexByQRS(h.q, h.r, h.s))
      end
    end
  end
  for q, r in pairs(self.connections) do
    for r, s in pairs(r) do
      for s, h in pairs(s) do
        table.insert(structure, self:getTransitionByQRS(h.q, h.r, h.s))
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
    str = str .. string.format("%s,%d,%d,%d,%d\n", v.kind, v.q, v.r, v.s, v.id)
  end
  return str
end

function Self:importStructureFromString(s)
  local first_line = s:match("([^\n]+)")
  if first_line then
    s = s:sub(#first_line + 1)
  end
  local structure = {}
  self.hexes = {}
  self.connections = {}
  for line in s:gmatch("[^\n]+") do
    local kind, q, r, s, id = line:match("(%a+),(%-?%d+),(%-?%d+),(%-?%d+),(%d+)")
    print(line)
    print(kind, q, r, s, id)
    if q and r and s then
      table.insert(structure, {kind = kind, q = tonumber(q), r = tonumber(r), s = tonumber(s), id = tonumber(id)})
    end
  end
  
  for i, v in ipairs(structure) do
    print(v.kind, v.q, v.r, v.s, v.id)
    if v.kind == "hex" then
      self:makeHexByQRS(v.q, v.r, v.s, v.id)
      self.hexes[v.q][v.r][v.s].id = v.id
    elseif v.kind == "transition" then
      self:makeTransitionByQRS(v.q, v.r, v.s, v.id)
      self.connections[v.q][v.r][v.s].id = v.id
    end
  end
  
  self.idGenerator = tonumber(first_line)
end




return Self
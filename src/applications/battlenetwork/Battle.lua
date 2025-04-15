local Super = require 'engine.Prototype'
local Self = Super:clone("Battle")

local GRID_CELL_WIDTH, GRID_CELL_HEIGHT = 80, 48
--40, 24,,32
local IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/Tiles.png")
local QUAD_RED = love.graphics.newQuad(0*GRID_CELL_WIDTH, 0*GRID_CELL_HEIGHT, GRID_CELL_WIDTH, GRID_CELL_HEIGHT * (32/24), IMG:getDimensions())
local QUAD_BLUE = love.graphics.newQuad(1*GRID_CELL_WIDTH, 0*GRID_CELL_HEIGHT, GRID_CELL_WIDTH, GRID_CELL_HEIGHT * (32/24), IMG:getDimensions())
local QUAD_GREEN = love.graphics.newQuad(2*GRID_CELL_WIDTH, 0*GRID_CELL_HEIGHT, GRID_CELL_WIDTH, GRID_CELL_HEIGHT * (32/24), IMG:getDimensions())

local IMG_BACKGROUND = love.graphics.newImage("submodules/lua-projects-private/gfx/duelyst/resources/maps/battlemap1_middleground.png")
local TILE_IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/duelyst/resources/tiles/tile_large.png")

function Self:init(args)
  Super.init(self, args)

  self.main = args.main

  self.w = args.w or 6
  self.h = args.h or 3

  self.grid = {}
  for x = 1, self.w do
    self.grid[x] = {}
    for y = 1, self.h do
      local team = "neutral"
      if x <= 3 then
        team = "good"
      elseif x >= 4 then
        team = "bad"
      end
      self.grid[x][y] = {x = x, y = y, content = nil, team=team}
    end
  end


  self.player = require 'applications.battlenetwork.Player':new{battle=self, x=2, y=2, team = "good"}
  self:addEntity(self.player)
  --self:addEntity(require 'applications.battlenetwork.Enemy':new{battle=self, x=1+3, y=1, team = "bad"})
  self:addEntity(require 'src.applications.battlenetwork.enemies.Enemy':new{battle=self, x=1+3, y=1, team = "bad", enemySpriteID = "boss_antiswarm"})
  self:addEntity(require 'src.applications.battlenetwork.enemies.Enemy':new{battle=self, x=2+3, y=1, team = "bad", enemySpriteID = "boss_wujin"})
  self:addEntity(require 'src.applications.battlenetwork.enemies.Enemy':new{battle=self, x=3+3, y=1, team = "bad", enemySpriteID = "f3_rehorah"})
  self:addEntity(require 'src.applications.battlenetwork.enemies.Enemy':new{battle=self, x=1+3, y=3, team = "bad", enemySpriteID = "f4_klaxon"})
  self:addEntity(require 'src.applications.battlenetwork.enemies.Enemy':new{battle=self, x=2+3, y=2, team = "bad", enemySpriteID = "f6_ilenamk2"})
  self:addEntity(require 'src.applications.battlenetwork.enemies.Enemy':new{battle=self, x=3+3, y=2, team = "bad", enemySpriteID = "neutral_giantcrab"})
  --self:addEntity(require 'applications.battlenetwork.Enemy':new{battle=self, x=3+3, y=3, team = "bad", enemySpriteID = "boss_andromeda"})

  


  self.selectionMenue = require 'applications.battlenetwork.SpellSelection':new{battle=self}

  self.corpses = {}

  
  local screenW, screenH = require 'engine.Screen':getSize()
  self.textCanvas = love.graphics.newCanvas(screenW, screenH)



  return self
end

function Self:addEntity(entity)
  local x, y = self:determinePosition(entity.x, entity.y)
  self:getTile(x, y).content = entity
end

function Self:getCorpses(x, y)
  local corpses = {}
  for i, corpse in ipairs(self.corpses) do
    if corpse:getTileX() == x and corpse:getTileY() == y then
      table.insert(corpses, corpse)
    end
  end
  return corpses
end

function Self:update(dt)
  if self.selectionMenue:isOpen() then
    self.selectionMenue:update(dt)
    return
  end
  for x = 1, self.w do
    for y = 1, self.h do
      for i, corpse in ipairs(self:getCorpses(x, y)) do
        corpse:update(dt)
      end
      if self.grid[x][y].content then
        if self.grid[x][y].content._deleted then
          local shouldDelete = self.grid[x][y].content:shouldDelete()
          if shouldDelete then
            print("deleting", x, y)
            self.grid[x][y].content = nil
          end
        end
        if self.grid[x][y].content then
          self.grid[x][y].content:update(dt)
        end
      end
    end
  end
end

function Self:drawGrid()
  for x = 1, self.w do
    for y = 1, self.h do
      local xPos, yPos = self:getDrawPosition(x, y)
      
      if self.grid[x][y].team == "good" then
        love.graphics.setColor(0.3, 0.3, 1)
        --love.graphics.draw(IMG, QUAD_BLUE, xPos, yPos)
      elseif self.grid[x][y].team == "neutral" then
        love.graphics.setColor(0.3, 1, 0.3)
        --love.graphics.draw(IMG, QUAD_GREEN, xPos, yPos)
      elseif self.grid[x][y].team == "bad" then
        love.graphics.setColor(1, 0.3, 0.3)
        --love.graphics.draw(IMG, QUAD_RED, xPos, yPos)
      end
      love.graphics.draw(TILE_IMG, xPos, yPos, 0, GRID_CELL_WIDTH / TILE_IMG:getWidth(), GRID_CELL_HEIGHT/TILE_IMG:getHeight())
      --love.graphics.rectangle("line", xPos, yPos, GRID_CELL_WIDTH, GRID_CELL_HEIGHT)
    end
  end
end

function Self:draw()
  love.graphics.draw(IMG_BACKGROUND, 0, 0, 0, 3/4, 3/4)


  love.graphics.push()
  love.graphics.scale(1, 1)
  love.graphics.translate(0, 100)
  self:drawGrid()
  love.graphics.setColor(1, 1, 1)
  for x = 1, self.w do
    for y = 1, self.h do
      for i, corpse in ipairs(self:getCorpses(x, y)) do
        corpse:draw()
      end
      if self.grid[x][y].content then
        self.grid[x][y].content:draw()
      end
    end
  end
  love.graphics.pop()
  love.graphics.draw(self.textCanvas, 0, 0)
  self.selectionMenue:draw()

  local priorCanvas = love.graphics.getCanvas()
  love.graphics.setCanvas(self.textCanvas)
  love.graphics.clear()
  love.graphics.setCanvas(priorCanvas)
end

function Self:addCorpse(entity)
  table.insert(self.corpses, entity)
end

function Self:getTile(x, y)
  if not (x >= 1 and x <= self.w) then
    print(x, y)
    asdff()
  end
  if not (y >= 1 and y <= self.h) then
    print(x, y)
    asdff()
  end

  return self.grid[x][y]
end

function Self:canEntityMoveTo(entity, x, y)
  if not self:isValidPosition(x, y) then
    return false
  end
  local targetTile = self:getTile(x, y)
  if targetTile.content then
    return false
  end
  if targetTile.team ~= entity.team then
    return false
  end
  return true
end

function Self:getDrawPosition(x, y)
  return (x) * GRID_CELL_WIDTH, (y) * GRID_CELL_HEIGHT
end

function Self:determinePosition(x, y)
  return math.max(1, math.min(self.w, x)), math.max(1, math.min(self.h, y))
end

function Self:isValidPosition(x, y)
  return x >= 1 and x <= self.w and y >= 1 and y <= self.h  
end

function Self:moveEntity(entity, targetX, targetY)
  local x, y = self:determinePosition(entity:getTileX(), entity:getTileY())
  local sourceTile = self:getTile(x, y)
  local nx, ny = self:determinePosition(targetX, targetY)
  local targetTile = self:getTile(nx, ny)
  if not self:canEntityMoveTo(entity, nx, ny) then
    return false
  end
  sourceTile.content = nil
  targetTile.content = entity
  return nx, ny
end

return Self
local Super = require 'engine.Prototype'
local Self = Super:clone("SpellSelection")


function Self:init(args)
  Super.init(self, args)

  self.battle = args.battle

  self.opened = true

  self.currentDraw = {
    require 'applications.battlenetwork.spells.Spell':new{battle=self.battle},
    require 'applications.battlenetwork.spells.Spell':new{battle=self.battle},
    require 'applications.battlenetwork.spells.Spell':new{battle=self.battle},
    require 'applications.battlenetwork.spells.Spell':new{battle=self.battle},
    require 'applications.battlenetwork.spells.Spell':new{battle=self.battle},
  }

  self.layout = {
    require 'applications.battlenetwork.Selectable':new{name="spell1", x = 50, y = 50 + (0)*30, w = 26, h = 26, content = self.currentDraw[1]},
    require 'applications.battlenetwork.Selectable':new{name="spell2", x = 50, y = 50 + (1)*30, w = 26, h = 26, content = self.currentDraw[2]},
    require 'applications.battlenetwork.Selectable':new{name="spell3", x = 50, y = 50 + (2)*30, w = 26, h = 26, content = self.currentDraw[3]},
    require 'applications.battlenetwork.Selectable':new{name="spell4", x = 50, y = 50 + (3)*30, w = 26, h = 26, content = self.currentDraw[4]},
    require 'applications.battlenetwork.Selectable':new{name="spell5", x = 50, y = 50 + (4)*30, w = 26, h = 26, content = self.currentDraw[5]},
    require 'applications.battlenetwork.Selectable':new{name="go", x = 50, y = 50 + (6)*30, sx = 1/10, sy = 1/10, content = nil, img = love.graphics.newImage("submodules/lua-projects-private/gfx/duelyst/ui/icon_check.png")},
  }
  self.layout[1]:setDown(self.layout[2])
  self.layout[2]:setDown(self.layout[3])
  self.layout[3]:setDown(self.layout[4])
  self.layout[4]:setDown(self.layout[5])
  self.layout[5]:setUp(self.layout[4])
  self.layout[4]:setUp(self.layout[3])
  self.layout[3]:setUp(self.layout[2])
  self.layout[2]:setUp(self.layout[1])
  self.layout[5]:setDown(self.layout[6])
  self.layout[6]:setUp(self.layout[5])

  self.layout[1]:select()
  self.currentSelected = self.layout[1]

  self.layout[6].callbacks:register("onTrigger", function (kcl)
    local spells = {}
    for i, selection in ipairs(self.selections) do
      table.insert(spells, self.currentDraw[selection])
    end
    self.battle.player:setSpells(spells)
    self:close()
  end)
  
  
  

  self.selections = {}

  self.selectionID = 1

  self.wasPressed = false

  return self
end

function Self:open()
  self.opened = true
end

function Self:close()
  self.opened = false
end

function Self:isOpen()
  return self.opened
end

function Self:draw()
  if not self.opened then
    return
  end
  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.rectangle("fill", 0, 0, 300, 480)
  love.graphics.setColor(1, 1, 1)

  for i, selectable in ipairs(self.layout) do
    selectable:draw()
  end

  for i, currentDrawID in ipairs(self.selections) do
    love.graphics.setColor(1, 1, 1)
    local content = self.currentDraw[currentDrawID]
    if content then
      love.graphics.draw(content.img, content.quad, 100, 100 + (i-1)*30)
    end
  end
end


function Self:update(dt)
  if not self.opened then
    return
  end

  if love.keyboard.isDown("up") and not self.wasPressed then
    self.currentSelected = self.currentSelected:moveUp()
    self.wasPressed = true
  end
  if love.keyboard.isDown("down") and not self.wasPressed then
    self.currentSelected = self.currentSelected:moveDown()
    self.wasPressed = true
  end
  if love.keyboard.isDown("left") and not self.wasPressed then
    self.currentSelected = self.currentSelected:moveLeft()
    self.wasPressed = true
  end
  if love.keyboard.isDown("right") and not self.wasPressed then
    self.currentSelected = self.currentSelected:moveRight()
    self.wasPressed = true
  end

  local currentID = -1
  for i, selectable in ipairs(self.layout) do
    if selectable == self.currentSelected then
      currentID = i
    end
  end

  if love.keyboard.isDown("space") and currentID >= 1 and currentID <= 5 and not self:isSelected(currentID) and not self.wasPressed then
    table.insert(self.selections, currentID)
    self.wasPressed = true
  end

  if love.keyboard.isDown("c") and #self.selections > 0 and not self.wasPressed then
    table.remove(self.selections, #self.selections)
    self.wasPressed = true
  end


  

  if not love.keyboard.isDown("c") and not love.keyboard.isDown("up") and not love.keyboard.isDown("down") then
    self.wasPressed = false
  end

  for i, selectable in ipairs(self.layout) do
    selectable:update(dt)
  end
end

function Self:isSelected(id)
  for i, selection in ipairs(self.selections) do
    if selection == id then
      return true
    end
  end
  return false
end


return Self
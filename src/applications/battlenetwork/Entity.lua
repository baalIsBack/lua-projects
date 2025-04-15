local Super = require 'engine.Prototype'
local Self = Super:clone("Entity")

local Animation = require 'engine.Animation'

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/megaman.png")

function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)

  self.transient = false

  self.callbacks:declare("onDraw")
  self.callbacks:declare("onUpdate")
  self.callbacks:declare("onMove")
  self.callbacks:declare("onDestroy")

  self.battle = args.battle

  self.team = args.team or "neutral"

  self.x = args.x or 1
  self.y = args.y or 1
  self.hp = args.hp or 100


  
  self.timers = {}
  self.quadOffsetX = 0
  self.quadOffsetY = 0

  self.spellList = {}

  return self
end

function Self:update(dt)
  self.animation:update(dt)

  
  for i, timer in ipairs(self.timers) do
    timer:update(dt)
  end

  self.callbacks:call("onUpdate", {self, dt})

end

function Self:drawHP()
  if not self.hp then
    return
  end
  local hpString = ""..self.hp
  local font = love.graphics.getFont()
  local fontWidth = font:getWidth(hpString)
  local fontHeight = font:getHeight()


  local x, y = self.battle:getDrawPosition(self.x+0.5, self.y+0.5)
  love.graphics.print(hpString, x-fontWidth/2, y + fontHeight/2)
end

function Self:setSpells(ls)
  self.spellList = ls
end

function Self:drawSpellList()
  if not self.spellList or #self.spellList == 0 then
    return
  end

  love.graphics.setColor(1, 1, 1)
  for i=#self.spellList, 1, -1 do
    local spell = self.spellList[i]
    
    local x, y = self.battle:getDrawPosition(self.x+0.5, self.y+0.5)
    local _, _, qw, qh = spell.quad:getViewport()
    x = x + 10
    y = y + 30
    love.graphics.draw(spell.img, spell.quad, x-qw/2 - i*4, y-100 - i*4, 0)
  end

end

function Self:translateOffset()
  love.graphics.translate(-self.quadOffsetX, -self.quadOffsetY)
end

function Self:draw()
  --love.graphics.rectangle("line", self.x * 100, self.y * 100, 100, 100)
  --love.graphics.draw(self.img, self.quad, self.x * 100, self.y * 100)
  self.callbacks:call("onDraw", {self})
end

function Self:move(dx, dy)
  self:moveTo(self.x + dx, self.y + dy)
end

function Self:moveTo(targetX, targetY)
  local x, y = self.battle:moveEntity(self, targetX, targetY)
  local priorX, priorY = self.x, self.y
  if x and y then
    self.x = x
    self.y = y
    self.callbacks:call("onMove", {self, x, y, priorX, priorY})
  end
end

function Self:lifeCheck(dt)
  if self.hp <= 0 and not self.transient then
    self:destroy()
  end
end

function Self:getTileX()
  return ROUND(self.x)
end

function Self:getTileY()
  return ROUND(self.y)
end

function Self:delete()
  self._deleted = true
end

function Self:shouldDelete()
  return self._deleted
end

function Self:destroy()
  self:delete()
  self.callbacks:call("onDestroy", {self})
end

function Self:convertToCorpse()
  self:delete()
  self.battle:addCorpse(self)
end

function Self:spawnExplosion()
  local explosion = require 'applications.battlenetwork.Effect':new({battle = self.battle, x = self.x, y = self.y, effectNumber = 21})
  self.battle:addEntity(explosion)
end


function Self:dealDamage(target, amount)
  target:takeDamage(self, amount)
end

function Self:takeDamage(dealer, amount)
  self.hp = self.hp - amount
end

function Self:stagger(dealer)
  
end

return Self
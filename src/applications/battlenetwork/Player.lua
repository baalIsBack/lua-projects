local Super = require 'applications.battlenetwork.Entity'
local Self = Super:clone("Player")

local Animation = require 'engine.Animation'

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/megaman.png")

function Self:init(args)
  Super.init(self, args)


  self.img = Self.IMG
  self.quad = love.graphics.newQuad(0, 0, 100, 100, self.img:getDimensions())


  self.animation_idle = Animation:new(12, {
    love.graphics.newQuad(0*100, 0*100, 100, 100, self.img:getDimensions()),
  }, false)

  self.animation_damage = Animation:new(20, {
    love.graphics.newQuad(0*100, 1*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(0*100, 2*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(0*100, 1*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(0*100, 2*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(0*100, 1*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(0*100, 2*100, 100, 100, self.img:getDimensions()),
  }, false)

  self.animation_move = Animation:new(20, {
    love.graphics.newQuad(0*100, 3*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(0*100, 4*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(0*100, 5*100, 100, 100, self.img:getDimensions()),
  }, false)

  self.animation_attack = Animation:new(20, {
    love.graphics.newQuad(0*100, 6*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(0*100, 7*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(0*100, 8*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(0*100, 9*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(1*100, 0*100, 100, 100, self.img:getDimensions()),
  }, false)

  self.animation_cast = Animation:new(10, {
    love.graphics.newQuad(1*100, 1*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(1*100, 2*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(1*100, 3*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(1*100, 4*100, 100, 100, self.img:getDimensions()),
  }, false)

  self.animation_addition_charge = Animation:new(20, {
    love.graphics.newQuad(1*100, 5*100, 100, 100, self.img:getDimensions()),
    love.graphics.newQuad(1*100, 6*100, 100, 100, self.img:getDimensions()),
  }, true)


  self.animation = self.animation_idle
  self.targetX, self.targetY = nil, nil

  self.wasAttackButtonPressed = false
  self.canAttack = true
  self.attackTimer = require 'engine.Timer':new{timeMax=0.1, loop=false}
  self.attackTimer.callbacks:register("onTrigger", function(timer)
    self.canAttack = true
  end)

  self.chargedAttack = false
  self.attackChargeTimer = require 'engine.Timer':new{timeMax=1.5, loop=false}
  self.attackChargeTimer.callbacks:register("onTrigger", function(timer)
    self.chargedAttack = true
  end)

  self.canMove = true
  self.moveTimer = require 'engine.Timer':new{timeMax=0.05, loop=false}
  self.moveTimer.callbacks:register("onTrigger", function(timer)
    self.canMove = true
  end)

  self.autoMove = false
  self.moveAutoTimer = require 'engine.Timer':new{timeMax=0.3, loop=false}
  self.moveAutoTimer.callbacks:register("onTrigger", function(timer)
    self.autoMove = true
  end)
  
  self.wasSpellButtonPressed = false
  self.canCast = true
  self.spellTimer = require 'engine.Timer':new{timeMax=0.4, loop=false}
  self.spellTimer.callbacks:register("onTrigger", function(timer)
    self.canCast = true
  end)


  table.insert(self.timers, self.attackTimer)
  table.insert(self.timers, self.moveTimer)
  table.insert(self.timers, self.moveAutoTimer)
  table.insert(self.timers, self.attackChargeTimer)
  table.insert(self.timers, self.spellTimer)

  self.callbacks:register("onUpdate", self.update2)
  self.callbacks:register("onDraw", self.draw2)

  self.quadOffsetX = 39
  self.quadOffsetY = 77

  self.chargeEffect = require 'applications.battlenetwork.Effect':new{battle=self.battle, x=0, y=0, effectNumber=7, once=false}


  return self
end

function Self:setSpells(spellList)
  self.spellList = spellList
end

function Self:update2(dt)

  if not love.keyboard.isDown("up") and not love.keyboard.isDown("down") and not love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
    self.autoMove = true
  end

  if self.autoMove then
    if self.canMove and love.keyboard.isDown("up") and self.battle:canEntityMoveTo(self, self:getTileX(), self:getTileY() - 1) then
      self.animation = self.animation_move
      self.animation:restart()
      self:moveTo(self:getTileX(), self:getTileY() - 1)
      self.canMove = false
      self.moveTimer:restart()
      self.autoMove = false
      self.moveAutoTimer:restart()
      self.attackTimer:restart()
    end
    if self.canMove and love.keyboard.isDown("down") and self.battle:canEntityMoveTo(self, self:getTileX(), self:getTileY() + 1) then
      self.animation = self.animation_move
      self.animation:restart()
      self:moveTo(self:getTileX(), self:getTileY() + 1)
      self.canMove = false
      self.moveTimer:restart()
      self.autoMove = false
      self.moveAutoTimer:restart()
      self.attackTimer:restart()
    end
    if self.canMove and love.keyboard.isDown("left") and self.battle:canEntityMoveTo(self, self:getTileX() - 1, self:getTileY()) then
      self.animation = self.animation_move
      self.animation:restart()
      self:moveTo(self:getTileX() - 1, self:getTileY())
      self.canMove = false
      self.moveTimer:restart()
      self.autoMove = false
      self.moveAutoTimer:restart()
      self.attackTimer:restart()
    end
    if self.canMove and love.keyboard.isDown("right") and self.battle:canEntityMoveTo(self, self:getTileX() + 1, self:getTileY()) then
      self.animation = self.animation_move
      self.animation:restart()
      self:moveTo(self:getTileX() + 1, self:getTileY())
      self.canMove = false
      self.moveTimer:restart()
      self.autoMove = false
      self.moveAutoTimer:restart()
      self.attackTimer:restart()
    end
  end


  if love.keyboard.isDown("space") then
    self.attackChargeTimer:start()
    if self.canAttack and not self.wasAttackButtonPressed then
      self:attack()
      self.animation = self.animation_attack
      self.animation:restart()
      self.canAttack = false
      self.attackTimer:restart()
      self.attackChargeTimer:restart()
    end
    self.wasAttackButtonPressed = true
  else
    self.attackTimer:start()
    if self.chargedAttack then
      self:chargeAttack()
      self.animation = self.animation_attack
      self.animation:restart()
      self.canAttack = false
      self.attackTimer:restart()
      self.attackChargeTimer:restart()
    end
    self.chargedAttack = false
    self.attackChargeTimer:stop()
    self.wasAttackButtonPressed = false
  end

  if love.keyboard.isDown("c") then
    if not self.wasSpellButtonPressed and self.canCast and #self.spellList >= 1 then
      self.animation = self.animation_cast
      self.animation:restart()
      self:cast()
      self.canCast = false
      self.spellTimer:restart()
    end
    self.wasSpellButtonPressed = true
  else
    self.wasSpellButtonPressed = false
  end

  
  self.chargeEffect:update(dt)
  self.animation_addition_charge:update(dt)
end

function Self:attack()
  local entity = self:getNextEnemyAtRight()
  if entity then
    self:dealDamage(entity, 1)
  end
end

function Self:chargeAttack()
  local entity = self:getNextEnemyAtRight()
  if entity then
    self:dealDamage(entity, 10)
  end
end

function Self:cast()
  local spell = self.spellList[1]
  if spell then
    table.remove(self.spellList, 1)
    spell:effect(self)
  end
end

function Self:getNextEnemyAtRight()
  for x = self:getTileX()+1, self.battle.w do
    local entity = self.battle:getTile(x, self:getTileY()).content
    if entity and not entity.transient then
      return entity
    end
  end
end



function Self:draw2()
  if self.animation:isDone() then
    self.animation = self.animation_idle
    self.animation:restart()
  end

  love.graphics.push()
  self:translateOffset()
  local x, y = self.battle:getDrawPosition(self.x+0.5, self.y+0.5)
  self.quad = self.animation:getQuad()

  love.graphics.draw(self.img, self.quad, x, y)
  
  love.graphics.pop()
  if self.chargedAttack then
    self.chargeEffect.x = self.x
    self.chargeEffect.y = self.y
    love.graphics.push()
    love.graphics.translate(0, -10)
    self.chargeEffect:draw()
    love.graphics.pop()
  end
  self:drawHP()
  self:drawSpellList()
end




return Self
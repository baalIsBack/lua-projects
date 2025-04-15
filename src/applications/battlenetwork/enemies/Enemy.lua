local Super = require 'applications.battlenetwork.Entity'
local Self = Super:clone("Enemy")

local Animation = require 'engine.Animation'

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/DARK Series/14 DARK - Enemies Pack 3/Ghoul/Ghoul Sprite Sheet 62 x 33.png")

local offX = 0
local offY = 20
function Self:init(args)
  Super.init(self, args)


  self.img = Self.IMG
  self.quad = nil
  self.hp = 20


  self.sprites, self.spritesByName = require 'applications.battlenetwork.DuelystUnitLoader':load(args.enemySpriteID or "neutral_sunsetparagon")

  self.animation = self.spritesByName["breathing"]
  self.animation.loop = true
  


  self.callbacks:register("onDraw", self.draw2)
  self.callbacks:register("onDestroy", self.onDestroy)
  self.callbacks:register("onUpdate", self.lifeCheck)
  

  return self
end

function Self:onDestroy()
  self._deleted = false--delay
  self.transient = true--make transient so not in game anymore
  self.animation = self.spritesByName["death"]
  self.animation.loop = false
  self.animation.callbacks:register("finish", function(anim)
    self:convertToCorpse()
  end)
end


function Self:draw2()
  love.graphics.push()
  self:translateOffset()
  local x, y = self.battle:getDrawPosition(self.x+0.5, self.y+0.5)
  
  local flip = true
  
  -- Get quad dimensions
  local _, _, width, height = self.animation:getQuad():getViewport()
  

  love.graphics.setColor(0, 1, 0)
  --love.graphics.circle("line", x, y, 5)
  --love.graphics.translate(-self.animation.offsetX/2, -self.animation.offsetY/2)

  love.graphics.translate(offX, offY)
  love.graphics.setColor(1, 1, 1)
  if flip then
    -- Draw with origin at center of the sprite
    love.graphics.draw(
      self.animation.img, 
      self.animation:getQuad(), 
      x, y, -- Use center position
      0, -1, 1, -- Flip horizontally
      width/2, height -- Set origin to center
    )
  else
    -- Draw with origin at center of the sprite
    love.graphics.draw(
      self.animation.img, 
      self.animation:getQuad(), 
      x, y,
      0, 1, 1, -- Normal scale
      width/2, height -- Set origin to center
    )
  end

  
  love.graphics.pop()
  
  love.graphics.setColor(1, 1, 1)
  --love.graphics.circle("fill", x+self.animation.offsetX/2 - width/2, y+self.animation.offsetY/2 - height/2, 5)
  if not self.transient then
    self:drawHP()
  end
end

return Self
local Super = require 'engine.Prototype'
local Self = Super:clone("Element")

Self.img = love.graphics.newImage("applications/hex/assets/GemsAndStones/Gems_Spritesheet.png")
Self.sound = love.audio.newSource("applications/hex/assets/pixabay-mechanical-hum-64405.mp3", "static")


local sparkleImage
      local radius = 16
local function hslToRgb(h, s, l)
    if s <= 0 then return l, l, l end
    h = h % 1
    local function hue2rgb(p, q, t)
        t = t % 1
        if t < 1/6 then return p + (q - p) * 6 * t end
        if t < 1/2 then return q end
        if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
        return p
    end
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    return hue2rgb(p, q, h + 1/3),
           hue2rgb(p, q, h),
           hue2rgb(p, q, h - 1/3)
end


function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)
  self.grid = args.grid

  self.name = args.name
  self.selected = false
  
  self.color = {0.3, 0.3, 0.3}

  self.rotation = 0
  self.sx = 2
  self.sy = 2

  self.tween = {
    sx = 1,
    sy = 1,
    rotation = 0,
    color = {1, 1, 1},
    x = args.x or 0,
    y = args.y or 0,
    soundVolumeModifier = 0,
  }

  self.sound = Self.sound:clone()
  self.quad = nil

  self.hue = 0

  self.particleCounter = 0
  self.particleIntensity = 120

  


    -- 2x2 sparkle texture
    local imageData = love.image.newImageData(2, 2)
    imageData:mapPixel(function() return 1, 1, 1, 1 end)
    sparkleImage = love.graphics.newImage(imageData)

    local sparkleSystem = love.graphics.newParticleSystem(sparkleImage, 4*128)
    sparkleSystem:setParticleLifetime(0.6, 0.8)
    sparkleSystem:setSizes(1)
    sparkleSystem:setSizeVariation(0)

    -- Start nearly still
    sparkleSystem:setSpeed(5, 10)

    -- Radial acceleration inward (negative = pull)
    sparkleSystem:setRadialAcceleration(120, 180)

    -- No tangential acceleration (no spin)
    sparkleSystem:setTangentialAcceleration(0)
    sparkleSystem:setEmissionArea("borderellipse", radius, radius, 0, true)

    self.sparkleSystem = sparkleSystem

	return self
end

function Self:canResolveItself()
  return false
end

function Self:canSolve(otherElement)
  return self:type() == otherElement:type()
end

function Self:playSound()
  self.grid:newTween(3, self.tween, {soundVolumeModifier=0.1,}, 'linear')

  self.playingSound = true
end

function Self:stopSound()
  self.grid:newTween(1.4, self.tween, {soundVolumeModifier=0,}, 'linear')

  self.playingSound = false
end

function Self:select(silent)
  if not silent then 
    --self:playSound()
  end
  
end

function Self:deselect(silent)
  if not silent then 
    self:stopSound()
  end
end

function Self:update(dt)
  if self.tween.soundVolumeModifier == 0 then
    self.sound:stop()
  else
    self.sound:play()
    --
  end
  self.sound:setVolume(self.tween.soundVolumeModifier)
 
  if self.selected then
    
    self.particleCounter = self.particleCounter + dt
    if self.particleCounter > 1/self.particleIntensity then
      self.particleCounter = 0
    
      self.sparkleSystem:setPosition(self.tween.x, self.tween.y)
      self.sparkleSystem:emit(1)
      self.hue = (self.hue + dt * 0.2) % 1
          -- Convert hue to RGB
      local r, g, b = hslToRgb(self.hue, 0.9, 0.6)

      -- Update particle color (with fade out)
      self.sparkleSystem:setColors(
          r, g, b, 0.8,
          r, g, b, 0
      )
    end
  end
  self.sparkleSystem:update(dt)
end

function Self:draw()
  local w, h = 16, 16
  self.color =  {1, 1, 1}

  --love.graphics.setColor(self.color[1] * 0.5 * self.tween.color[1], self.color[2] * 0.5 * self.tween.color[2], self.color[3] * 0.5 * self.tween.color[1], 0.6)
  love.graphics.draw(self.img, self.quad, self.tween.x, self.tween.y, self.rotation+self.tween.rotation, self.sx*math.pow(self.tween.sx, 2.6), self.sy*math.pow(self.tween.sx, 2.6), 8, 8)
  
  if self.grid:isBlocked(self.hex) or not self:isOpen() then
    love.graphics.setColor(
      math.min(0.65, self.color[1] * self.tween.color[1] - 0.3),
      math.min(0.65, self.color[2] * self.tween.color[2] - 0.3),
      math.min(0.65, self.color[3] * self.tween.color[3] - 0.3)
    )
  else
    love.graphics.setColor({
      self.color[1] * self.tween.color[1] ,
      self.color[2] * self.tween.color[2],
      self.color[3] * self.tween.color[3]
    })
  end
  --draw n-gonprint
  love.graphics.draw(self.img, self.quad, self.tween.x, self.tween.y, self.rotation+self.tween.rotation, self.sx*self.tween.sx, self.sy*self.tween.sx, 8, 8)
  
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.sparkleSystem)
end

function Self:isOpen()
  return true
end

function Self:resolve()

end

return Self

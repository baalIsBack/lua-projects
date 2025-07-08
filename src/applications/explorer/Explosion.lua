local Super = require 'applications.explorer.Entity'
local Self = Super:clone("Explosion")


local function createCircleImageData(radius)
    local size = radius * 2
    local imageData = love.image.newImageData(size, size)

    imageData:mapPixel(function(x, y)
        local dx = x - radius + 0.5
        local dy = y - radius + 0.5
        local distance = math.sqrt(dx*dx + dy*dy)
        if distance <= radius then
            return 1, 1, 1, 1  -- white pixel with full alpha
        else
            return 0, 0, 0, 0  -- transparent
        end
    end)

    return love.graphics.newImage(imageData)
end

local particleImage = createCircleImageData(5) -- Create a small white circle image for particles


function Self:init(args)
  Super.init(self, args)
  self.tags["transient"] = true



  self.callbacks:register("onUpdate", self._update)

  local explosionSystem = love.graphics.newParticleSystem(particleImage, 100)

  -- Particle system settings
  explosionSystem:setParticleLifetime(0.5, 1)        -- particles live between 0.5s and 1s
  explosionSystem:setEmissionRate(0)                 -- no continuous emission
  explosionSystem:setSizes(1, 0)                     -- start size 1, shrink to 0
  explosionSystem:setSpeed(100, 200)                 -- particles move out fast
  explosionSystem:setLinearAcceleration(0, 0)        -- no gravity
  explosionSystem:setSpread(math.pi * 2)             -- 360° spread
  explosionSystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)   -- fade to transparent
  explosionSystem:setPosition(self.x, self.y) -- set initial position
  explosionSystem:emit(math.random(5, 13))
  self.explosionSystem = explosionSystem

	return self
end

function Self:_update(dt)
  self.explosionSystem:update(dt)
  if self.explosionSystem:getCount() == 0 then
    self:annihilate()
  end
end

function Self:draw()
  love.graphics.setColor(1, 0.3, 0.3, 1) -- Reset color to white
  love.graphics.draw(self.explosionSystem)
end

return Self

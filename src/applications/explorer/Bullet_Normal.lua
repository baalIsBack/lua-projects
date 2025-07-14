local Super = require 'applications.explorer.Entity'
local Self = Super:clone("Bullet")

function Self:init(args)
  Super.init(self, args)
  self.tags["bullet"] = true


  self.dx = args.dx or 0
  self.dy = args.dy or 0
  
  self.maxDuration = args.maxDuration or 5

  self.lifetime = 0

  self.callbacks:register("onUpdate", self._update)

	return self
end

function Self:_update(dt)
  self:applyMomentum(dt, self.dx, self.dy, self.speed)

  self.lifetime = self.lifetime + dt
  if self.lifetime > self.maxDuration then
    self:annihilate()
  end

  for i, entity in ipairs(self.main.entities) do
    if entity ~= self and entity.tags["enemy"] then
      if self:checkCollision(entity) then
        entity:destroy()
        self:destroy()
        break
      end
    end
  end
end

function Self:draw()
  love.graphics.push()
  love.graphics.setColor(1, 1, 1, 1)
  local angle = math.atan2(self.dy, self.dx)
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(angle)
  local dist = 20
  rounded.line("loop", dist/2, 0, -dist/2, -dist/5, -dist/2, dist/5)
  love.graphics.pop()
  self:drawCollisionRadius()
end


return Self

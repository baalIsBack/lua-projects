local Super = require 'applications.explorer.Entity'
local Self = Super:clone("Player")

function Self:init(args)
  Super.init(self, args)
  self.tags["enemy"] = true



  self.callbacks:register("onUpdate", self._update)
  self.callbacks:register("onDestroy", self._destroy)
  self.dx = args.dx or 0
  self.dy = args.dy or 0

  self.updateTimer = 0
  self.updateFrequency = 0.4 -- Update every 0.1 seconds


  self.rotation = math.atan2(self.dy, self.dx)
  self.rotationTween = Tween.new(0.1, self, {rotation = self.rotation}, 'inOutQuad')

	return self
end

function Self:_destroy()
  self.main:insert(require 'applications.explorer.Explosion':new({
    x = self.x,
    y = self.y,
  }))

  local amount = math.random(3, 5)
  for i=1, amount, 1 do
    local rotation = math.random() * 2 * math.pi
    self.main:insert(require 'applications.explorer.Coin':new({
      x = self.x,
      y = self.y,
      dx = math.cos(rotation),
      dy = math.sin(rotation),
    }))
  end
  
end

function Self:_update(dt)
  self.updateTimer = self.updateTimer + dt
  if self.updateTimer >= self.updateFrequency then
    self.updateTimer = self.updateTimer - self.updateFrequency

    local players = self.main:findEntitysByTag("player")
    local closestPlayer = nil
    local closestDistance = math.huge
    for _, p in ipairs(players) do
      local dx = p.x - self.x
      local dy = p.y - self.y
      local distance = math.sqrt(dx * dx + dy * dy)
      if distance < closestDistance then
        closestDistance = distance
        closestPlayer = p
      end
    end

    if closestPlayer then
      self.dx = closestPlayer.x - self.x
      self.dy = closestPlayer.y - self.y

      local currentAngle = self.rotation
      local targetAngle = math.atan2(closestPlayer.y - self.y, closestPlayer.x - self.x)
      local delta = shortestAngleDiff(currentAngle, targetAngle)
      local normalizedTargetAngle = currentAngle + delta
      self.rotationTween = Tween.new(0.3, self, {rotation = normalizedTargetAngle}, 'inOutQuad')

    end


  end

  self.rotationTween:update(dt)

  self.dx, self.dy = math.cos(self.rotation), math.sin(self.rotation)

  self:applyMomentum(dt, self.dx, self.dy, self.speed)


  for i, entity in ipairs(self.main.entities) do
    if entity ~= self and entity.tags["player"] then
      if self:checkCollision(entity) then -- Collision radius
        entity:destroy()
        break
      end
    end
  end
end

function shortestAngleDiff(a, b)
    local diff = (b - a + math.pi) % (2 * math.pi) - math.pi
    return diff
end

function Self:draw()
  love.graphics.push()
  love.graphics.setColor(1, 0.3, 0.3, 1)
  local angle = math.atan2(self.dy, self.dx)
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(angle)
  local dist = 20
  rounded.line("loop", dist/2, 0, -dist/2, -dist/5, -dist/2, dist/5)
  
  love.graphics.pop()
  self:drawCollisionRadius()
end

return Self

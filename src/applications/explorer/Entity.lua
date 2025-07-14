local Super = require 'engine.Prototype'
local Self = Super:clone("Entity")

function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)
  assert(args.x, "Bullet must have a x coordinate")
  assert(args.y, "Bullet must have a y coordinate")

  self.tags = {}

  self.collisionRadius = 10

  self.x = args.x
  self.y = args.y
  
  self.callbacks:declare("onUpdate")
  self.callbacks:declare("onDestroy")


  self.speed = args.speed or 100
  
  self.maxDuration = args.maxDuration or 5

  self.lifetime = 0

	return self
end

function Self:checkCollision(other)
  if not other then
    return false
  end

  local dx = other.x - self.x
  local dy = other.y - self.y
  local distance = math.sqrt(dx * dx + dy * dy)

  return distance <= (self.collisionRadius + other.collisionRadius), distance
end

function Self:drawCollisionRadius()
  if DEBUG then
    love.graphics.push()
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.circle("line", self.x, self.y, self.collisionRadius)
    love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
    love.graphics.pop()
  end
end

function Self:destroy()
  self.callbacks:call("onDestroy", {self,})
  self:annihilate()
end

function Self:applyMomentum(dt, dx, dy, speed)
  local norm = math.sqrt(dx * dx + dy * dy)
  if norm == 0 then
    norm = 1 -- Prevent division by zero
  end

  self.x = self.x + (dx / norm) * speed * dt
  self.y = self.y + (dy / norm) * speed * dt
end

function Self:annihilate()
  self._canBeRemoved = true
end

function Self:update(dt)
  self.callbacks:call("onUpdate", {self, dt,})
end

function Self:draw()
  self.callbacks:call("onDraw", {self,})
end


return Self

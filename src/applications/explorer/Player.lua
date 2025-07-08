local Super = require 'applications.explorer.Entity'
local Self = Super:clone("Player")

function Self:init(args)
  Super.init(self, args)

  self.tags["player"] = true


  self.callbacks:register("onUpdate", self._update)
  self.callbacks:register("onDestroy", self._destroy)

	return self
end

function Self:_destroy()
  self.main:insert(require 'applications.explorer.Explosion':new({
    x = self.x,
    y = self.y,
  }))
  for i=1, self.main.coins, 1 do
    local rotation = math.random() * 2 * math.pi
    self.main:insert(require 'applications.explorer.Coin':new({
      x = self.x + math.cos(rotation) * 20,
      y = self.y + math.sin(rotation) * 20,
      dx = math.cos(rotation),
      dy = math.sin(rotation),
    }))
  end
  
end

function Self:_update(dt)
  local dx, dy = 0, 0
  if love.keyboard.isDown("w") then
    dy = dy - 1
  end
  if love.keyboard.isDown("s") then
    dy = dy + 1
  end
  if love.keyboard.isDown("a") then
    dx = dx - 1
  end
  if love.keyboard.isDown("d") then
    dx = dx + 1
  end

  self:applyMomentum(dt, dx, dy, self.speed)
end

function Self:draw()
  rounded.circle(self.x, self.y, 10, 100)
  self:drawCollisionRadius()
end

function Self:mousepressed(x, y, button, istouch, presses)
  if button == 1 then
    local dx = x - self.x
    local dy = y - self.y
    local norm = math.sqrt(dx * dx + dy * dy)
    if norm == 0 then
      norm = 1 -- Prevent division by zero
    end
    local startDistance = 20

    local b = require 'applications.explorer.Bullet_Normal':new({
      x = self.x + (dx / norm) * startDistance,
      y = self.y + (dy / norm) * startDistance,
      dx = x - self.x,
      dy = y - self.y,
      speed = 200
    })
    self.main:insert(b)
  end

  if button == 2 then

  end
end

return Self

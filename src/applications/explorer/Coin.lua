local Super = require 'applications.explorer.Entity'
local Self = Super:clone("Bullet")

function Self:init(args)
  Super.init(self, args)
  self.tags["coin"] = true


  self.dx = args.dx or 0
  self.dy = args.dy or 0
  
  self.callbacks:register("onUpdate", self._update)
  self.callbacks:register("onDestroy", self._destroy)

  self.speedTween = nil

	return self
end

function Self:_destroy()
  self.main.coins = self.main.coins + 1
end

function Self:_update(dt)
  if self.speedTween then
    self.speedTween:update(dt)
    if self.speedTween:isDone() then
      self.speedTween = nil
    end
  end
  self:applyMomentum(dt, self.dx, self.dy, self.speed)
  self.speed = self.speed * math.pow(0.3, dt)

  for i, entity in ipairs(self.main.entities) do
    if entity ~= self and entity.tags["player"] then
      local collision, distance = self:checkCollision(entity)
      distance = distance or math.huge -- Fallback to a large distance if nil
      if collision then -- Collision radius
        print("Coin attracted to player", distance)
        self:destroy()
        break
      elseif distance < 50 then -- collection radius
        self.dx = entity.x - self.x
        self.dy = entity.y - self.y
        if not self.speedTween then
          self.speedTween = Tween.new(0.3, self, {speed = 700}, 'inBack')
        end
      end
    end
  end
end

function Self:draw()
  love.graphics.push()
  love.graphics.setColor(1, 1, 0, 1)
  love.graphics.circle("fill", self.x, self.y, 4)
  love.graphics.pop()
  self:drawCollisionRadius()
end


return Self

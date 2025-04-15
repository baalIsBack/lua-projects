local Super = require 'engine.Prototype'
local Self = Super:clone("Object")

function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)

  self.grid = args.grid
  
  self.x = args.x or 0
  self.y = args.y or 0

  self.callbacks:declare("onTick")
  self.callbacks:declare("onUpdate")
  self.callbacks:declare("onDraw")
  self.callbacks:declare("onClick")
  
  self._click = false

	return self
end

function Self:tick()
  self.callbacks:call("onTick", {self})
end

function Self:update(dt)
  local mx, my = require 'engine.Mouse':getPosition()
  self.callbacks:call("onUpdate", {self, dt})
  if love.mouse.isDown(1) then
    if not self._click and mx >= (self.x-1)*self.grid.tileWidth and mx <= (self.x-1)*self.grid.tileWidth + 16 and my >= (self.y-1)*self.grid.tileHeight and my <= (self.y-1)*self.grid.tileHeight + 16 then
      self.callbacks:call("onClick", {self})
      self._click = true
    end
  else
    self._click = false
  end
end

function Self:draw()
  self.callbacks:call("onDraw", {self})
end

return Self

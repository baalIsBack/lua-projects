local Super = require 'engine.Prototype'
local Self = Super:clone("Screen")

function Self:init()
  Super.init(self)

  self._default_width = 640
  self._default_height = 480

  self.scale_horizontal = 640
  self.scale_vertical = 480

	return self
end

function Self:getScale()
  return self.scale_horizontal, self.scale_vertical
end

function Self:setScale(sw, sh)
  self.scale_horizontal = sw
  self.scale_vertical = sh
  love.window.setMode(self.scale_horizontal*self._default_width, self.scale_vertical*self._default_height)
end

function Self:getMousePosition()
	return self:getX(), self:getY()
end

function Self:getX()
  return love.mouse.getX() / self.scale_horizontal
end

function Self:getY()
  return love.mouse.getY() / self.scale_vertical
end

return Self:new()

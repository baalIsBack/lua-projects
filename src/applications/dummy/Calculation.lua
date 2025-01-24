local Super = require 'engine.Prototype'
local Self = Super:clone("Calculation")

function Self:init(args)
  Super.init(self, args)

  self.base_value = 0
  self.added_value = 0
  self.increased_value = 0
  self.more_value = 1


	return self
end

function Self:calculate()
  local delta = (self.base_value + self.added_value) * self.increased_value * self.more_value

  self.amount = self.amount + delta
  return delta
end

function Self:set_base_value(x)
  self.base_value = x
end

function Self:change_added_value(delta)
  self.added_value = self.added_value + delta
end

function Self:change_increased_value(delta)
  self.increased_value = self.increased_value + delta
end





return Self

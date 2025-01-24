local Super = require 'engine.Prototype'
local Self = Super:clone("Currency")

function Self:init(args)
  Super.init(self, args)

  self.amount = 0

  self.calculation = require 'applications.dummy.Calculation':new()


	return self
end

function Self:increment()
  self.amount = self.amount + self.calculation:calculate()
end





return Self

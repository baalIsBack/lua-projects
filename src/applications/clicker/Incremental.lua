local Super = require 'engine.Prototype'
local Self = Super:clone("Incremental")

function Self:init(args)
  Super.init(self, args)

  self.points = require 'applications.dummy.Currency':new()
  

	return self
end


function Self:draw()
  
end

function Self:update(dt)
  
end

return Self

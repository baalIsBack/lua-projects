local Super = require 'engine.Prototype'
local Self = Super:clone("Module")


function Self:init(args)
  Super.init(self)

  for i, module in ipairs(args) do
    require ('engine.modules.' .. module.name)
  end

  return self
end


return Self
local Super = require 'engine.Prototype'
local Self = Super:clone("Patcher")

require 'lib.hexgrid'

function Self:init(args)
  self.main = args.main
  Super.init(self, args)
  
  self.layout = Layout(layout_pointy, Point(20, 20), Point(20, 20))
  self.hex = Hex(0, 0, 0)
  self.offset_x = 0
  self.offset_y = 0
  self.hexes = {}

  

  return self
end




return Self
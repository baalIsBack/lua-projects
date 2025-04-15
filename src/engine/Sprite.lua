local Super = require 'engine.Animation'
local Self = Super:clone("Sprite")



function Self:init(args)
  Super.init(self, args.fps, args.quads, args.loop)
  self.img = args.img
  self.offsetX = args.offsetX or 0
  self.offsetY = args.offsetY or 0
	
	return self
end



return Self

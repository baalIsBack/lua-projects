local Super = require 'engine.gui.Button'
local Self = Super:clone("Button_Apply")

function Self:init(args)
  args.color = args.color or {192/255, 192/255, 192/255, 1}
  args.w = args.w or 42
  args.h = args.h or 14
  Super.init(self, args)

  self:insert(require 'engine.gui.Text':new{main=self.main, text = "Apply", color={0,0,0}, x = 0, y = -2, wrapLimit = 64, alignment = "center"})

  return self
end


return Self
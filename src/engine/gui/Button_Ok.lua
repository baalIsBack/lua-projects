local Super = require 'engine.gui.Button'
local Self = Super:clone("Button_Ok")

function Self:init(args)
  args.color = args.color or {192/255, 192/255, 192/255, 1}
  args.w = args.w or 20
  args.h = args.h or 14
  args.text = args.text or "OK"
  Super.init(self, args)

  --self:insert(require 'engine.gui.Text':new{main=self.main, text = "OK", color={0,0,0}, x = 0, y = -2, wrapLimit = 64, alignment = "center"})

  return self
end


return Self
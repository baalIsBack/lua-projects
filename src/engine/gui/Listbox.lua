local Super = require 'engine.gui.Node'
local Self = Super:clone("Listbox")

function Self:init(args)
  Super.init(self, args)

  self.title = args.title or ""
  self.w = args.w
  self.h = args.h

  self.list = require 'engine.gui.List':new{
    main=args.main,
    x = -8,
    y = 0,
    w = self.w-16,
    h = self.h,
    elementSize = 16,
  }
  self:insert(self.list)

  self.scrollbar = require 'engine.gui.Scrollbar':new{
    main=args.main,
    x = self.w/2 - 8,
    y = 0,
    w = 16,
    h = self.h,
  }
  self:insert(self.scrollbar)

  self.scrollbar.callbacks:register("onUp", function()
    self.list:up()
  end)
  self.scrollbar.callbacks:register("onDown", function()
    self.list:down()
  end)

  local obj
  for i, v in ipairs(args.items) do
    obj = require 'engine.gui.Text':new{
      main=args.main,
      x = 12 - self.w/2,
      y = 0,
      text = v,
      alignment = "left",
    }
    self.list:insert(obj)
  end
  
  
  

	return self
end


function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  
 
  love.graphics.setLineWidth(2)

  --love.graphics.setColor(1/255, 0/255, 129/255)
  love.graphics.setColor(192/255, 192/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)

  
  
  self.contents:callall("draw")

  love.graphics.pop()
end



return Self

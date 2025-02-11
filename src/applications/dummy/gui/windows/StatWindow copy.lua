local Super = require 'engine.gui.Window'
local Self = Super:clone("CalcWindow")


function Self:init(args)
  args.w = 320
  args.h = 240
  args.title = "Stat"
  Super.init(self, args)
  

  self.list = require 'engine.gui.List':new{
    x = 0-8,
    y = 0+8,
    w = self.w-16-16,
    h = self.h-16-16,
    items = {}
  }
  self:insert(self.list)
  self.scrollbar = require 'engine.gui.Scrollbar':new{
    x = self.w/2-16+8,
    y = 8,
    h = self.h-16,
    orientation = "vertical"
  }
  self:insert(self.scrollbar)

  self.scrollbar.callbacks:register("onUp", function() print(self.list.first_item_id) self.list:up() end)
  self.scrollbar.callbacks:register("onDown", function() print(self.list.first_item_id) self.list:down() end)
  
  
  self.texts = {}
  for i=1, 100, 1 do
    local t = require 'engine.gui.Text':new{
      x = 0,
      y = 0,
      text = "Stat Window" .. i
    }
    table.insert(self.texts, t)
    self.list:insert(t)
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
  local previous_font = love.graphics.getFont()
  love.graphics.setFont(FONT_DEFAULT)

  --c0c0c0 192/255
  love.graphics.setColor(192/255, 192/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)


  
  
  
  

  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

return Self
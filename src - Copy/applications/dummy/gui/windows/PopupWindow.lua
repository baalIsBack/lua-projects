local Super = require 'engine.gui.Window'
local Self = Super:clone("PopupWindow")


function Self:init(args)
  args.w = 32 * 2
  args.h = 24 * 2
  args.title = args.title or ""
  Super.init(self, args)
  
  self.bar.color = {255/255, 30/255, 15/255}

  
  self.text = require 'engine.gui.Text':new{text = "WARNING", color={0,0,0}, x = 0, y = 0}
  self:insert(self.text)
  

  return self
end


function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)

  --c0c0c0 192/255
  love.graphics.setColor(192/255, 192/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)

  local previous_font = love.graphics.getFont()
  love.graphics.setFont(FONT_DEFAULT)

  
  love.graphics.setColor(1, 1, 1)
  
  --

  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

return Self
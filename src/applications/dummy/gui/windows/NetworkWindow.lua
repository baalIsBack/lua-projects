local Super = require 'applications.dummy.gui.windows.Process'
local Self = Super:clone("NetworkWindow")

Self.ID_NAME = "network"

function Self:init(args)
  args.w = 320
  args.h = 240
  Super.init(self, args)
  



  return self
end




function Self:draw()
  if not self:isReal() then
    return
  end
  self:applySelectionColorTransformation()
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


  love.graphics.setColor(0/255, 0/255, 0/255)
  local w, h = 8, 8
  love.graphics.rectangle("line", math.floor( -(self.w/2) + w/2 ), math.floor( -(self.h/2) + h/2 + 16 ), self.w - w, self.h - h - 16)
  
  love.graphics.setColor(255/255, 255/255, 255/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) + w/2 ), math.floor( -(self.h/2) + h/2 + 16 ), self.w - w, self.h - h - 16)
  
  
  
  

  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

return Self
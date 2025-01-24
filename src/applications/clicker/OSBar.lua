local Super = require 'engine.gui.Node'
local Self = Super:clone("Bar")

function Self:init(args)
  Super.init(self, args)

  self.z = 0
  self.x = 320
  self.w = 640
  self.h = 24

  
  self.legalDrag = false


  self.text_time = require("engine.gui.Text"):new{x=self.w/2, y=0, text="", color={1,1,1}, alignment="right"}
  self:insert(self.text_time)
  
  self.callbacks:register("update", function(self, dt)
    self.text_time:setText(os.date("%H:%M:%S"))
  end)

  self.text_currency = require("engine.gui.Text"):new{x=-self.w/2 + 2, y=0, text="0.00$", color={1,1,1}, alignment="left"}
  self:insert(self.text_currency)
  

  local ram_text = string.format("%.2f", self.main:getCurrentRam()) .. "MB/" .. string.format("%.2f", self.main:getMaxRam()) .. "MB"
  self.text_ram = require("engine.gui.Text"):new{x=0, y=0, text=ram_text, color={1,1,1}, alignment="center"}
  self:insert(self.text_ram)


  self.callbacks:register("update", function(selff, dt)

    --self.main.currency1 = self.main.currency1 + 0.01 * dt
    local new_currency_string = string.format("%.2f", self.main.currency1)
    self.text_currency:setText(new_currency_string .. "$")

    local new_ram_string = string.format("%.2f", self.main:getCurrentRam()) .. "MB/" .. string.format("%.2f", self.main:getMaxRam()) .. "MB"
    self.text_ram:setText(new_ram_string)
  end)

	return self
end


function Self:draw()
  if not self.visibleAndActive then
    return
  end
  
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  

  love.graphics.setLineWidth(2)

  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)
  
  self.contents:callall("draw")

  love.graphics.pop()
end

return Self

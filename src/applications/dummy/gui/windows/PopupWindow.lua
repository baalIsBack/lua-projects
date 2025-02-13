local Super = require 'engine.gui.Window'
local Self = Super:clone("PopupWindow")


function Self:init(args)
  args.w = args.w or (32 * 4)
  args.h = args.h or (24 * 2.75)
  args.x = args.x or math.random(0+args.w/2, 640-args.w/2)
  args.y = args.y or math.random(0+args.h/2, 480-args.h/2)
  args.title = args.title or ""
  Super.init(self, args)

  self.text_string = args.text or "WARNING"
  
  self.bar.color = {255/255, 30/255, 15/255}

  
  self.text = require 'engine.gui.Text':new{main=self.main, text = self.text_string, color={0,0,0}, x = -self.w/2 +2, y = 16+6-self.h/2, wrapLimit = self.w-4, alignment = "left"}
  self:insert(self.text)

  if args.hasOkButton then
    self:addOkButton()
  end

  return self
end

function Self:addOkButton()
  if not self.alreadyAddedOkButton then
    self.alreadyAddedOkButton = true
    local button = require 'engine.gui.Button':new{main=self.main, x = 0, y = self.h/2-4-8, w = 20, h = 14}
    self:insert(button)
    local text = require 'engine.gui.Text':new{main=self.main, text = "OK", color={0,0,0}, x = 0, y = -2, wrapLimit = 64, alignment = "center"}
    button:insert(text)
    button.callbacks:register("onClicked", function()
      self:deactivate()
    end)
  end
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
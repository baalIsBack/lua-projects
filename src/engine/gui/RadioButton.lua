local Super = require 'engine.gui.Button'
local Self = Super:clone("Radiobutton")

local mt_for_radio_button_groups = {
  __mode = "v"-- weak values
}
Self.GLOBAL_RADIO_BUTTON_GROUPS = {}

function Self:init(args)
  args.w = args.w or 14
  args.h = args.h or 14
  Super.init(self, args)
  self.raw_text = args.text
  if self.text then
    self.text.x = 10 + self.text:getWidth()/2
  end

  if Self.GLOBAL_RADIO_BUTTON_GROUPS[args.group] == nil then
    Self.GLOBAL_RADIO_BUTTON_GROUPS[args.group] = setmetatable({}, mt_for_radio_button_groups)
    self.checked = true
  end
  table.insert(Self.GLOBAL_RADIO_BUTTON_GROUPS[args.group], self)
  self.group = Self.GLOBAL_RADIO_BUTTON_GROUPS[args.group]

  self.text_checkmark = require 'engine.gui.Text':new{
    main = self.main,
    x = 1,
    y = -2,
    text = "x",
    alignment = "center",
  }
  self.text_checkmark:setFont(FONTS["dialog"])
  --self:insert(self.text_checkmark)


  self.callbacks:register("onClicked", function(x, y)
    self:check()
  end)

	return self
end

function Self:isChecked()
  return self.checked
end

function Self:check()
  for i, v in ipairs(self.group) do
    if v ~= self then
      v:uncheck()
    end
  end
  self.checked = true
end

function Self:uncheck()
  self.checked = false
end

function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)
  
  love.graphics.setColor(self.color)
  if not self.enabled then
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor((r/1.2), (g/1.2), (b/1.2), a)
  end
  
  self.text_checkmark.visibleAndActive = self.checked
  local pressedHeightDifference = 0
  if self.isStillClicking and self.enabled then
    pressedHeightDifference = 2
    love.graphics.translate(0, pressedHeightDifference)
    love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
    love.graphics.setColor(128/255, 128/255, 128/255)
    love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
    
  else
    love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
    love.graphics.setColor(128/255, 128/255, 128/255)
    love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
    love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)
  end
  self.text_checkmark:draw()

  love.graphics.translate(0, -pressedHeightDifference)
  
  
  self.contents:callall("draw")

  love.graphics.pop()
end


return Self

local Super = require 'engine.gui.Node'
local Self = Super:clone("Text")

local FONT_DEFAULT = love.graphics.newFont("submodules/lua-projects-private/font/spacecargo.ttf", 10)--love.graphics.newFont("submodules/lua-projects-private/font/Weiholmir Standard/Weiholmir_regular.ttf", 7*2)

function Self:init(args)
  Super.init(self, args)

  self.font = FONT_DEFAULT
  self:setText(args.text)

  self.alignment = args.alignment or "center"
  self.color = args.color or {0, 0, 0, 1}

	return self
end

function Self:setText(text)
  self.text = text
  local w, h = self.font:getWidth(self.text), self.font:getHeight()
  self.w = w
  self.h = h
end

function Self:getText()
  return self.text
end

function Self:setAlignment(align)
  assert(align == "center" or align == "left" or align == "right", "Alignment '" .. align .. "' not supported.")
  self.alignment = align
end




function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  local priorFont = love.graphics.getFont()
  love.graphics.setFont(self.font)

  love.graphics.setColor(self.color)
  if self.alignment == "center" then
    love.graphics.print(self.text, -self.w/2, -self.h/2)
  elseif self.alignment == "right" then
    love.graphics.print(self.text, -self.w, -self.h/2)
  elseif self.alignment == "left" then
    love.graphics.print(self.text, 0, -self.h/2)
  end
  love.graphics.setColor(1, 1, 1)
  
  love.graphics.setFont(priorFont)
  self.contents:callall("draw")

  love.graphics.pop()
end

function Self:isLeaf(x, y)
  return false
end

return Self

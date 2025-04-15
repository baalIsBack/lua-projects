local Super = require 'engine.Prototype'
local Self = Super:clone("KeyboardControllableLayout")


function Self:init(args)
  Super.init(self, args)

  self.name = args.name or ""

  self.content = args.content
  self.onThe = {
    right = nil,
    left = nil,
    up = nil,
    down = nil
  }

  self.selected = false

  return self
end

function Self:select()
  self.selected = true
end

function Self:isSelected()
  return self.selected
end

function Self:setRight(kcl)
  self.onThe.right = kcl
end

function Self:setLeft(kcl)
  self.onThe.left = kcl  
end

function Self:setUp(kcl)
  self.onThe.up = kcl
end

function Self:setDown(kcl)
  self.onThe.down = kcl
end

function Self:moveRight()
  self.selected = false
  local next = self.onThe.right or self
  next:select()
  return next
end

function Self:moveLeft()
  self.selected = false
  local next = self.onThe.left or self
  next:select()
  return next
end

function Self:moveUp()
  self.selected = false
  local next = self.onThe.up or self
  next:select()
  return next
end

function Self:moveDown()
  self.selected = false
  local next = self.onThe.down or self
  next:select()
  return next
end

return Self
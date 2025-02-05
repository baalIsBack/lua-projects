local Super = require 'engine.gui.Node'
local Self = Super:clone("List")

local onInsertReaction1 = function(self, obj)
  self:recalculateChildPositions()
end

function Self:init(args)
  Super.init(self, args)

  self.w = args.w
  self.h = args.h
  self.numberOfShownElements = args.numberOfShownElements or 6

  self.wasDown = false
  self.isDown = false

  self.first_item_id = 1

  self.callbacks:register("onInsert", onInsertReaction1)

	return self
end


function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)

  love.graphics.setColor(205/255, 205/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  
  self.contents:callall("draw")

  love.graphics.pop()
end

function Self:recalculateChildPositions()
  local startPositionY = -self.h/2 + 16
  for i, v in ipairs(self.contents:getList()) do
    if i >= self.first_item_id and i < self.first_item_id+self.numberOfShownElements then
      v.x = 0
      v.y = startPositionY + (i - self.first_item_id) * v.h
    else
      v.x = 10000
      v.y = 10000
    end
  end
end

function Self:up()
  if self.first_item_id <= 1 then
    return
  end
  self.first_item_id = self.first_item_id - 1
  self:recalculateChildPositions()
end

function Self:down()
  if self.first_item_id > #self.contents:getList() - self.numberOfShownElements then
    return
  end
  self.first_item_id = self.first_item_id + 1
  self:recalculateChildPositions()
end

return Self

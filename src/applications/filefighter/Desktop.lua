local Super = require 'engine.gui.Node'
local Self = Super:clone("Desktop")

function Self:init(args)
  self.hasContents = true
  Super.init(self, args)
  self.main = args.main


  
  local osbar = OSBar:new{y = 480-16+4, color = {0/255, 1/255, 129/255}, main=self.main,}
  self.contents:insert(osbar)

  self.contents:insert(Icon_Archive:new{main=self.main, x = 100, y = 100})
  self.contents:insert(Icon_Folder:new{main=self.main, x = 200, y = 200})

  self.hand = nil

  self.callbacks:declare("onDropped")

  self.callbacks:register("onMouseReleased", function(self, x, y)
    print("Mouse released at: ", x, y)
    if self.main.desktop.hand then
        self.callbacks:call("onDropped", {self, self.main.desktop.hand, x, y})
    end
  end)

  self.callbacks:register("onDropped", function(selff, obj, x, y)
    local mx, my = require 'engine.Mouse':getPosition()
    self.contents:insert(obj)
    self.main.desktop.hand = nil
    print("Dropped item at: ", mx, my)
    --self:repositionIcons()
  end)
  


	return self
end

function Self:draw()
  table.sort(self.contents.content_list, function(a, b)
    if a.alwaysOnTop and not b.alwaysOnTop then
        return false
    elseif not a.alwaysOnTop and b.alwaysOnTop then
        return true
    else
        return a.z < b.z
    end
  end)

  love.graphics.setBackgroundColor(32/255, 140/255, 112/255)
  self.contents:callall("draw")
  local x_dist = 32
  local y_dist = 32
  for x = 0, 640-x_dist, x_dist do
    --love.graphics.line(x, 0, x, 480)
  end
  for y = 0, 480-y_dist, y_dist do
    --love.graphics.line(0, y, 640, y)
  end

  if self.hand then
    self.hand:draw()
  end

end

function Self:update(dt)
  table.sort(self.contents.content_list, function(a, b)
    if a.alwaysOnTop and not b.alwaysOnTop then
      return false
    elseif not a.alwaysOnTop and b.alwaysOnTop then
      return true
    else
      return a.z < b.z
    end
  end)

  local t = self.contents.content_list
  for i=#t, 1, -1 do
    local v = t[i]
    if not v:isReal() then
      table.remove(t, i)
    end
  end

  if not love.mouse.isDown(1) then
    self.hand = nil
  end

  self.contents:callall("update", dt)

  if self.hand then
    self.hand:update(dt)
  end
  
end

function Self:grab(item)
  self.hand = item
  for i=#self.contents.content_list, 1, -1 do
    local v = self.contents.content_list[i]
    if v == item then
      table.remove(self.contents.content_list, i)
      break
    end
  end
end

function Self:mousereleased( x, y, button, istouch, presses )
  self.contents:callall("mousereleased", x, y, button, istouch, presses)
  if self.hand then
    self.hand:mousereleased(x, y, button, istouch, presses)
    self.contents:insert(self.hand)
    self.hand = nil
  end
end


return Self

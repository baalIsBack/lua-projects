local Super = require 'engine.Prototype'
local Self = Super:clone("Desktop")

function Self:init(args)
  self.hasContents = true
  Super.init(self, args)
  self.main = args.main


  
  local osbar = require 'applications.dummy.gui.elements.OSBar':new{y = 480-16+4, color = {0/255, 1/255, 129/255}, main=self.main,}
  self.contents:insert(osbar)

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
  self.contents:callall("update", dt)
end


return Self

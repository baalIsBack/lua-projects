local Super = require 'engine.gui.Button'
local Self = Super:clone("DesktopIcon")

function Self:init(args)
  Super.init(self, args)

  self.img = args.img or love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons/w98_directory_closed.png")
  self.img = args.img or love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons/w98_directory_closed.png")
  
  self.name = args.name or "File"
  
  self.z = -1
  self.targetApp = args.targetApp
  self.callbacks:register("onClicked", function(selff)
    if not self.targetApp then
      return
    end
    self.targetApp:activate()
    self.targetApp:bringToFront()
    self.targetApp:setFocus()
  end)

  self:insert( require 'engine.gui.Image':new{img = self.img, x = 0, y = 0})
  self:insert( require 'engine.gui.Text':new{text = self.name, color={1,1,1}, x = 0, y = 25})
  
	return self
end

function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)
  
  
  love.graphics.setColor(1, 1, 1)
  if self.isStillClicking then
    love.graphics.setColor(192/255, 192/255, 230/255, 0.4)
    love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  end
  
  self.contents:callall("draw")

  love.graphics.pop()
end

return Self

local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Desktop")

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_closed.png")

function Self:init(args)
  Super.init(self, args)

  
  self.callbacks:register("onClicked", function(selff)
    self:openApp()
  end)

  
	return self
end

function Self:openApp()
  if not self.targetApp then
    return
  end
  self.targetApp:activate()
  self.targetApp:bringToFront()
  self.targetApp:setFocus()
end

function Self:setTargetApp(app)
  self.targetApp = app
end



return Self

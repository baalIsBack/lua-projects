local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Stat")

Self.ID_NAME = "terminal"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_console_prompt.png")
Self.NAME = "Terminal"
Self.targetPrototype = require 'src.applications.dummy.gui.windows.TerminalWindow'

function Self:init(args)
  Super.init(self, args)

  print("!!!!!!!!", self.main.processes.terminal)
  self:setTargetApp(self.main.processes.terminal)

  
	return self
end



return Self

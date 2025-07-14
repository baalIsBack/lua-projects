local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Stat")

Self.INTERNAL_NAME = "ressources"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_hardware-3.png")--w98_chip_ramdrive-2.png
Self.DISPLAY_NAME = "Ressources"
Self.TARGET_PROTOTYPE = require 'src.applications.dummy.gui.windows.RessourcesWindow'


function Self:init(args)
  Super.init(self, args)

  
  self:setTargetApp(self.main.processes.ressources)


  
	return self
end



return Self

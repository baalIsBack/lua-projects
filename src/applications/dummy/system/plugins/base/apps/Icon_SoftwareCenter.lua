local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_SoftwareCenter")

Self.ID_NAME = "softcenter"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_printer_cool-2.png")
Self.NAME = "Software Center"
Self.targetPrototype = require 'src.applications.dummy.gui.windows.SoftwareCenterWindow'

function Self:init(args)
  Super.init(self, args)
  return self
end

return Self

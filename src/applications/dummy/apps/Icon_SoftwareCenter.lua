local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_SoftwareCenter")

Self.INTERNAL_NAME = "softcenter"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_printer_cool-2.png")
Self.DISPLAY_NAME = "Software Center"
Self.TARGET_PROTOTYPE = require 'src.applications.dummy.gui.windows.SoftwareCenterWindow'

function Self:init(args)
  Super.init(self, args)
  return self
end

return Self

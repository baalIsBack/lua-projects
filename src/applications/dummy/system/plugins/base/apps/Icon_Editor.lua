local Super = require 'applications.dummy.gui.elements.Icon_Desktop'
local Self = Super:clone("Icon_Editor")

Self.ID_NAME = "editor"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_notepad-1.png")
Self.NAME = "Editor"
Self.targetPrototype = require 'applications.dummy.gui.windows.EditorWindow'

function Self:init(args)
  Super.init(self, args)

  self:setTargetApp(self.main.processes.editor)


  
	return self
end



return Self

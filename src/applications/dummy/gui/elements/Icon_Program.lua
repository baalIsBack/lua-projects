local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Program")

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_executable-0.png")
Self.NAME = "Program"

function Self:init(args)
  Super.init(self, args)
  
  self.callbacks:register("onClicked", function(selff)
    --create popup in main
    

    if not self:open() then
      
      self.main.processes:makePopup({
        title = "Warning",
        text = "Your system has prevented opening this program as it may damage your system.",
        hasOkButton = true,
        h = 100,
      })
      return
    end
    for i=1, 1, 1 do
      self.main.antivirus:infect(math.random(2, 3))
      self.main.antivirus:doVirus()
    end

  end)
  
  
  
  
  
	return self
end



return Self

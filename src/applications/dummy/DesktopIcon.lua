local Super = require 'applications.dummy.Icon'
local Self = Super:clone("DesktopIcon")

function Self:init(args)
  Super.init(self, args)

  
  
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

  
	return self
end



return Self

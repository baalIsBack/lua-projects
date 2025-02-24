local Super = require 'engine.gui.Window'
local Self = Super:clone("Process")

Self.ID_NAME = "undefined"

function Self:init(args)
  args.title = args.title or "undefined"
  args.visibleAndActive = false
  Super.init(self, args)
  


  

  self.bar.close_button.callbacks:register("onClicked", function(x, y)
    self.main.processes:closeProcess(self)
  end)


  return self
end




return Self

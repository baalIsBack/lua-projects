local Super = require 'applications.dummy.gui.elements.Icon'
local Self = Super:clone("Icon_Desktop")

Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_closed.png")
Self.filetype = "executable"
Self.unique = true  -- Default: allow multiple instances

function Self:init(args)
  Super.init(self, args)

  self.callbacks:register("onClicked", function(selff)
    self:makeTargetApp()
    print("--", self.main.processes:openProcess(self.targetApp))
  end)

  --self:makeTargetApp()
  
  return self
end

function Self:makeTargetApp()
  local canOpen = self.main.processes:canOpenProcess(self.TARGET_PROTOTYPE)
  -- Check if the app is unique and already running
  local isRunning = self.main.processes:isProcessRunning(self.TARGET_PROTOTYPE)
  if self.unique and self.TARGET_PROTOTYPE and isRunning then
    -- If unique and already running, do nothing
    return
  end
  print("a", self.TARGET_PROTOTYPE, AntivirusWindow, canOpen)
  if self.TARGET_PROTOTYPE and canOpen then
    self.main.processes:makeProcess(self.TARGET_PROTOTYPE)
  else
    self.main.processes:makePopup({
      text = "The application '" .. self.DISPLAY_NAME .. "' is not available.",
      title = "Application Error"
    })
  end
end

function Self:setTARGET_PROTOTYPE(appPrototype)
  self.TARGET_PROTOTYPE = appPrototype
end

function Self:setTargetApp(app)
  self.targetApp = app  -- Always set this reference
end

return Self

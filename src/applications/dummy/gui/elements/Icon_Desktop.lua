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
  local canOpen = self.main.processes:canOpenProcess(self.targetPrototype)
  -- Check if the app is unique and already running
  local isRunning = self.main.processes:isProcessRunning(self.targetPrototype)
  if self.unique and self.targetPrototype and isRunning then
    -- If unique and already running, do nothing
    return
  end
  
  if self.targetPrototype and canOpen then
    self.main.processes:makeProcess(self.targetPrototype)
  else
    self.main.processes:makePopup({
      text = "The application '" .. self.NAME .. "' is not available.",
      title = "Application Error"
    })
  end
end

function Self:setTargetPrototype(appPrototype)
  self.targetPrototype = appPrototype
end

function Self:openTargetApp()
  local canOpen = self.main.processes:canOpenProcess(self.targetApp)
  if self.targetApp and canOpen then
    self.main.processes:openProcess(self.targetApp)
  else
    self.main.processes:makePopup({
      text = "The application '" .. self.NAME .. "' is not available.",
      title = "Application Error"
    })
  end
end

function Self:setTargetApp(app)
  self.targetApp = app  -- Always set this reference
end

function Self:setUnique(isUnique)
  self.unique = isUnique or false
end

return Self

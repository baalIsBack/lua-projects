local Super = require 'applications.dummy.gui.windows.Process'  -- Make sure this is the correct parent class
local Self = Super:clone("SoftwareCenterWindow")

Self.TITLE = "Software Center"
Self.ID_NAME = "softcenter"
Self.w = 360
Self.h = 240

function Self:init(args)
  -- Store main reference explicitly before calling super
  self.main = args.main
  
  Super.init(self, args)
  
  -- Use a delayed initialization to ensure everything is ready
  if self.main then
    self.main.timedmanager:after(0.1, function()
      self:refreshAppList()
    end)
  else
    print("Warning: Main reference is nil in SoftwareCenterWindow")
  end
  
  return self
end

function Self:refreshAppList()
  self:clearApps()
  
  -- Add error handling for apps access
  if not self.main or not self.main.apps then
    self:addLabel("ERROR: Cannot access app system", 20, 50)
    return
  end
  
  -- Add sections for different app types
  self:addLabel("Available Third-Party Software:", 10, 30)
  
  local y = 50
  local installable = self.main.apps.installableApps or {}
  local hasThirdPartyApps = false
  local hasSystemApps = false
  
  -- First display third-party apps
  for appName, appData in pairs(installable) do
    -- Skip system apps for now
    if appData.isSystem then
      hasSystemApps = true
      goto continue
    end
    
    hasThirdPartyApps = true
    -- App name label
    self:addLabel((appData.name or appName), 20, y)
    
    -- Install button
    local button = self:addButton("Install", self.w - 80, y - 5, 70, 20)
    button.onClick = function()
      if self.main.apps:installRegisteredApp(appName) then
        -- Refresh the list after installing
        self:refreshAppList()
      end
    end
    
    -- Description if available
    if appData.description then
      self:addLabel(appData.description, 20, y + 15, {r=180/255, g=180/255, b=180/255})
      y = y + 35
    else
      y = y + 25
    end
    
    ::continue::
  end
  
  if not hasThirdPartyApps then
    self:addLabel("No third-party apps available.", 20, y)
    y = y + 30
  else
    y = y + 10
  end
  
  -- Then display system apps if available
  if hasSystemApps then
    self:addLabel("System Applications:", 10, y)
    y = y + 20
    
    for appName, appData in pairs(installable) do
      if not appData.isSystem then
        goto continue_system
      end
      
      -- App name label
      self:addLabel((appData.name or appName), 20, y)
      
      -- Install button
      local button = self:addButton("Install", self.w - 80, y - 5, 70, 20)
      button.onClick = function()
        if self.main.apps:installRegisteredApp(appName) then
          -- Refresh the list after installing
          self:refreshAppList()
        end
      end
      
      -- Description if available
      if appData.description then
        self:addLabel(appData.description, 20, y + 15, {r=180/255, g=180/255, b=180/255})
        y = y + 35
      else
        y = y + 25
      end
      
      ::continue_system::
    end
  end
  
  if not hasThirdPartyApps and not hasSystemApps then
    self:addLabel("No installable apps available.", 20, 50)
  end
end

function Self:addLabel(text, x, y, color)
  local label = require 'src.engine.gui.Text':new{
    text = text,
    x = x,
    y = y,
    color = color or {r=1, g=1, b=1},
    main = self.main
  }
  self:insert(label)
  return label
end

function Self:addButton(text, x, y, w, h)
  local button = require 'engine.gui.Button':new{
    text = text,
    x = x,
    y = y,
    w = w or 60,
    h = h or 20,
    main = self.main
  }
  self:insert(button)
  return button
end

function Self:clearApps()
  -- Remove all previous elements except window chrome
  for i = #self.contents.content_list, 1, -1 do
    local element = self.contents.content_list[i]
    if element ~= self.label_title and 
       element ~= self.button_close and 
       element ~= self.button_minimize then
      self.contents:remove(element)
    end
  end
end

return Self

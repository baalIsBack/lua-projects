local Super = require 'engine.Prototype'
local Self = Super:clone("Plugin")

-- Plugin states
Self.STATE_UNLOADED = 0
Self.STATE_LOADED = 1
Self.STATE_ENABLED = 2
Self.STATE_DISABLED = 3
Self.STATE_ERROR = 4

function Self:init(args)
  args = args or {}
  self.main = args.main
  self.name = args.name or "UnnamedPlugin"
  self.description = args.description or "No description provided"
  self.version = args.version or "1.0.0"
  self.author = args.author or "Unknown"
  self.dependencies = args.dependencies or {}
  self.state = Self.STATE_UNLOADED
  self.hasCallbacks = true
  
  Super.init(self, args)
  
  self.callbacks:declare("onLoad")
  self.callbacks:declare("onEnable")
  self.callbacks:declare("onDisable")
  self.callbacks:declare("onUnload")
  self.callbacks:declare("onUpdate")
  
  return self
end

function Self:load()
  if self.state ~= Self.STATE_UNLOADED then
    return false, "Plugin already loaded"
  end
  
  local success, error = pcall(function()
    self.callbacks:call("onLoad", {self})
  end)
  
  if not success then
    self.state = Self.STATE_ERROR
    return false, "Error loading plugin: " .. (error or "Unknown error")
  end
  
  self.state = Self.STATE_LOADED
  return true
end

function Self:enable()
  if self.state ~= Self.STATE_LOADED and self.state ~= Self.STATE_DISABLED then
    return false, "Plugin not in loadable state"
  end
  
  local success, error = pcall(function()
    self.callbacks:call("onEnable", {self})
  end)
  
  if not success then
    self.state = Self.STATE_ERROR
    return false, "Error enabling plugin: " .. (error or "Unknown error")
  end
  
  self.state = Self.STATE_ENABLED
  return true
end

function Self:disable()
  if self.state ~= Self.STATE_ENABLED then
    return false, "Plugin not enabled"
  end
  
  local success, error = pcall(function()
    self.callbacks:call("onDisable", {self})
  end)
  
  if not success then
    self.state = Self.STATE_ERROR
    return false, "Error disabling plugin: " .. (error or "Unknown error")
  end
  
  self.state = Self.STATE_DISABLED
  return true
end

function Self:unload()
  if self.state == Self.STATE_UNLOADED then
    return false, "Plugin not loaded"
  end
  
  if self.state == Self.STATE_ENABLED then
    local success, error = self:disable()
    if not success then
      return false, error
    end
  end
  
  local success, error = pcall(function()
    self.callbacks:call("onUnload", {self})
  end)
  
  if not success then
    self.state = Self.STATE_ERROR
    return false, "Error unloading plugin: " .. (error or "Unknown error")
  end
  
  self.state = Self.STATE_UNLOADED
  return true
end

function Self:update(dt)
  if self.state == Self.STATE_ENABLED then
    self.callbacks:call("onUpdate", {self, dt})
  end
end

function Self:registerValues(values)
  -- Override in subclasses
end

function Self:registerCommands(commandSystem)
  -- Override in subclasses
end

function Self:getState()
  return self.state
end

function Self:getName()
  return self.name
end

function Self:getDescription()
  return self.description
end

function Self:getVersion()
  return self.version
end

function Self:getAuthor()
  return self.author
end

return Self

local Plugin = require 'applications.dummy.system.Plugin'
local Self = Plugin:clone("BasePlugin")

function Self:init(args)
  args = args or {}
  Plugin.init(self, args)
  
  -- Register default callbacks
  self.callbacks:register("onLoad", function(selff)
    print("Plugin '" .. self.name .. "' loaded")
  end)
  
  self.callbacks:register("onEnable", function(selff)
    print("Plugin '" .. self.name .. "' enabled")
  end)
  
  self.callbacks:register("onDisable", function(selff)
    print("Plugin '" .. self.name .. "' disabled")
  end)
  
  self.callbacks:register("onUnload", function(selff)
    print("Plugin '" .. self.name .. "' unloaded")
  end)
  
  return self
end

function Self:registerHook(hookName, callback)
  if not self.main then
    print("Cannot register hook: main not available")
    return false
  end
  
  -- Register hook with the main application
  -- This is just a sample implementation
  -- You'll need to adapt this to your hook system
  if self.main.hooks and self.main.hooks.register then
    return self.main.hooks:register(hookName, callback)
  else
    print("Warning: Hook system not found")
    return false
  end
end

return Self

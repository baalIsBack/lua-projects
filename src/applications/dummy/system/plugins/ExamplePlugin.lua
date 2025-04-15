local BasePlugin = require 'applications.dummy.system.BasePlugin'
local Self = BasePlugin:clone("ExamplePlugin")

function Self:init(args)
  args = args or {}
  args.name = "ExamplePlugin"
  args.description = "A simple example plugin that demonstrates the plugin system"
  args.version = "1.0.0"
  args.author = "GitHub Copilot"
  
  BasePlugin.init(self, args)
  
  -- Override default callbacks
  self.callbacks:register("onLoad", function(selff)
    print("[ExamplePlugin] Successfully loaded!")
  end)
  
  self.callbacks:register("onEnable", function(selff)
    print("[ExamplePlugin] Plugin enabled - Now I can do my work!")
  end)
  
  self.callbacks:register("onDisable", function(selff)
    print("[ExamplePlugin] Plugin disabled - Stopping all activities")
  end)
  
  self.callbacks:register("onUpdate", function(selff, dt)
    -- This will be called every frame when the plugin is enabled
    -- For demonstration, we won't print anything to avoid spamming the console
  end)
  
  return self
end

function Self:registerValues(values)
  if not values then return end
  
  -- Register some example values
  values:setOnce("example_plugin_count", 0)
  values:setOnce("example_plugin_last_active", 0)
  
  print("[ExamplePlugin] Registered values with the system")
end

function Self:registerCommands(commandSystem)
  if not commandSystem then return end
  
  -- Register a custom command
  commandSystem:register("example", function(args)
    print("[ExamplePlugin] Example command executed with args: " .. table.concat(args, ", "))
    return true, "Command executed successfully"
  end, "Example plugin command")
  
  print("[ExamplePlugin] Registered commands with the system")
end

return Self

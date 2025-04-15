local Super = require 'engine.Prototype'
local Self = Super:clone("PluginManager")

function Self:init(args)
  self.main = args.main
  self.plugins = {}
  self.enabledPlugins = {}
  self.pluginPaths = args.pluginPaths or {
    "applications/dummy/system/plugins",  -- Default plugin location
    "applications/dummy/plugins",         -- User plugins
    "plugins",                            -- Global plugins
    "src/plugins"                         -- Added src/plugins directory
  }
  Super.init(self, args)
  return self
end

function Self:registerPlugin(pluginClass, args)
  args = args or {}
  args.main = self.main
  
  -- Check if this is a class with a constructor or a simple module
  local pluginInstance
  local pluginName
  
  -- If it has a new method, it's a class-based plugin
  if type(pluginClass.new) == "function" then
    pluginInstance = pluginClass:new(args)
    if type(pluginInstance.getName) == "function" then
      pluginName = pluginInstance:getName()
    else
      pluginName = pluginInstance.name or "unnamed_plugin"
    end
  else
    -- It's a simple module plugin, use it directly
    pluginInstance = pluginClass
    pluginName = pluginClass.name or "unnamed_plugin"
  end
  
  -- Check if plugin already registered
  if self.plugins[pluginName] then
    print("Plugin '" .. pluginName .. "' already registered")
    return false
  end
  
  -- Register the plugin
  self.plugins[pluginName] = pluginInstance
  print("Plugin '" .. pluginName .. "' registered successfully")
  return true
end

function Self:loadPlugin(pluginName)
  local plugin = self.plugins[pluginName]
  if not plugin then
    print("Plugin '" .. pluginName .. "' not found")
    return false
  end
  
  -- Load the plugin - pass main instance to the load method
  local success, error = pcall(function()
    return plugin:load(self.main)
  end)
  
  if not success then
    print("Failed to load plugin '" .. pluginName .. "': " .. tostring(error))
    return false
  end
  
  print("Plugin '" .. pluginName .. "' loaded successfully")
  return true
end

function Self:loadAllPlugins()
  local allSuccess = true
  for name, plugin in pairs(self.plugins) do
    local success = self:loadPlugin(name)
    if not success then
      allSuccess = false
    end
  end
  return allSuccess
end

function Self:enablePlugin(pluginName)
  local plugin = self.plugins[pluginName]
  if not plugin then
    print("Plugin '" .. pluginName .. "' not found")
    return false
  end
  
  -- Check if plugin has an enable method
  if type(plugin.enable) ~= "function" then
    -- No enable method, consider it already enabled
    self.enabledPlugins[pluginName] = plugin
    print("Plugin '" .. pluginName .. "' has no enable method, considering enabled")
    return true
  end
  
  -- Call enable method
  local success, error = pcall(function()
    return plugin:enable()
  end)
  
  if not success then
    print("Failed to enable plugin '" .. pluginName .. "': " .. tostring(error))
    return false
  end
  
  -- Add to enabled plugins list
  self.enabledPlugins[pluginName] = plugin
  
  print("Plugin '" .. pluginName .. "' enabled successfully")
  return true
end

function Self:enableAllPlugins()
  local allSuccess = true
  for name, _ in pairs(self.plugins) do
    local success = self:enablePlugin(name)
    if not success then
      allSuccess = false
    end
  end
  return allSuccess
end

function Self:disablePlugin(pluginName)
  local plugin = self.enabledPlugins[pluginName]
  if not plugin then
    print("Plugin '" .. pluginName .. "' not enabled")
    return false
  end
  
  -- Disable the plugin
  local success, error = plugin:disable()
  if not success then
    print("Failed to disable plugin '" .. pluginName .. "': " .. error)
    return false
  end
  
  -- Remove from enabled plugins list
  self.enabledPlugins[pluginName] = nil
  
  print("Plugin '" .. pluginName .. "' disabled successfully")
  return true
end

function Self:update(dt)
  for _, plugin in pairs(self.enabledPlugins) do
    -- Check if plugin has an update method
    if type(plugin.update) == "function" then
      plugin:update(dt)
    end
  end
end

function Self:getPlugin(pluginName)
  return self.plugins[pluginName]
end

function Self:getPlugins()
  return self.plugins
end

function Self:getEnabledPlugins()
  return self.enabledPlugins
end

function Self:discoverPlugins()
  local discoveredPlugins = {}
  
  print("PluginManager: Scanning for plugins in " .. #self.pluginPaths .. " directories")
  
  -- Scan each plugin directory
  for _, path in ipairs(self.pluginPaths) do
    print("PluginManager: Scanning " .. path)
    local success, plugins = pcall(function()
      return self:scanDirectory(path)
    end)
    
    if success and plugins then
      for name, plugin in pairs(plugins) do
        discoveredPlugins[name] = plugin
      end
    else
      print("PluginManager: Error scanning " .. path .. ": " .. tostring(plugins))
    end
  end
  
  print("PluginManager: Discovered " .. self:tableSize(discoveredPlugins) .. " plugins")
  return discoveredPlugins
end

function Self:scanDirectory(dir)
  local plugins = {}
  
  -- Check if directory exists
  local info = love.filesystem.getInfo(dir)
  if not info or info.type ~= "directory" then
    print("Plugin directory not found: " .. dir)
    return plugins
  end
  
  -- Get all items in the directory
  local files = love.filesystem.getDirectoryItems(dir)
  
  -- First try to find init.lua files in subdirectories (plugin packages)
  for _, file in ipairs(files) do
    local path = dir .. "/" .. file
    local info = love.filesystem.getInfo(path)
    
    if info and info.type == "directory" then
      local initPath = path .. "/init.lua"
      local initInfo = love.filesystem.getInfo(initPath)
      
      if initInfo and initInfo.type == "file" then
        -- Convert path to require path (remove src/ if present, and replace / with .)
        local requirePath = path:gsub("^src/", ""):gsub("/", ".")
        
        -- Try to load the plugin
        print("PluginManager: Found plugin package at " .. requirePath)
        local success, pluginModule = pcall(require, requirePath)
        
        if success then
          -- Check if it's a valid plugin
          if self:isValidPlugin(pluginModule) then
            plugins[file] = pluginModule
            print("PluginManager: Discovered plugin package: " .. file)
          end
        else
          print("PluginManager: Failed to load plugin " .. requirePath .. ": " .. tostring(pluginModule))
        end
      end
    end
  end
  
  -- Also scan for .lua files directly (legacy plugins)
  for _, file in ipairs(files) do
    if file:match("%.lua$") then
      local pluginPath = dir .. "/" .. file
      local requirePath = pluginPath:gsub("^src/", ""):gsub("%.lua$", ""):gsub("/", ".")
      
      -- Skip init.lua files we already processed
      if not requirePath:match("%.init$") then
        local success, pluginModule = pcall(require, requirePath)
        
        if success and self:isValidPlugin(pluginModule) then
          local pluginName = file:gsub("%.lua$", "")
          plugins[pluginName] = pluginModule
          print("PluginManager: Discovered plugin: " .. pluginName)
        end
      end
    end
  end
  
  return plugins
end

function Self:isValidPlugin(module)
  -- Check if the module is a table
  if type(module) ~= "table" then
    return false
  end
  
  -- Accept modules that have load and unload methods
  if type(module.load) == "function" and type(module.unload) == "function" then
    return true
  end
  
  -- Try to find Plugin in its ancestry
  local meta = getmetatable(module)
  while meta do
    if meta.__index and meta.__index.TYPE_NAME == "Plugin" then
      return true
    end
    meta = getmetatable(meta.__index)
  end
  
  return false
end

function Self:tableSize(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

function Self:loadDiscoveredPlugins()
  local discovered = self:discoverPlugins()
  local count = 0
  
  for name, pluginClass in pairs(discovered) do
    if not self.plugins[name] then
      if self:registerPlugin(pluginClass) then
        count = count + 1
      end
    end
  end
  
  print("Loaded " .. count .. " new plugins")
  return count > 0
end

-- Add a helper method for integrating plugin apps
function Self:registerPluginApp(pluginName, iconClass, windowClass)
  local system = self.main
  local processes = system.processes
  local apps = system.apps
  
  if not processes or not apps then
    print("Warning: Cannot register plugin app, processes or apps system not available")
    return false
  end
  
  -- Create window in processes system if needed
  if windowClass and not processes:getProcess(pluginName) then
    local process = processes:makeWindow(windowClass, 250, 250)
    -- Add the window to processes contents
    processes.contents:insert(process)
  end
  
  -- Create and place icon
  if iconClass then
    local x, y, slotId = apps:getFreeDesktopSlot()
    local icon = iconClass:new{
      main = system,
      x = 32 + x * 64,
      y = 32 + y * 64,
      w = 64,
      h = 64
    }
    
    -- Link to process window if available
    if processes:getProcess(pluginName) then
      icon:setTargetApp(processes:getProcess(pluginName))
    end
    
    -- Store the desktop slot for later removal
    icon.desktop_slot_id_for_removal = slotId
    apps.usedDesktopSlots[slotId] = true
    
    -- Add icon to scene
    system:insert(icon)
    
    -- Store icon in apps system for reference
    apps[pluginName] = icon
    
    return icon
  end
  
  return nil
end

function Self:unregisterPluginApp(pluginName)
  local system = self.main
  local processes = system.processes
  local apps = system.apps
  
  if not processes or not apps then
    return false
  end
  
  -- Remove icon if it exists
  if apps[pluginName] then
    local icon = apps[pluginName]
    system:remove(icon)
    apps.usedDesktopSlots[icon.desktop_slot_id_for_removal] = nil
    apps[pluginName] = nil
  end
  
  -- Close and remove the process if it's open
  local process = processes:getProcess(pluginName)
  if process and process:isOpen() then
    processes:closeProcess(processes:getProcess(pluginName))
  end
  
  return true
end

return Self

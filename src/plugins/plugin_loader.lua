local PluginLoader = {}
local loadedPlugins = {}

function PluginLoader:init(system)
  self.system = system
  return self
end

function PluginLoader:loadPlugins()
  local lfs = love.filesystem
  local items = lfs.getDirectoryItems("src/plugins")
  
  for _, item in ipairs(items) do
    if lfs.getInfo("src/plugins/" .. item, "directory") and item ~= "plugin_loader" then
      self:loadPlugin(item)
    end
  end
end

function PluginLoader:loadPlugin(pluginName)
  local success, plugin = pcall(require, "plugins." .. pluginName)
  
  if success and type(plugin) == "table" and plugin.load then
    local loaded = plugin:load(self.system)
    if loaded then
      loadedPlugins[pluginName] = plugin
      print("Loaded plugin: " .. (plugin.name or pluginName))
    end
  else
    print("Failed to load plugin: " .. pluginName)
  end
end

function PluginLoader:unloadPlugin(pluginName)
  if loadedPlugins[pluginName] then
    local unloaded = loadedPlugins[pluginName]:unload()
    if unloaded then
      loadedPlugins[pluginName] = nil
      print("Unloaded plugin: " .. pluginName)
    end
  end
end

function PluginLoader:getLoadedPlugins()
  return loadedPlugins
end

return PluginLoader

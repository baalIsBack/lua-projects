local Super = require 'engine.Prototype'
local Self = Super:clone("Processes")



function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  self.hasContents = true
  self.hasCallbacks = true
  Super.init(self)

  self.callbacks:declare("onInstall")
  self.callbacks:declare("onUninstall")

  self.knownApps = {}
  self.installedApps = {}
  
  --self:loadAppIcons()

  self.usedDesktopSlots = {}


  return self
end

local function assertAppPackage(appPackage)
  assert(appPackage.iconPrototype, "iconPrototype is required")
  
end

function Self:registerApp(appPackage)
  assertAppPackage(appPackage)
  local app_name = appPackage.appName or appPackage.app.ID_NAME
  self.knownApps[app_name] = appPackage.iconPrototype
  --self[app.ID_NAME] = app
  --app ::icon
  --process ::window
  return true
end

function Self:unregisterApp(app)
  local app_name = app_name or app.ID_NAME
end

function Self:getFreeDesktopSlot()
  for i = 0, 100, 1 do
    if self.usedDesktopSlots[i] == nil then
      return math.floor(i/7), i%7, i
    end
  end

  return nil, nil, nil
end

function Self:makeIcon(icon_type_name, x, y)
  return require(icon_type_name):new{
    main = self.main,
    x = 32 + x*(64),
    y = 32 + y*(64),
    w = 64,
    h = 64,
  }
end

function Self:loadAppIcons()
  self.calc = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Calc', 0, 6)

  self.stat = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Stat', 1, 0)
  self.stat:setTargetApp(self.main.processes.stat)

  self.mail = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Mail', 0, 0)

  self.terminal = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Terminal', 0, 1)
  self.terminal:setTargetApp(self.main.processes.terminal)

  self.editor = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Editor', 0, 2)

  self.files = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_FileManager', 0, 3)
  self.files:setTargetApp(self.main.processes.files)

  self.processes = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Processes', 0, 4)
  self.processes:setTargetApp(self.main.processes.processes)

  self.ressources = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Ressources', 0, 5)
  self.ressources:setTargetApp(self.main.processes.ressources)

  --self.antivirus = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Antivirus', 0, 5)
  --self.antivirus:setTargetApp(self.main.processes.antivirus)

  self.network = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Network', 0, 5)
  self.network:setTargetApp(self.main.processes.network)

  self.patcher = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Patcher', 0, 5)
  self.patcher:setTargetApp(self.main.processes.patcher)

  self.debug = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Debug', 0, 5)
  self.debug:setTargetApp(self.main.processes.debug)

  self.contacts = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Contacts', 0, 5)
  self.contacts:setTargetApp(self.main.processes.contacts)

  self.battle = self:makeIcon('applications.dummy.system.plugins.base.files.Icon_Battle', 0, 5)
  self.battle:setTargetApp(self.main.processes.battle)
  self.main:insert(self.main.processes:getProcess(self.battle.ID_NAME))
  self.contents:insert(self.battle.ID_NAME)
end

function Self:installByApp(icon)
  local app_name = icon.ID_NAME
  if self.main.values:get("rom_usage_current") + self.main.values:get("rom_usage_"..app_name) > self.main.values:get("rom_usage_total") then
    return false
  end
  self.main.values:inc("rom_usage_current", self.main.values:get("rom_usage_"..app_name))


  self.callbacks:call("onInstall", {self, app_name})

  --local process = self.main.processes:getProcess(app_name)
  --self.main:insert(process)
  self.contents:insert(app_name)
  self.main:insert(icon)

  local x, y, desktop_slot_id_for_removal = self:getFreeDesktopSlot()
  icon.desktop_slot_id_for_removal = desktop_slot_id_for_removal
  self.usedDesktopSlots[desktop_slot_id_for_removal or -1] = true
  icon:setPosition(32 + x*(64), 32 + y*(64))

  table.insert(self.installedApps, icon)

  return true
end

function Self:installedApp(app_name)
  for i, v in ipairs(self.installedApps) do
    if v.ID_NAME == app_name then
      return true
    end
  end
end

function Self:uninstall(app_name)
  if not self:installedApp(app_name) then
    return
  end
  local icon = self:getApp(app_name)
  for i, v in ipairs(self.installedApps) do
    if v.ID_NAME == app_name then
      table.remove(self.installedApps, i)
      break
    end
  end
  self.callbacks:call("onUninstall", {self, app_name})
  self.main.values:inc("rom_usage_current", -self.main.values:get("rom_usage_"..app_name))

  self.main:remove(self.main.processes:getProcess(app_name))
  self.main:remove(icon)
  self.contents:remove(app_name)

  
  if icon.desktop_slot_id_for_removal then
    self.usedDesktopSlots[icon.desktop_slot_id_for_removal] = nil
  end
  icon.desktop_slot_id_for_removal = nil
end

function Self:installByAppName(name)
  local x, y, desktop_slot_id_for_removal = self:getFreeDesktopSlot()
  if not self:getAppPrototype(name) then
    print("Unknown app: ", name)
    asdff()
  end
  local icon = self:getAppPrototype(name):new{
    main = self.main,
    x = 32 + x*(64),
    y = 32 + y*(64),
    w = 64,
    h = 64,
  }

  local app_name = icon.ID_NAME
  if self.main.values:get("rom_usage_current") + self.main.values:get("rom_usage_"..app_name) > self.main.values:get("rom_usage_total") then
    return false
  end
  self.main.values:inc("rom_usage_current", self.main.values:get("rom_usage_"..app_name))


  --self.callbacks:call("onInstall", {self, app_name})

  --self.main:insert(self.main.processes:getProcess(app_name))
  self.contents:insert(app_name)
  self.main:insert(icon)

  icon.desktop_slot_id_for_removal = desktop_slot_id_for_removal
  self.usedDesktopSlots[desktop_slot_id_for_removal or -1] = true
  icon:setPosition(32 + x*(64), 32 + y*(64))
  table.insert(self.installedApps, icon)
  return true
end

function Self:installByName(app_name)
  local icon = self:getAppPrototype(app_name)
  return self:installByApp(icon)
end

function Self:install(app_name)
  local icon = self:getAppPrototype(app_name)
  return self:installByApp(icon)
end

function Self:isInstalled(app_name)
  return self.contents:contains(app_name) or self:installedApp(app_name)
end

function Self:getApp_DEPRECATED(app_name)
  return self[app_name]
end

function Self:getAppPrototype(app_name)
  return self.knownApps[app_name]
end

function Self:getApp(app_name)
  for i, v in ipairs(self.installedApps) do
    if v.ID_NAME == app_name then
      return v
    end
  end
end

function Self:update(dt)
  
end

function Self:serialize()
  local t = {
    apps_installed = self.contents.content_list
  }
  return t
end

function Self:deserialize(raw)
  for index, value in ipairs(raw.apps_installed) do
    self.main.terminal:install(value)
  end
  return self
end



return Self
local Plugin = {}

Plugin.name = "Base"
Plugin.version = "1.0.0"
Plugin.author = "User"
Plugin.description = "Adds base functionality to the system"

function Plugin:load(system)
  -- Store reference to main system
  self.system = system

  local appPackages = {}

  local function registerApp(package)
    table.insert(appPackages, package)
  end

  
  -- Use the standard Apps/Processes pattern for integration
  if system.processes and system.apps then
    -- Register the app for installation through the apps subsystem
    registerApp({
      appName = "antivirus",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_Antivirus',
      description = "Advanced antivirus protection for your system"
    })

    registerApp({
      appName = "terminal",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_Terminal',
      description = "???"
    })

    registerApp({
      appName = "mail",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_Mail',
      description = "???"
    })

    registerApp({
      appName = "editor",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_Editor',
      description = "???"
    })

    registerApp({
      appName = "files",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_FileManager',
      description = "???"
    })

    registerApp({
      appName = "stat",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_Stat',
      description = "???"
    })

    registerApp({
      appName = "contacts",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_Contacts',
      description = "???"
    })

    registerApp({
      appName = "processes",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_Processes',
      description = "???"
    })

    registerApp({
      appName = "ressources",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_Ressources',
      description = "???"
    })

    registerApp({
      appName = "calc",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_Calc',
      description = "???"
    })

    registerApp({
      appName = "network",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_Network',
      description = "???"
    })

    registerApp({
      appName = "patcher",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_Patcher',
      description = "???"
    })

    registerApp({
      appName = "debug",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.apps.Icon_Debug',
      description = "???"
    })

    registerApp({
      appName = "archive",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Archive',
      description = "???"
    })

    registerApp({
      appName = "certificate",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Certificate',
      description = "???"
    })

    registerApp({
      appName = "channel",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Channel',
      description = "???"
    })

    registerApp({
      appName = "cinematic",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Cinematic',
      description = "???"
    })

    registerApp({
      appName = "colorprofile",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Colorprofile',
      description = "???"
    })

    registerApp({
      appName = "config",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Config',
      description = "???"
    })

    registerApp({
      appName = "disc",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Disc',
      description = "???"
    })

    registerApp({
      appName = "document",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Document',
      description = "???"
    })

    registerApp({
      appName = "drawing",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Drawing',
      description = "???"
    })

    registerApp({
      appName = "font",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Font',
      description = "???"
    })

    registerApp({
      appName = "gesture",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Gesture',
      description = "???"
    })

    registerApp({
      appName = "image",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Image',
      description = "???"
    })

    registerApp({
      appName = "music",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Music',
      description = "???"
    })

    registerApp({
      appName = "os",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_OS',
      description = "???"
    })

    registerApp({
      appName = "sound",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Sound',
      description = "???"
    })

    registerApp({
      appName = "system",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_System',
      description = "???"
    })

    registerApp({
      appName = "text",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Text',
      description = "???"
    })

    registerApp({
      appName = "tip",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Tip',
      description = "???"
    })

    registerApp({
      appName = "ttfont",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_TTFont',
      description = "???"
    })

    registerApp({
      appName = "video",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Video',
      description = "???"
    })

    registerApp({
      appName = "webdoc",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_File_Webdoc',
      description = "???"
    })

    registerApp({
      appName = "folder_channel",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_Folder_Channel',
      description = "???"
    })

    registerApp({
      appName = "folder",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_Folder',
      description = "???"
    })

    registerApp({
      appName = "program",
      iconPrototype = require 'src.applications.dummy.system.plugins.base.files.Icon_Program',
      description = "???"
    })


    for i, package in pairs(appPackages) do
      system.apps:registerApp(package)
      if package.iconPrototype.loadStatics then
        package.iconPrototype:loadStatics(system)
      end
      print("Registered app: " .. package.appName)
    end

    
    
    
  else
    print("Warning: Could not register antivirus plugin, Apps or Processes system not available")
  end
  
  return true
end

function Plugin:unload()
  if self.system and self.system.apps then
    -- Remove from installable apps if it's still there
    if self.system.apps.installableApps and self.system.apps.installableApps["antivirus2"] then
      self.system.apps.installableApps["antivirus2"] = nil
      print("Removed Antivirus from installable apps")
    end
    
    -- If it was installed, remove it
    if self.system.apps["antivirus2"] then
      self.system.apps:uninstall("antivirus2")
      print("Uninstalled Antivirus2")
    end
    
    print("Antivirus plugin unloaded")
  end
  
  return true
end

function Plugin:update(dt)
  -- Any periodic updates can go here
end

return Plugin

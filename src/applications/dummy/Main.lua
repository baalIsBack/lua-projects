local Super = require 'engine.Scene'
local Self = Super:clone("Main")

function folderreq(base_path, enable_prints)
  local loaded = {}
  
  local function scan_dir(dir, req_path, current_table)
    if enable_prints then print("Scanning dir:", dir) end  -- Debug print
    local files = love.filesystem.getDirectoryItems(dir)
    for _, file in ipairs(files) do
      local file_path = dir .. "/" .. file
      local info = love.filesystem.getInfo(file_path)
      
      if info then  -- Check if file exists
        if enable_prints then print("Found:", file_path, info.type) end  -- Debug print
        if info.type == "file" and file:match("%.lua$") then
          local name = file:gsub("%.lua$", "")
          local req = req_path .. "." .. name
          if enable_prints then print("Requiring:", req) end  -- Debug print
          current_table[name] = require(req)
        elseif info.type == "directory" then
          current_table[file] = {}
          scan_dir(file_path, req_path .. "." .. file, current_table[file])
        end
      end
    end
  end
  
  -- Adjust path for love.filesystem
  local dir = "applications/" .. base_path
  scan_dir(dir, "applications." .. base_path, loaded)
  return loaded
end

function flatten(t)
  local flat = {}
  local function _flatten(tab)
    for _, v in pairs(tab) do
      if type(v) == "table" then
        _flatten(v)
      else
        table.insert(flat, v)
      end
    end
  end
  _flatten(t)
  return flat
end

function left_pad(str, length, char)
  char = char or " "  -- Default padding character is a space
  local pad_size = length - #str
  if pad_size > 0 then
    return string.rep(char, pad_size) .. str
  else
    return str
  end
end

function right_pad(str, length, char)
  char = char or " "  -- Default padding character is a space
  local pad_size = length - #str
  if pad_size > 0 then
    return str .. string.rep(char, pad_size)
  else
    return str
  end
end

function mid_pad(str, length, char)
  char = char or " "  -- Default padding character is a space
  local pad_size = length - #str
  if pad_size > 0 then
    local pad_size1 = math.floor(pad_size/2)
    local pad_size2 = pad_size - pad_size1
    return string.rep(char, pad_size1) .. str .. string.rep(char, pad_size2)
  else
    return str
  end
end

Icon_Calc = require 'applications.dummy.apps.Icon_Calc'
Icon_Contacts = require 'applications.dummy.apps.Icon_Contacts'
Icon_Debug = require 'applications.dummy.apps.Icon_Debug'
Icon_Editor = require 'applications.dummy.apps.Icon_Editor'
Icon_FileManager = require 'applications.dummy.apps.Icon_FileManager'
Icon_FileServer = require 'applications.dummy.apps.Icon_FileServer'
Icon_Mail = require 'applications.dummy.apps.Icon_Mail'
Icon_Network = require 'applications.dummy.apps.Icon_Network'
Icon_Patcher = require 'applications.dummy.apps.Icon_Patcher'
Icon_Processes = require 'applications.dummy.apps.Icon_Processes'
Icon_Ressources = require 'applications.dummy.apps.Icon_Ressources'
Icon_SoftwareCenter = require 'applications.dummy.apps.Icon_SoftwareCenter'
Icon_Stat = require 'applications.dummy.apps.Icon_Stat'
Icon_Terminal = require 'applications.dummy.apps.Icon_Terminal'
Icon_Battle = require 'applications.dummy.apps.Icon_Battle'

ContactsWindow = require 'applications.dummy.gui.windows.ContactsWindow'
DebugWindow = require 'applications.dummy.gui.windows.DebugWindow'
EditorWindow = require 'applications.dummy.gui.windows.EditorWindow'
FileManagerWindow = require 'applications.dummy.gui.windows.FileManagerWindow'
FileServerWindow = require 'applications.dummy.gui.windows.FileServerWindow'
MailWindow = require 'applications.dummy.gui.windows.MailWindow'
NetworkWindow = require 'applications.dummy.gui.windows.NetworkWindow'
PatcherWindow = require 'applications.dummy.gui.windows.PatcherWindow'
ProcessesWindow = require 'applications.dummy.gui.windows.ProcessesWindow'
RessourcesWindow = require 'applications.dummy.gui.windows.RessourcesWindow'
StatWindow = require 'applications.dummy.gui.windows.StatWindow'
TerminalWindow = require 'applications.dummy.gui.windows.TerminalWindow'
AntivirusWindow = require 'applications.dummy.gui.windows.AntivirusWindow'
BattleWindow = require 'applications.dummy.gui.windows.BattleWindow'

Icon_Antivirus = require 'applications.dummy.apps.Icon_Antivirus'

function Self:init()
  Super.init(self)


  FONTS = {}
  FONTS["mono16"] = love.graphics.newImageFont("submodules/lua-projects-private/font/jasoco/font1.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 :-!.,\"?>_#<{}()[]\\+/;%&='*", 0)
  FONTS["mono16"]:setLineHeight(1)

  FONTS["dialog"] = love.graphics.newImageFont("submodules/lua-projects-private/font/jasoco/font2.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`_*#=[]'{}", 1)
  FONTS["dialog"]:setLineHeight(.6)

  FONTS["tiny"] = love.graphics.newImageFont("submodules/lua-projects-private/font/jasoco/font3.png", " 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.-,!:()[]{}<>", 1)
  FONTS["tiny"]:setLineHeight(.8)

  FONTS["1980"] = love.graphics.newFont("submodules/lua-projects-private/font/1980/1980v23P03.ttf", 20)

  for i, v in ipairs(FONTS) do
    v:setFilter("nearest", "nearest")
  end

  math.randomseed(os.time())
  FONT_DEFAULT = love.graphics.newFont("submodules/lua-projects-private/font/spacecargo.ttf", 10)--love.graphics.newFont("submodules/lua-projects-private/font/Weiholmir Standard/Weiholmir_regular.ttf", 7*2)
  FONT_DEFAULT = love.graphics.newFont("submodules/lua-projects-private/font/superpyxel/superpyxelreads.ttf", 10)
  FONT_DEFAULT = FONTS["mono16"]
  FONT = love.graphics.newFont(16)--"Hyperdrift-private/assets/font/Weiholmir Standard/Weiholmir_regular.ttf"
  FONT:setFilter("nearest", "nearest")

  self.points = 0
  

  require 'engine.Screen':setScale(1, 1)

  
  self.desktop = require 'applications.dummy.Desktop':new{main=self}
  self.contents:insert(self.desktop)

  MAX_Z = 0

  local button, button_text

  self.systems = require 'applications.dummy.Systems':new(self)


  self.timedmanager = require 'engine.TimedManager':new()
  self.gamestate = require 'applications.dummy.Savemanager':new{main=self}
  
  self.currency1 = 0
  self.values = require 'applications.dummy.system.Values':new{main=self}
  self.flags = require 'applications.dummy.system.Flags':new{main=self}


  --self.contacts = require 'applications.dummy.system.Contacts':new{main=self}
  self.mails = require 'applications.dummy.system.Mails':new{main=self}
  self.notes = require 'applications.dummy.system.Notes':new{main=self}
  self.terminal = require 'applications.dummy.system.Terminal':new{main=self}
  self.filegenerator = require 'applications.dummy.system.FileGenerator':new{main=self}
  self.fileserver = require 'applications.dummy.system.FileServer':new{main=self}
  self.processes = require 'applications.dummy.system.Processes':new{main=self}
  self.apps = require 'applications.dummy.system.Apps':new{main=self}
  self.antivirus = require 'applications.dummy.system.Antivirus':new{main=self}
  self.patcher = require 'applications.dummy.system.Patcher':new{main=self}
  

  
  love.graphics.setFont(FONT_DEFAULT)




  self.gamestate:finalize()
  --self.processes:finalizeWindows()


  self.values:set("ram_usage_current", 0)

  self:insert(Icon_Mail:new{main=self, x=32, y=32})
  self:insert(Icon_FileServer:new{main=self, x=32*4, y=32})
  self:insert(Icon_FileManager:new{main=self, x=32*8, y=32*4})
  self:insert(Icon_FileManager:new{main=self, x=32*8, y=32})
  self:insert(Icon_Antivirus:new{main=self, x=32*3, y=32*4})
  self:insert(Icon_Processes:new{main=self, x=32*5, y=32*5})
  self:insert(Icon_Battle:new{main=self, x=32*8, y=32*8})
  

  return self
end

function Self:draw()
  self.contents:callall("draw")

  require 'engine.Mouse':draw()

end

function Self:update(dt)
  
  -- Update plugins
  if self.pluginManager then
    self.pluginManager:update(dt)
  end
  
  self.contents:callall("update", dt)
  self.timedmanager:update(dt)
  --self.gamestate:update(dt)
  self.mails:update(dt)
  --self.text_points:setText("Points: " .. self.points)
end

function Self:keypressed(key, scancode, isrepeat)
  self.contents:callall("keypressed", key, scancode, isrepeat)
end

function Self:textinput(text)
  self.contents:callall("textinput", text)
end

function Self:mousemoved( x, y, dx, dy, istouch )
  require 'engine.Mouse':mousemoved(x, y, dx, dy, istouch)
  self.contents:callall("mousemoved", x, y, dx, dy, istouch)
end

function Self:insert(node)
  self.desktop.contents:insert(node)
  node.main = self
end

function Self:remove(node)
  self.desktop.contents:remove(node)
end

function Self:getCurrentRam()
  return 1
end

function Self:getMaxRam()
  return 4
end

return Self



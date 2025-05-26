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

  MAX_Z = 0

  local button, button_text

  self.timedmanager = require 'engine.TimedManager':new()
  self.gamestate = require 'applications.dummy.Savemanager':new{main=self}
  
  self.currency1 = 0
  self.values = require 'applications.dummy.system.Values':new{main=self}
  self.flags = require 'applications.dummy.system.Flags':new{main=self}


  self.contacts = require 'applications.dummy.system.Contacts':new{main=self}
  self.mails = require 'applications.dummy.system.Mails':new{main=self}
  self.notes = require 'applications.dummy.system.Notes':new{main=self}
  self.terminal = require 'applications.dummy.system.Terminal':new{main=self}
  self.filegenerator = require 'applications.dummy.system.FileGenerator':new{main=self}
  self.fileserver = require 'applications.dummy.system.FileServer':new{main=self}
  self.filemanager = require 'applications.dummy.system.FileManager':new{main=self}
  self.processes = require 'applications.dummy.system.Processes':new{main=self}
  self.apps = require 'applications.dummy.system.Apps':new{main=self}
  self.antivirus = require 'applications.dummy.system.Antivirus':new{main=self}
  self.patcher = require 'applications.dummy.system.Patcher':new{main=self}
  

  self.apps:loadAppIcons()
  --self:install_calc()

  -- Create plugin manager
  self.pluginManager = require 'applications.dummy.system.PluginManager':new{main=self}
  
  -- Discover and load plugins
  self.pluginManager:loadDiscoveredPlugins()
  
  -- Load and enable all plugins
  self.pluginManager:loadAllPlugins()
  self.pluginManager:enableAllPlugins()

  love.graphics.setFont(FONT_DEFAULT)


  local osbar = require 'applications.dummy.gui.elements.OSBar':new{y = 480-16+4, color = {0/255, 1/255, 129/255}, main=self,}
  self:insert(osbar)

  self.gamestate:finalize()
  --self.processes:finalizeWindows()


  self.values:set("ram_usage_current", 0)
  
  

  return self
end

function Self:draw()
  table.sort(self.contents.content_list, function(a, b)
    if a.alwaysOnTop and not b.alwaysOnTop then
        return false
    elseif not a.alwaysOnTop and b.alwaysOnTop then
        return true
    else
        return a.z < b.z
    end
  end)
  --sort self.content.content_list by z and ensure that if any node has the alwaysOnTop flag set it will be first
  


  love.graphics.setBackgroundColor(32/255, 140/255, 112/255)
  self.contents:callall("draw")
  local x_dist = 32
  local y_dist = 32
  for x = 0, 640-x_dist, x_dist do
    --love.graphics.line(x, 0, x, 480)
  end
  for y = 0, 480-y_dist, y_dist do
    --love.graphics.line(0, y, 640, y)
  end

  require 'engine.Mouse':draw()

end

function Self:update(dt)
  table.sort(self.contents.content_list, function(a, b)
    if a.alwaysOnTop and not b.alwaysOnTop then
      return false
    elseif not a.alwaysOnTop and b.alwaysOnTop then
      return true
    else
      return a.z < b.z
    end
  end)
  
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
  self.contents:insert(node)
  node.main = self
  if node:type() ~= node:super():type() then
    ddd()
  end
end

function Self:remove(node)
  self.contents:remove(node)
end

function Self:getCurrentRam()
  return 1
end

function Self:getMaxRam()
  return 4
end

return Self



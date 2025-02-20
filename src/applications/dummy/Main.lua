local Super = require 'engine.Scene'
local Self = Super:clone("Main")


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
  self.files = require 'applications.dummy.system.Files':new{main=self}
  self.contacts = require 'applications.dummy.system.Contacts':new{main=self}
  self.mails = require 'applications.dummy.system.Mails':new{main=self}
  self.notes = require 'applications.dummy.system.Notes':new{main=self}
  self.terminal = require 'applications.dummy.system.Terminal':new{main=self}
  self.filemanager = require 'applications.dummy.system.FileManager':new{main=self}
  self.processes = require 'applications.dummy.system.Processes':new{main=self}
  self.apps = require 'applications.dummy.system.Apps':new{main=self}
  self.antivirus = require 'applications.dummy.system.Antivirus':new{main=self}
  
  --self:install_calc()




  love.graphics.setFont(FONT_DEFAULT)



  local osbar = require 'applications.dummy.gui.elements.OSBar':new{y = 480-16+4, color = {0/255, 1/255, 129/255}, main=self,}
  self:insert(osbar)
  self.gamestate:finalize()
  self.processes:finalizeWindows()


  print(self.values:get("ram_current_used"))
  self.values:set("ram_current_used", 0)
  

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

function Self:insert(node)
  self.contents:insert(node)
  node.main = self
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


function Self:install_calc()
  self:insert(self.app_calc)

  
  self:insert(icon)
  self.app_calc.desktop_icon = icon
end

function Self:uninstall_calc()
  self:remove(self.app_calc)
  self:remove(self.app_calc.desktop_icon)
  self.app_calc = nil
end

function Self:install_stat()
  self:insert(self.app_stat)


  self:insert(icon)
  self.app_stat.desktop_icon = icon
end

function Self:uninstall_stat()
  self:remove(self.app_stat)
  self:remove(self.app_stat.desktop_icon)
  self.app_stat = nil
end

function Self:install_mail()
  self:insert(self.app_mail)


  self:insert(icon)
  self.app_mail.desktop_icon = icon
end

function Self:uninstall_mail()
  self:remove(self.app_mail)
  self:remove(self.app_mail.desktop_icon)
  self.app_mail = nil
end

function Self:install_terminal()
  self:insert(self.app_terminal)
  self.terminal.window = self.app_terminal


  self:insert(icon)
  self.app_terminal.desktop_icon = icon
end

function Self:uninstall_terminal()
  self:remove(self.app_terminal)
  self:remove(self.app_terminal.desktop_icon)
  self.app_terminal = nil
end


function Self:install_editor()
  self:insert(self.app_editor)


  self:insert(icon)
  self.app_editor.desktop_icon = icon
end

function Self:uninstall_editor()
  self:remove(self.app_editor)
  self:remove(self.app_editor.desktop_icon)
  self.app_editor = nil
end

function Self:install_files()
  self:insert(self.app_files)


  self:insert(icon)
  self.app_files.desktop_icon = icon
end

function Self:uninstall_files()
  self:remove(self.app_files)
  self:remove(self.app_files.desktop_icon)
  self.app_files = nil
end

function Self:install_processes()
  self:insert(self.app_processes)


  self:insert(icon)
  self.app_processes.desktop_icon = icon
end

function Self:uninstall_processes()
  self:remove(self.app_processes)
  self:remove(self.app_processes.desktop_icon)
  self.app_processes = nil
end

function Self:install_ressources()
  self:insert(self.app_ressources)


  self:insert(icon)
  self.app_ressources.desktop_icon = icon
end

function Self:uninstall_ressources()
  self:remove(self.app_ressources)
  self:remove(self.app_ressources.desktop_icon)
  self.app_ressources = nil
end

return Self



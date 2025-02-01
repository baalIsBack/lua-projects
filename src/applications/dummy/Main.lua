local Super = require 'engine.Scene'
local Self = Super:clone("Main")


function Self:init()
  Super.init(self)

  self.points = 0

  require 'engine.Screen':setScale(1, 1)

  MAX_Z = 0

  local button, button_text

  self.timedmanager = require 'engine.TimedManager':new()
  self.gamestate = require 'applications.dummy.Savemanager':new{main=self}
  
  self.currency1 = 0
  self.mails = require 'applications.dummy.Mails':new{main=self}
  self.notes = require 'applications.dummy.Notes':new{main=self}
  self.terminal = require 'applications.dummy.Terminal':new{main=self}
  

  
  --self:install_calc()




  local FONT_DEFAULT = love.graphics.newFont("submodules/lua-projects-private/font/spacecargo.ttf", 10)--love.graphics.newFont("submodules/lua-projects-private/font/Weiholmir Standard/Weiholmir_regular.ttf", 7*2)
  love.graphics.setFont(FONT_DEFAULT)



  local osbar = require 'src.applications.dummy.OSBar':new{y = 480-16+4, color = {0/255, 1/255, 129/255}, main=self,}
  self:insert(osbar)
  self.gamestate:finalize()
  

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
  self.app_calc = require 'applications.dummy.CalcWindow':new{
    main = self,
    x = 300,
    y = 300,
    visibleAndActive = false
  }
  self:insert(self.app_calc)

  local icon = require 'applications.dummy.DesktopIcon':new{
    x = 32 + 0*(64),
    y = 32 + 6*(64),
    w = 64,
    h = 64,
    targetApp = self.app_calc,
    name = "Calc",
    --img = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons/w98_console_prompt.png"),
  }
  self:insert(icon)
  self.app_calc.desktop_icon = icon
end

function Self:uninstall_calc()
  self:remove(self.app_calc)
  self:remove(self.app_calc.desktop_icon)
  self.app_calc = nil
end

function Self:install_mail()
  self.app_mail = require 'applications.dummy.MailWindow':new{
    main = self,
    x = 200,
    y = 200,
    visibleAndActive = false,
    mails = self.mails,
  }
  self:insert(self.app_mail)

  local icon = require 'applications.dummy.DesktopIcon':new{
    x = 32 + 0*(64),
    y = 32 + 0*(64),
    w = 64, h = 64,
    targetApp = self.app_mail,
    name = "Mail",
    img = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons/w98_computer_explorer.png"),
  }
  self:insert(icon)
  self.app_mail.desktop_icon = icon
end

function Self:uninstall_mail()
  self:remove(self.app_mail)
  self:remove(self.app_mail.desktop_icon)
  self.app_mail = nil
end

function Self:install_terminal()
  self.app_terminal = require 'applications.dummy.TerminalWindow':new{
    main = self,
    terminal = self.terminal,
    x = 250,
    y = 250,
    visibleAndActive = false
  }
  self:insert(self.app_terminal)
  
  self.terminal.window = self.app_terminal

  local icon = require 'applications.dummy.DesktopIcon':new{
    x = 32 + 0*(64),
    y = 32 + 1*(64),
    w = 64,
    h = 64,
    targetApp = self.app_terminal,
    name = "Terminal",
    img = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons/w98_console_prompt.png"),
  }
  self:insert(icon)
  self.app_terminal.desktop_icon = icon
end

function Self:uninstall_terminal()
  self:remove(self.app_terminal)
  self:remove(self.app_terminal.desktop_icon)
  self.app_terminal = nil
end


function Self:install_editor()
  self.app_editor = require 'applications.dummy.TODO_EditorWindow':new{
    main = self,
    x = 250,
    y = 250,
    visibleAndActive = false
  }
  self:insert(self.app_editor)

  local icon = require 'applications.dummy.DesktopIcon':new{
    x = 32 + 0*(64),
    y = 32 + 2*(64),
    w = 64,
    h = 64,
    targetApp = self.app_editor,
    name = "Editor",
    img = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons/w98_computer_explorer.png"),
  }
  self:insert(icon)
  self.app_editor.desktop_icon = icon
end

function Self:uninstall_editor()
  self:remove(self.app_editor)
  self:remove(self.app_editor.desktop_icon)
  self.app_editor = nil
end

function Self:install_files()
  self.app_files = require 'applications.dummy.TODO_FileManagerWindow':new{
    main = self,
    x = 250,
    y = 250,
    visibleAndActive = false
  }
  self:insert(self.app_files)

  local icon = require 'applications.dummy.DesktopIcon':new{
    x = 32 + 0*(64),
    y = 32 + 3*(64),
    w = 64,
    h = 64,
    targetApp = self.app_files,
    name = "Files",
    img = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons/w98_computer_explorer.png"),
  }
  self:insert(icon)
  self.app_files.desktop_icon = icon
end

function Self:uninstall_files()
  self:remove(self.app_files)
  self:remove(self.app_files.desktop_icon)
  self.app_files = nil
end

function Self:install_processes()
  self.app_processes = require 'applications.dummy.TODO_ProcessesWindow':new{
    main = self,
    x = 250,
    y = 250,
    visibleAndActive = false
  }
  self:insert(self.app_processes)

  local icon = require 'applications.dummy.DesktopIcon':new{
    x = 32 + 0*(64),--9
    y = 32 + 4*(64),--6
    w = 64,
    h = 64,
    targetApp = self.app_processes,
    name = "Processes",
    img = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons/w98_computer_explorer.png"),
  }
  self:insert(icon)
  self.app_processes.desktop_icon = icon
end

function Self:uninstall_processes()
  self:remove(self.app_processes)
  self:remove(self.app_processes.desktop_icon)
  self.app_processes = nil
end

function Self:install_ressources()
  self.app_ressources = require 'applications.dummy.TODO_ProcessesWindow':new{
    main = self,
    x = 250,
    y = 250,
    visibleAndActive = false,
  }
  self:insert(self.app_ressources)

  local icon = require 'applications.dummy.DesktopIcon':new{
    x = 32 + 0*(64),--9
    y = 32 + 5*(64),--6
    w = 64,
    h = 64,
    targetApp = self.app_ressources,
    name = "Ressources",
    img = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons/w98_computer_explorer.png"),
  }
  self:insert(icon)
  self.app_ressources.desktop_icon = icon
end

function Self:uninstall_ressources()
  self:remove(self.app_ressources)
  self:remove(self.app_ressources.desktop_icon)
  self.app_ressources = nil
end

return Self



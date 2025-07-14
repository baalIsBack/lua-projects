local Super = require 'engine.Scene'
local Self = Super:clone("Main")



Explorer = require 'applications.filefighter.systems.Explorer'


Desktop = require 'applications.filefighter.Desktop'
Icon_Archive = require 'applications.filefighter.icons.Archive'
Icon_Folder = require 'applications.filefighter.icons.Folder'
BaseIcon = require 'src.applications.filefighter.BaseIcon'
OSBar = require 'applications.filefighter.OSBar'
BaseWindow = require 'applications.filefighter.BaseWindow'
ExplorerWindow = require 'applications.filefighter.windows.ExplorerWindow'

Mouse = require 'engine.Mouse'


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

  

  require 'engine.Screen':setScale(1, 1)

    
  love.graphics.setFont(FONT_DEFAULT)

  self.desktop = Desktop:new{main=self,}
  self.windowManager = require 'applications.filefighter.WindowManager':new{main=self,}

  self.explorer = Explorer:new{main=self,}

  self.contents:insert(self.desktop)

  return self
end

function Self:draw()
  self.contents:callall("draw")
  Mouse:draw()

end

function Self:update(dt)
  self.contents:callall("update", dt)
end

function Self:keypressed(key, scancode, isrepeat)
  self.contents:callall("keypressed", key, scancode, isrepeat)
end

function Self:textinput(text)
  self.contents:callall("textinput", text)
end

function Self:mousemoved( x, y, dx, dy, istouch )
  Mouse:mousemoved(x, y, dx, dy, istouch)
  self.contents:callall("mousemoved", x, y, dx, dy, istouch)
end

function Self:mousereleased( x, y, button, istouch, presses )
  self.contents:callall("mousereleased", x, y, button, istouch, presses)
end

return Self



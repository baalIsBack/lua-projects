local Super = require 'engine.Scene'
local Self = Super:clone("Main")

require 'lib.hexgrid'
Tween = require 'lib.tween'

FONTS = {}


function Self:init()
  Super.init(self)

  FONTS["mono16"] = love.graphics.newImageFont("submodules/lua-projects-private/font/jasoco/font1.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 :-!.,\"?>_#<{}()[]\\+/;%&='*", 0)
  FONTS["mono16"]:setLineHeight(1)
  love.graphics.setFont(FONTS["mono16"])

  math.randomseed(os.time())
  --require 'engine.Screen':setScale(1, 1)

  

  self.grid = require 'applications.hex.Grid':new{}
  --self.contents:insert(self.grid)

  
  self.menue = require 'applications.hex.Menue':new{main = self}
  self.contents:insert(self.menue)
  --self.contents:remove(grid)


  

  self.translation_x = 300

  return self
end



function Self:draw()
  self.contents:callall("draw")

  
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

function Self:mousepressed(x, y, button, istouch, presses)
  self.contents:callall("mousepressed", x, y, button, istouch, presses)
end




return Self



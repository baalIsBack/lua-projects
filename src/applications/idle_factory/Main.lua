local Super = require 'engine.Scene'
local Self = Super:clone("Main")


function Self:init()
  Super.init(self)


  math.randomseed(os.time())

  self.grid = require 'applications.idle_factory.TileGrid':new{
    x = 16,
    y = 16,
    width = 18,
    height = 13,
  }
  self:insert(self.grid)

  return self
end

function Self:draw()
  self.contents:callall("draw")
  
  local mx, my = require 'engine.Mouse':getPosition()
  
end

function Self:update(dt)
  local mx, my = require 'engine.Mouse':getPosition()
  
  self.contents:callall("update", dt)
end

function Self:onWindowMoved(x, y, lastWindowX, lastWindowY)
  print("Window moved from", lastWindowX, lastWindowY, "to", x, y)
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



return Self



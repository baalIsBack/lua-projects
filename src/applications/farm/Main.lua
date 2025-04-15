local Super = require 'engine.Scene'
local Self = Super:clone("Main")


function Self:init()
  Super.init(self)


  math.randomseed(os.time())
  require 'engine.Screen':setScale(2, 2)
  require 'engine.Screen':setSize(640/2, 480/2)

  self.grid = require 'applications.farm.TileGrid':new{
    width = 20,
    height = 12,
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



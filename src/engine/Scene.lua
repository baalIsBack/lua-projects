local Super = require 'engine.Prototype'
local Self = Super:clone("Scene")

function Self:init()
  self.hasCallbacks = true
  self.hasContents = true
  Super.init(self)
  
  self.callbacks:declare("enable")
  self.callbacks:declare(":deactivate")


  return self
end

function Self:getContents()
  return self.contents
end

function Self:activate()
  self:setReal(true)
end

function Self:deactivate()
  self:setReal(false)
end

function Self:draw() end
function Self:update(dt) end
function Self:keypressed(key, scancode, isrepeat) end
function Self:textinput(text) end

function Self:insert(obj)
  table.insert(self.contents, obj)
  obj.scene = self
end

function Self:remove(obj)
  if type(obj) == "number" then
    if #self.contents >= obj then
      table.remove(self.contents, obj)
    end
    error()
  end
  for i = #self.contents, 1, -1 do
    if self.contents[i] == obj then
      table.remove(self.contents, i)
      return true
    end
  end
  return false
end

function Self:removeAllDestroyed(obj)
  local gameObject = nil
  for i = #self.contents, 1, -1 do
    gameObject = self.contents[i]
    if gameObject.KILLED == true then
      gameObject.KILLED = -1
      gameObject.callbacks:call("killed", gameObject)
    end
    if gameObject.DEATH == true then
      gameObject.DEATH = -1
      gameObject.DESTROY = true --TODO make destroy contain the destroyer
      gameObject.callbacks:call("death", gameObject)
    end
    if gameObject.DESTROY then
      gameObject.callbacks:call("destroy", gameObject)
    end
    if gameObject.DESTROY then
      table.remove(self.contents, i)
    end
  end
end

return Self

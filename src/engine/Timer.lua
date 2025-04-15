local Super = require 'engine.Prototype'
local Self = Super:clone("Timer")


function Self:init(args)
  self.hasCallbacks = true
  Super.init(self)

  self.time = args.startTime or 0
  self.timeMax = args.timeMax or 1 -- in seconds
  self.loop = (args.loop ~= false and args.loop ~= nil)

  self.running = true

  self.callbacks:declare("onTrigger")

  return self
end

function Self:isDone()
  return self.time >= self.timeMax  
end

function Self:restart()
  self.time = 0
  self.running = true
end

function Self:stop()
  self.running = false
end

function Self:start()
  self.running = true
end

function Self:update(dt)
  if not self.running then
    return
  end

  self.time = self.time + dt
  if self:isDone() then
    self.callbacks:call("onTrigger", {self})
    self.running = false
    if self.loop then
      self.time = 0
      self.running = true
    end
  end  
end

return Self

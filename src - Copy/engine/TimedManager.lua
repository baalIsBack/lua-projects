local Super = require 'engine.Prototype'
local Self = Super:clone("TimedManager")

local cron = require 'lib.cron'

function Self:init()
	Super.init(self)

  self.list = {}
  self.time = 0

	return self
end

function Self:getTime()
  return self.time
end


function Self:update(dt)
  self.time = self.time + dt
  for i, v in ipairs(self.list) do
    if self.time >= v.time_limit then
      v.f(unpack(v.args))
      table.remove(self.list, i)
      i = i - 1
    end
  end
end

function Self:cleanup()
  local index = 1
  while index <= #self.list do
    local j = self.list[index]
    local remainingTime = j.time - j.running
    if remainingTime < 0 then
      table.remove(self.list, index)
    else
      index = index + 1
    end
  end
end

function Self:after(time, f, ...)
  local t = self:getTime()
  local job = {
    start_time = t,
    time_limit = t + time,
    f = f,
    args = {...}
  }
  table.insert(self.list, job)
end


return Self

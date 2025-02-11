local Super = require 'engine.Prototype'
local Self = Super:clone("Values")


function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  Super.init(self)
  
  self.values = {}
  
  

  return self
end

function Self:set(name, value)
  self.values[name] = value
end

function Self:setOnce(name, value)
  if self.values[name] then
    return
  end
  self.values[name] = value
end

function Self:get(name)
  return self.values[name]
end

function Self:serialize()
  local t = self.values
  return t
end

function Self:deserialize(raw)
  self.values = raw
  self:setOnce("employee_id", math.random(45642, 99999))
  self:setOnce("cash", 0)
  local MailDefinitions = require 'applications.dummy.system.MailDefinitions'
  MailDefinitions[2].required_solve_notes = {""..self:get("employee_id"),}
  MailDefinitions[2].expected_reply = "My ID is: "..self:get("employee_id")
  return self
end



return Self
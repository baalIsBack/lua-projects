local Super = require 'engine.Prototype'
local Self = Super:clone("Contact")

function Self:init(args)--mail_prototype_id, id, read, reply)
  self.main = args.main
  self.hasSerialization = true
  Super.init(self, args)
  
  self.prototype_id = -1

  return self
end



function Self:serialize()
  local t = {
    prototype_id = self.prototype_id,
  }
  return t
end

function Self:deserialize(raw_contact)
  self.prototype_id = raw_contact.prototype_id or self.prototype_id
  

  return self
end

function Self:getEmployeeID()
  return require 'applications.dummy.system.ContactDefinitions'[self.prototype_id].employee_id
end

function Self:getName()
  return require 'applications.dummy.system.ContactDefinitions'[self.prototype_id].name
end

function Self:getBirthday()
  return require 'applications.dummy.system.ContactDefinitions'[self.prototype_id].birthday
end

function Self:getAddress()
  return require 'applications.dummy.system.ContactDefinitions'[self.prototype_id].address
end

return Self
local Super = require 'engine.Prototype'
local Self = Super:clone("Values")


function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  self.hasCallbacks = true
  Super.init(self)
  
  self.values = {}
  
  self:setDefaults()

  self.callbacks:declare("onSet")
  self.callbacks:register("onSet", function(selff, name, value)
    if name == "currently_collected_Icon_File_Image" and value > 0 then
      self.main.processes:getProcess("stat"):addNewUniqueStat(require('applications.dummy.gui.elements.Icon_File_Image').IMG, "currently_collected_Icon_File_Image")
    end
    if name == "currently_collected_Icon_File_Document" and value > 0 then
      self.main.processes:getProcess("stat"):addNewUniqueStat(require('applications.dummy.gui.elements.Icon_File_Document').IMG, "currently_collected_Icon_File_Document")
    end
    if name == "currently_collected_Icon_Brick" and value > 0 then
      self.main.processes:getProcess("stat"):addNewUniqueStat(require('applications.dummy.gui.elements.Icon_Brick').IMG, "currently_collected_Icon_Brick")
    end
  end)

  return self
end

function Self:set(name, value)
  if self.values[name] == nil and not self.safe then
    print("Warning: Unknown value "..name)
    asdd()
  end
  self.values[name] = value
  self.callbacks:call("onSet", {self, name, value})
end

function Self:setOnce(name, value)
  if self.values[name] then
    return
  end
  self:set(name, value)
end

function Self:get(name)
  if self.values[name] == nil then
    print("Warning: Value "..name.." not found")
    asdd()
  end
  return self.values[name]
end

function Self:serialize()
  local t = self.values
  return t
end

function Self:setDefaults()
  self.safe = true
  self:setOnce("employee_id", math.random(45642, 99999))
  self:setOnce("cash", 0)
  self:setOnce("currently_collected_Icon_File_Image", 0)
  self:setOnce("currently_collected_Icon_Brick", 0)
  self:setOnce("currently_collected_Icon_File_Document", 0)
  self:setOnce("opened_Icon_File_Image", 0)
  self:setOnce("opened_Icon_Brick", 0)
  self:setOnce("opened_Icon_File_Document", 0)
  
  
  self.safe = false
end

function Self:deserialize(raw)
  self.values = raw

  self:setDefaults()

  local MailDefinitions = require 'applications.dummy.system.MailDefinitions'
  MailDefinitions[2].required_solve_notes = {""..self:get("employee_id"),}
  MailDefinitions[2].expected_reply = "My ID is: "..self:get("employee_id")
  return self
end



return Self
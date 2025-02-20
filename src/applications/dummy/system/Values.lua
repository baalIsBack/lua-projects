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
    if name == "currently_collected_Image" and value > 0 then
      self.main.processes:getProcess("stat"):addNewUniqueStat(require('applications.dummy.gui.elements.Icon_File_Image'), "currently_collected_Image")
    end
    if name == "currently_collected_Document" and value > 0 then
      self.main.processes:getProcess("stat"):addNewUniqueStat(require('applications.dummy.gui.elements.Icon_File_Document'), "currently_collected_Document")
    end
    if name == "currently_collected_Brick" and value > 0 then
      self.main.processes:getProcess("stat"):addNewUniqueStat(require('applications.dummy.gui.elements.Icon_Brick'), "currently_collected_Brick")
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

function Self:exists(name)
  return self.values[name]
end

function Self:get(name)
  if self.values[name] == nil then
    print("Warning: Value "..name.." not found")
    asdd()
  end
  return self.values[name]
end

function Self:inc(name, quant)
  local previous_value = self:get(name)
  self:set(name, previous_value + quant)
end

function Self:serialize()
  local t = self.values
  return t
end

function Self:setDefaults()
  self.safe = true
  self:setOnce("employee_id", math.random(45642, 99999))
  self:setOnce("cash", 0)
  self:setOnce("currently_collected_Image", 0)
  self:setOnce("currently_collected_Brick", 0)
  self:setOnce("currently_collected_Document", 0)
  self:setOnce("currently_collected_Program", 0)
  self:setOnce("opened_Image", 0)
  self:setOnce("opened_Brick", 0)
  self:setOnce("opened_Document", 0)
  self:setOnce("opened_Program", 0)
  self:setOnce("files_icon_quantity", 5)
  self:setOnce("virus_value", 0)--viruses contracted but not noticed
  self:setOnce("virus_found", 0)--viruses found by antivirus
  self:setOnce("virus_finder_speed", 1)--takes val/100 seconds to find a virus
  self:setOnce("mail_send_speed", 1)--takes val/100 seconds to send a mail
  self:setOnce("contact_send_speed", 1)--takes val/100 seconds to send files to contact

  self:setOnce("ram_total_size", 10)
  self:setOnce("rom_total_size", 10)

  self:setOnce("ram_current_used", 0)
  self:setOnce("rom_current_used", 0)

  self:setOnce("install_time_calc", 0.1)
  self:setOnce("rom_usage_calc", 0.1)
  self:setOnce("ram_usage_calc", 0.1)

  self:setOnce("install_time_terminal", 0.1)
  self:setOnce("rom_usage_terminal", 0.1)
  self:setOnce("ram_usage_terminal", 0.1)

  self:setOnce("install_time_mail", 0.1)
  self:setOnce("rom_usage_mail", 0.1)
  self:setOnce("ram_usage_mail", 0.1)

  self:setOnce("install_time_editor", 0.1)
  self:setOnce("rom_usage_editor", 0.1)
  self:setOnce("ram_usage_editor", 0.1)

  self:setOnce("install_time_files", 0.1)
  self:setOnce("rom_usage_files", 0.1)
  self:setOnce("ram_usage_files", 0.1)

  self:setOnce("install_time_processes", 0.1)
  self:setOnce("rom_usage_processes", 0.1)
  self:setOnce("ram_usage_processes", 0.1)

  self:setOnce("install_time_ressources", 0.1)
  self:setOnce("rom_usage_ressources", 0.1)
  self:setOnce("ram_usage_ressources", 0.1)

  self:setOnce("install_time_stat", 0.1)
  self:setOnce("rom_usage_stat", 0.1)
  self:setOnce("ram_usage_stat", 0.1)

  self:setOnce("install_time_contacts", 0.1)
  self:setOnce("rom_usage_contacts", 0.1)
  self:setOnce("ram_usage_contacts", 0.1)
  
  self:setOnce("install_time_antivirus", 0.1)
  self:setOnce("rom_usage_antivirus", 0.1)
  self:setOnce("ram_usage_antivirus", 0.1)



  self:set("ram_current_used", 0) -- since all programs shut down each restart


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

function Self:getVirusFinderSpeed()
  return self:get("virus_finder_speed")/100
end

function Self:getMailSendSpeed()
  return self:get("mail_send_speed")/100
end

function Self:getContactSendSpeed()
  return self:get("contact_send_speed")/100
end



return Self
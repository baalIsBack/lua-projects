local Super = require 'engine.Prototype'
local Self = Super:clone("Values")


function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  self.hasCallbacks = true
  Super.init(self)
  
  self.values = {}

  self.defaults = {}
  
  self:setDefaults()

  self.callbacks:declare("onSet")
  self.callbacks:register("onSet", function(selff, name, value)
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

  self:setOnce("terminal_register_1", math.random(0, 2000000))


  self:setOnce("employee_id", math.random(45642, 99999))
  self:setOnce("cash", 0)
  self:setOnce("files_icon_quantity", 1)
  self:setOnce("virus_value", 0)--viruses contracted but not noticed
  self:setOnce("virus_found", 0)--viruses found by antivirus
  self:set("virus_finder_speed", 10)--takes val/100 seconds to find a virus
  self:set("mail_send_speed", 50)--takes val/100 seconds to send a mail
  self:set("contact_send_speed", 10)--takes val/100 seconds to send files to contact
  self:setOnce("experience", 0)

  self:setOnce("ram_usage_total", 10)
  self:setOnce("rom_usage_total", 10)
  self:setOnce("cycles_usage_total", 0)

  self:setOnce("ram_usage_current", 0)
  self:setOnce("rom_usage_current", 0)
  self:setOnce("cycles_usage_current", 0)

  self:setOnce("install_time_calc", 0.1)
  self:setOnce("rom_usage_calc", 0.1)
  self:setOnce("ram_usage_calc", 0.1)
  self:setOnce("cycles_usage_calc", 0.1)

  self:setOnce("install_time_terminal", 0.1)
  self:setOnce("rom_usage_terminal", 0.1)
  self:setOnce("ram_usage_terminal", 0.1)
  self:setOnce("cycles_usage_terminal", 0.1)

  self:setOnce("install_time_mail", 0.1)
  self:setOnce("rom_usage_mail", 0.1)
  self:setOnce("ram_usage_mail", 0.1)
  self:setOnce("cycles_usage_mail", 0.1)

  self:setOnce("install_time_editor", 0.1)
  self:setOnce("rom_usage_editor", 0.1)
  self:setOnce("ram_usage_editor", 0.1)
  self:setOnce("cycles_usage_editor", 0.1)

  self:setOnce("install_time_fileserver", 0.1)
  self:setOnce("rom_usage_fileserver", 0.1)
  self:setOnce("ram_usage_fileserver", 0.1)
  self:setOnce("cycles_usage_fileserver", 0.1)

  self:setOnce("install_time_filemanager", 0.1)
  self:setOnce("rom_usage_filemanager", 0.1)
  self:setOnce("ram_usage_filemanager", 0.1)
  self:setOnce("cycles_usage_filemanager", 0.1)

  self:setOnce("install_time_processes", 0.1)
  self:setOnce("rom_usage_processes", 0.1)
  self:setOnce("ram_usage_processes", 0.1)
  self:setOnce("cycles_usage_processes", 0.1)

  self:setOnce("install_time_ressources", 0.1)
  self:setOnce("rom_usage_ressources", 0.1)
  self:setOnce("ram_usage_ressources", 0.1)
  self:setOnce("cycles_usage_ressources", 0.1)

  self:setOnce("install_time_stat", 0.1)
  self:setOnce("rom_usage_stat", 0.1)
  self:setOnce("ram_usage_stat", 0.1)
  self:setOnce("cycles_usage_stat", 0.1)

  self:setOnce("install_time_contacts", 0.1)
  self:setOnce("rom_usage_contacts", 0.1)
  self:setOnce("ram_usage_contacts", 0.1)
  self:setOnce("cycles_usage_contacts", 0.1)
  
  self:setOnce("install_time_antivirus", 0.1)
  self:setOnce("rom_usage_antivirus", 0.1)
  self:setOnce("ram_usage_antivirus", 0.1)
  self:setOnce("cycles_usage_antivirus", 0.1)
  
  self:setOnce("install_time_network", 0.1)
  self:setOnce("rom_usage_network", 0.1)
  self:setOnce("ram_usage_network", 0.1)
  self:setOnce("cycles_usage_network", 0.1)
  
  self:setOnce("install_time_patcher", 0.1)
  self:setOnce("rom_usage_patcher", 0.1)
  self:setOnce("ram_usage_patcher", 0.1)
  self:setOnce("cycles_usage_patcher", 0.1)
  
  self:setOnce("install_time_debug", 0)
  self:setOnce("rom_usage_debug", 0)
  self:setOnce("ram_usage_debug", 0)
  self:setOnce("cycles_usage_debug", 0.1)
  
  self:setOnce("install_time_popup", 0.1)
  self:setOnce("rom_usage_popup", 0.1)
  self:setOnce("ram_usage_popup", 0.1)
  self:setOnce("cycles_usage_popup", 0.1)
  
  self:setOnce("install_time_filemanager", 0.1)
  self:setOnce("rom_usage_filemanager", 0.1)
  self:setOnce("ram_usage_filemanager", 0.1)
  self:setOnce("cycles_usage_filemanager", 0.1)

  
  self:setOnce("install_time_battle", 0.1)
  self:setOnce("rom_usage_battle", 0.1)
  self:setOnce("ram_usage_battle", 0.1)
  self:setOnce("cycles_usage_battle", 0.1)



  self:set("ram_usage_current", 0) -- since all programs shut down each restart

  for i, v in ipairs(self.defaults) do
    self:setOnce(v[1], v[2])
  end

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
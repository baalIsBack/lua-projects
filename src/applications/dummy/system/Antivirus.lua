local Super = require 'engine.Prototype'
local Self = Super:clone("Antivirus")




function Self:init(args)
  self.main = args.main
  Super.init(self)
  


  return self
end

function Self:infect(infection_value)
  self.main.values:inc("virus_value", infection_value)
end

function Self:doVirus()
  local virus_value = self.main.values:get("virus_value")

  if virus_value <= 0 then
  elseif virus_value < 5 then
    local rand1 = math.random(1, 2)
    if rand1 == 1 then
      self.main.processes:makePopup({
        title = "Insurance",
        text = "Want insurance?\nVisit us at 'www.insurance.com'.",
        hasOkButton = false,
        h = 56,
      })
    elseif rand1 == 2 then
      self.main.processes:makePopup({
        title = "Pills",
        text = "Want penis enlargement pills?\nVisit us at 'www.cock.com'.",
        hasOkButton = false,
        h = 70,
      })
    end
  else
    self.main.processes:makePopup({
      title = "Virus Alert",
      text = "Your system has been infected by multiple viruses. Please install 'antivirus'.",
      hasOkButton = true,
      h = 100,
    })
  end
end



return Self
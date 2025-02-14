

local default_f = function(mail, main) return true end

local CONTACTS = {}
CONTACTS[1] = {
  employee_id = math.random(500000, 999999),
  name = "REDACTED",
  birthday = "REDACTED",
  address = "REDACTED",
  requirements = {
    ["Icon_Brick"] = 1,
  },
  rewards = {
    ["Icon_File_Document"] = 10,
  },
}



return CONTACTS
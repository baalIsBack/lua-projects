

local default_f = function(mail, main) return true end

local CONTACTS = {}
CONTACTS[1] = {
  employee_id = math.random(500000, 999999),
  name = "REDACTED",
  birthday = "REDACTED",
  address = "REDACTED",
  requirements = {
    [require'applications.dummy.gui.elements.Icon_Brick'] = 1,
  },
  rewards = {
    [require'applications.dummy.gui.elements.Icon_File_Document'] = 10,
  },
}
CONTACTS[2] = {
  employee_id = math.random(500000, 999999),
  name = "REDACTED",
  birthday = "REDACTED",
  address = "REDACTED",
  requirements = {
    [require'applications.dummy.gui.elements.Icon_Brick'] = 2,
  },
  rewards = {
    [require'applications.dummy.gui.elements.Icon_File_Document'] = 22,
  },
}
CONTACTS[3] = {
  employee_id = math.random(500000, 999999),
  name = "REDACTED",
  birthday = "REDACTED",
  address = "REDACTED",
  requirements = {
    [require'applications.dummy.gui.elements.Icon_File_Image'] = 10,
    [require'applications.dummy.gui.elements.Icon_Brick'] = 100,
  },
  rewards = {
    [require'applications.dummy.gui.elements.Icon_File_Image'] = 10,
    [require'applications.dummy.gui.elements.Icon_File_Document'] = 2,
  },
}



return CONTACTS
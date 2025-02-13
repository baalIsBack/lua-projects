local Super = require 'engine.Prototype'
local Self = Super:clone("Contacts")

local SFX_NEW_contact = love.audio.newSource("submodules/lua-projects-private/sfx/Blip_Select4.wav", "static")

--repeatable : n -> after m(<=n) unlock next
--repeatable : inf -> after m unlock next
--once -> unlock next

local function ID(...)
  return ...
end

local CONTACTS = require 'applications.dummy.system.ContactDefinitions'


function Self:init(args)
  self.main = args.main
  self.hasContents = true
  self.hasCallbacks = true
  self.hasSerialization = true
  Super.init(self)

  self.callbacks:declare("onContactAdded")
  self.callbacks:register("onContactAdded", function(contact)
    --SFX_NEW_contact:play()
    self.main.flags:set("contact_unlock_"..contact.prototype_id)--contact_read_1
  end)

  self.contacts = {}
  self.contactsMap = {}

  self.unsent_contacts_ids = {}

  self.contact_timer = 0

  self.chancePerSecond = 1

  return self
end

function Self:serialize()
  local _contacts = {}
  for i, contact in ipairs(self.contacts) do
    table.insert(_contacts, contact:serialize())
  end
  local t = {
    contacts = _contacts,
  }
  return t
end

function Self:deserialize(raw)
--  self.contacts = raw.contacts
  for i, contact in ipairs(raw.contacts or {}) do
    self:addContact(require 'applications.dummy.system.Contact':new({main=self.main}):deserialize(contact))
  end
  return self
end

function Self:canSolve(contact)
  print("cansolve not done")
  return false
end

function Self:update(dt)
  
end

function Self:replycontact(contact, text)
  print("replying to contact", contact, text)
end

function Self:giveReward(contact)
  local current_cash = self.main.values:get("cash")
  local cash_gain = contact:getReward()
  self.main.values:set("cash", current_cash + cash_gain)
end

function Self:triggerUnlock(contact_prototype_id)
  print("undone triggerUnlock", contact_prototype_id)
end

function Self:addContact(contact)
  
  if self.contactsMap[contact.prototype_id] then
    return self.contactsMap[contact.prototype_id]
  end
  table.insert(self.contacts, contact)
  self.contactsMap[contact.prototype_id] = contact


  self.callbacks:call("onContactAdded", {contact})
  return contact
end

function Self:addContactFromID(contact_prototype_id)
  local contact = require 'applications.dummy.system.contact':new({main=self.main})
  contact.prototype_id = contact_prototype_id

  
  self:addContact(contact)
  
  return contact
end



function Self:getContacts()
  return self.contacts
end

return Self
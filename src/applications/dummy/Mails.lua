local Super = require 'engine.Prototype'
local Self = Super:clone("Mails")

local SFX_NEW_MAIL = love.audio.newSource("submodules/lua-projects-private/sfx/Blip_Select4.wav", "static")

--repeatable : n -> after m(<=n) unlock next
--repeatable : inf -> after m unlock next
--once -> unlock next

local function ID(...)
  return ...
end

 MAILS = {}
MAILS[1] = {
  sender = "Company",
  subject = "Welcome!1",
  content = "Dear Worker, \n\nwelcome to the Company! Email 1 \n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+n
  source_quests = {},
--  source_quests_requirement_count = 0,
  target_quests = {2},
  expected_reply = "1",
  onRead = function(mail, main) end,
  onReply = function(mail, main, text) end,
}
MAILS[2] = {
  sender = "Company",
  subject = "Welcome!2",
  content = "Dear Worker, \n\nwelcome to the Company! Email 2 \n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+n
  source_quests = {},
--  source_quests_requirement_count = 0,
  target_quests = {3, 4},
  expected_reply = "2",
  onRead = function(mail, main) end,
  onReply = function(mail, main, text) end,
}
MAILS[3] = {
  sender = "Company",
  subject = "Welcome!3",
  content = "Dear Worker, \n\nwelcome to the Company! Email 3 \n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+n
  source_quests = {2},
--  source_quests_requirement_count = 1,
  target_quests = {5},
  expected_reply = "3",
  onRead = function(mail, main) end,
  onReply = function(mail, main, text) end,
}
MAILS[4] = {
  sender = "Company",
  subject = "Welcome!4",
  content = "Dear Worker, \n\nwelcome to the Company! Email 4 \n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+n
  source_quests = {1, 2},
--  source_quests_requirement_count = 2,
  target_quests = {6},
  expected_reply = "4",
  onRead = function(mail, main) end,
  onReply = function(mail, main, text) end,
}
MAILS[5] = {
  sender = "Company",
  subject = "Welcome!5",
  content = "Dear Worker, \n\nwelcome to the Company! Email 5 \n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+n
  source_quests = {3, 4},
  source_quests_requirement_count = 1,
  target_quests = {6},
  expected_reply = "5",
  onRead = function(mail, main) end,
  onReply = function(mail, main, text) end,
}
MAILS[6] = {
  sender = "Company",
  subject = "Welcome!6",
  content = "Dear Worker, \n\nwelcome to the Company! Email 6 \n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+n
  source_quests = {4, 5},
--  source_quests_requirement_count = 2,
  target_quests = {},
  expected_reply = "6",
  onRead = function(mail, main) end,
  onReply = function(mail, main, text) end,
}


function Self:init(args)
  self.main = args.main
  self.hasContents = true
  self.hasCallbacks = true
  self.hasSerialization = true
  Super.init(self)

  self.id = 1

  self.callbacks:declare("onMailAdded")
  
  self.callbacks:register("onMailAdded", function(mails)
    SFX_NEW_MAIL:play()
  end)

  self.mails = {}
  self.mailsMap = {}

  self.mails_solved = {}

  self.unsent_mails = {}

  self.mail_timer = 0

  self.chancerPerSecond = 1

  return self
end

function Self:serialize()
  local t = {
    mails = self.mails,
    unsent_mails = self.unsent_mails,
  }
  return t
end

function Self:canSolve(mail)
  return self.main.notes:checkNote(mail:getExpectedReply())
end

function Self:deserialize(raw)
--  self.mails = raw.mails
  for i, mail in ipairs(raw.mails) do
    self:addMail(require 'applications.dummy.Mail':new({main=self.main}):deserialize(mail))
  end
  self.unsent_mails = raw.unsent_mails
  return self
end

function Self:update(dt)
  self.mail_timer = self.mail_timer + dt
  if self.mail_timer > 1 then
    local r = math.random(0, self.chancerPerSecond-1)
    if r <= 0 and #self.unsent_mails > 0 then
      self:makeUnsentMail()
    end
    self.mail_timer = 0
  end
end

function Self:makeUnsentMail()
  local r = math.random(1, #self.unsent_mails)
  local mail_id = self.unsent_mails[r]
  if mail_id == nil then
    return
  end
  if self.mailsMap[mail_id] then
    table.remove(self.unsent_mails, r)
    self:makeUnsentMail()
    return
  end
  if not self:isUnlockable(mail_id) then
    return
  end
  table.remove(self.unsent_mails, r)
  self:addMailFromID(mail_id)
end

function Self:replyMail(mail, text)
  mail:setReply(text)
  if not mail.onReply_called then
    mail.onReply_called = true
    mail:onReply(self.main, text)
    self.mails_solved[mail.prototype_id] = true
    self.callbacks:call("onMailReply", {mail, text})
    mail:redeem()
  end
end

function Self:loadFollowMails(mail)
  for _, prototype_id in ipairs(mail:getTargetQuest()) do
    self:triggerUnlock(prototype_id)
  end
end

function Self:isUnlockable(mail_prototype_id)
  local target_mail = MAILS[mail_prototype_id]
  local sum = 0
  for _, id in ipairs(target_mail.source_quests) do
    local source_quest_mail = self.mailsMap[id]
    if (source_quest_mail and source_quest_mail:isRedeemed()) then
      sum = sum + 1
    end
  end
  return (target_mail.source_quests_requirement_count or #target_mail.source_quests) <= sum
end

function Self:triggerUnlock(mail_prototype_id)
  local mail = MAILS[mail_prototype_id]
  table.insert(self.unsent_mails, mail_prototype_id)
end

function Self:readMail(mail)
  mail:setRead(true)
  if not mail.onRead_called then
    mail:onRead(self.main)
    self.callbacks:call("onMailRead", {mail})
    mail.onRead_called = true
  end
end

function Self:addMail(mail)
  
  if self.mailsMap[mail.prototype_id] then
    return self.mailsMap[mail.prototype_id]
  end
  self.contents:insert(mail)
  table.insert(self.mails, mail)
  self.mailsMap[mail.prototype_id] = mail


  self.callbacks:call("onMailAdded", {mail})
  self:loadFollowMails(mail)
  return mail
end

function Self:addMailFromID(mail_prototype_id)
  local mail = require 'applications.dummy.Mail':new({main=self.main})
  mail.prototype_id = mail_prototype_id
  mail.id = self:getID()
  mail.read = false
  mail.reply = false

  
  self:addMail(mail)
  
  return mail
end

function Self:getID()
  local id = self.id
  id = id + 1
  return id
end



function Self:getMails()
  return self.contents:getList()
end

return Self
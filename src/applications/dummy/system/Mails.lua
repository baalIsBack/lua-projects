local Super = require 'engine.Prototype'
local Self = Super:clone("Mails")

local SFX_NEW_MAIL = love.audio.newSource("submodules/lua-projects-private/sfx/Blip_Select4.wav", "static")

--repeatable : n -> after m(<=n) unlock next
--repeatable : inf -> after m unlock next
--once -> unlock next

local function ID(...)
  return ...
end

local MAILS = require 'applications.dummy.system.MailDefinitions'


function Self:init(args)
  self.main = args.main
  self.hasContents = true
  self.hasCallbacks = true
  self.hasSerialization = true
  Super.init(self)

  self.id_counter = 1

  self.callbacks:declare("onMailAdded")
  self.callbacks:declare("onMailRead")
  self.callbacks:register("onMailAdded", function(mail)
    SFX_NEW_MAIL:play()
    self.main.flags:set("mail_unlock_"..mail.prototype_id)--mail_read_1
  end)

  self.callbacks:register("onMailRead", function(mail)
    self.main.flags:set("mail_read_"..mail.prototype_id)--mail_read_1
  end)

  self.mails = {}
  self.mailsMap = {}

  self.mails_solved = {}

  self.unsent_mails_ids = {}

  self.mail_timer = 0

  self.chancePerSecond = 1

  return self
end

function Self:serialize()
  local t = {
    mails = self.mails,
    unsent_mails_ids = self.unsent_mails_ids,
  }
  return t
end

function Self:getRandomUnsolvedMailReply()
  local table_shuffle = require 'lib.shuffle'
  local table_copy = require 'lib.table_copy'
  local t = table_copy(self.mails)
  table_shuffle(t)
  for i, v in ipairs(t) do
    if not self.mails_solved[v.prototype_id] then
      return v:getExpectedReply()
    end
  end
end

function Self:canSolve(mail)
  return self.main.flags:checkList(mail:getRequiredSolveFlags())
  and self.main.notes:checkList(mail:getRequiredSolveNotes())
  and (mail:getRequiredSolveFunction()(mail, self.main))
end

function Self:deserialize(raw)
--  self.mails = raw.mails
  for i, mail in ipairs(raw.mails) do
    self:addMail(require 'applications.dummy.system.Mail':new({main=self.main}):deserialize(mail))
  end
  self.unsent_mails_ids = raw.unsent_mails_ids or raw.unsent_mails
  return self
end

function Self:update(dt)
  self.mail_timer = self.mail_timer + dt
  if self.mail_timer > 1 then
    local r = math.random(0, self.chancePerSecond-1)
    if r <= 0 and #self.unsent_mails_ids > 0 then
      self:makeUnsentMail()
    end
    self.mail_timer = 0
  end
end

function Self:makeUnsentMail()
  local r = math.random(1, #self.unsent_mails_ids)
  local mail_id = self.unsent_mails_ids[r]
  if mail_id == nil then
    return
  end
  --cleanup and then reroll new mail
  if self.mailsMap[mail_id] then
    table.remove(self.unsent_mails_ids, r)
    return self:makeUnsentMail()
  end
  if not self:isUnlockable(mail_id) then
    return
  end
  table.remove(self.unsent_mails_ids, r)
  self:addMailFromID(mail_id)
  self.callbacks:call("onMailReceived", {self.mailsMap[mail_id]})
end

function Self:replyMail(mail, text)
  if not self:canSolve(mail) then
    return
  end
  mail:setReply(text)
  if not mail.onReply_called then
    mail.onReply_called = true
    mail:onReply(self.main, text)
    self.mails_solved[mail.prototype_id] = true
    self.callbacks:call("onMailReply", {mail, text})
    mail:redeem()
    self:giveReward(mail)
  end
end

function Self:giveReward(mail)
  local current_cash = self.main.values:get("cash")
  local cash_gain = mail:getReward()
  self.main.values:set("cash", current_cash + cash_gain)
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
  and (self.main.flags:checkList(target_mail.required_unlock_flags))
end

function Self:triggerUnlock(mail_prototype_id)
  local mail = MAILS[mail_prototype_id]
  table.insert(self.unsent_mails_ids, mail_prototype_id)
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
  local mail = require 'applications.dummy.system.Mail':new({main=self.main})
  mail.prototype_id = mail_prototype_id
  mail.id = self:getID()
  mail.read = false
  mail.reply = false

  
  self:addMail(mail)
  
  return mail
end

function Self:getID()
  local id = self.id_counter
  id = id + 1
  return id
end

function Self:getMail(id)
  return self.mails[id]
end



function Self:getMails()
  return self.contents:getList()
end

return Self
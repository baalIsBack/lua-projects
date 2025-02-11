local Super = require 'engine.Prototype'
local Self = Super:clone("Mail")

function Self:init(args)--mail_prototype_id, id, read, reply)
  self.main = args.main
  self.hasSerialization = true
  Super.init(self, args)
  self.id = -1
  self.prototype_id = -1
  self.read = false
  self.reply = false

  self.progress = 0

  self.onRead_called = false
  self.onReply_called = false

  self.redeems = 0

  return self
end

function Self:getSender()
  return require 'applications.dummy.system.MailDefinitions'[self.prototype_id].sender
end

function Self:getSubject()
  return require 'applications.dummy.system.MailDefinitions'[self.prototype_id].subject
end

function Self:getContent()
  return require 'applications.dummy.system.MailDefinitions'[self.prototype_id].content
end

function Self:getExpectedReply()
  return require 'applications.dummy.system.MailDefinitions'[self.prototype_id].expected_reply
end

function Self:getTargetQuest()
  return require 'applications.dummy.system.MailDefinitions'[self.prototype_id].target_quests
end

function Self:getSourceQuests()
  return require 'applications.dummy.system.MailDefinitions'[self.prototype_id].source_quests
end

function Self:setRead(bool)
  self.read = bool
end

function Self:setReply(str)
  self.read = str
end

function Self:onRead(main)
  require 'applications.dummy.system.MailDefinitions'[self.prototype_id].onRead(self, main)
end

function Self:onReply(main, text)
  require 'applications.dummy.system.MailDefinitions'[self.prototype_id].onReply(self, main, text)
end

function Self:redeem()
  self.redeems = self.redeems + 1
  self.main.mails:loadFollowMails(self)
end

function Self:isRedeemed()
  return self.redeems >= require 'applications.dummy.system.MailDefinitions'[self.prototype_id].redeemable
end

function Self:isRedeemedForNextQuest()
  return self.redeems >= require 'applications.dummy.system.MailDefinitions'[self.prototype_id].redeems_required_for_next_quest
end

function Self:getRequiredSolveFlags()
  return require 'applications.dummy.system.MailDefinitions'[self.prototype_id].required_solve_flags
end

function Self:getRequiredSolveNotes()
  return require 'applications.dummy.system.MailDefinitions'[self.prototype_id].required_solve_notes
end

function Self:getRequiredSolveFunction()
  return require 'applications.dummy.system.MailDefinitions'[self.prototype_id].required_solve_function
end

function Self:getReward()
  return require 'applications.dummy.system.MailDefinitions'[self.prototype_id].reward
end

function Self:serialize()
  local t = {
    id = self.id,
    prototype_id = self.prototype_id,
    read = self.read,
    reply = self.reply,
    progress = self.progress,
    onRead_called = self.onRead_called,
    onReply_called = self.onReply_called,
    redeems = self.redeems,
  }
  return t
end

function Self:deserialize(raw_mail)
  self.id = raw_mail.id or self.id
  self.prototype_id = raw_mail.prototype_id or self.prototype_id
  self.read = raw_mail.read or self.read
  self.reply = raw_mail.reply or self.reply

  self.progress = raw_mail.progress or self.progress

  self.onRead_called = raw_mail.onRead_called or self.onRead_called
  self.onReply_called = raw_mail.onReply_called or self.onReply_called
  self.redeems = raw_mail.redeems or self.redeems
  

  return self
end


return Self
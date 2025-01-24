

function Mail(mail_prototype_id, id, read, reply)
  local self = {}
  self.id = id
  self.prototype_id = mail_prototype_id
  self.read = false or read
  self.reply = false or reply

  self.onRead_called = false
  self.onReply_called = false

  return self
end

function Load_Mail(raw_mail)
  local self = Mail(raw_mail.prototype_id, raw_mail.id, raw_mail.read, raw_mail.reply)
  self.id = raw_mail.id
  self.prototype_id = raw_mail.prototype_id
  self.read = raw_mail.read
  self.reply = raw_mail.reply

  self.onRead_called = raw_mail.onRead_called
  self.onReply_called = raw_mail.onReply_called

  return self
end

function GET_MAIL(mail, index)
  if mail[index] then
    return mail[index]
  else
    if MAILS[mail.prototype_id] then
      return MAILS[mail.prototype_id][index]
    end
  end
  return nil
end

function SET_MAIL(mail, index, value)
  mail[index] = value
end
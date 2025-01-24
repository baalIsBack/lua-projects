local Super = require 'engine.Prototype'
local Self = Super:clone("Mails")

local SFX_NEW_MAIL = love.audio.newSource("submodules/lua-projects-private/sfx/Blip_Select4.wav", "static")





 MAILS = {}
MAILS[1] = {
  sender = "HR",
  subject = "Welcome!",
  content = "Dear Worker, \n\nwelcome to the Company! We are happy to have you on board. By now you should have gotten a mail by our team including some information for you.\n\nBest regards,\nHR",
  onRead = function(mail, main)
    main.gamestate:emit("entry_mail_read", main.timedmanager.time + 5)
    
  end,
  onReply = function(mail, main, text)
    local m = main.gamestate:addMailFromID(4)
    m.reply = ""
  end
}
MAILS[2] = {
  sender = "Company",
  subject = "First Job",
  content = "Dear Worker, \n\nFor your first job you should install the 'Files' program. You can do that by typing 'install files' into the terminal. The files program is used to navigate your system and inspect files.\n\nPlease report back with your Employee ID, which can be found in a document titled 'Employee.txt'.\n\nBest regards,\nHR",
  onRead = function(mail, main)
    --main.mails:makeMail(MAILS[2])
  end,
  onReply = function(mail, main, text)
    if text == "123" then
      local m = main.gamestate:addMailFromID(6)
    else
      local m = main.gamestate:addMailFromID(5)
    end
  end
}
MAILS[3] = {
  sender = "Company",
  subject = "???",
  content = "Dear Worker, \n\nthis is a test mail. If you see this, please contact your local admin or game developer.\n\nBest regards,\nThe Company",
  onRead = function(mail, main)
    --main.timedmanager:after(5, function() main.mails:makeMail(MAILS[2]) end)
  end,
  onReply = function(mail, main, text)
    --main.timedmanager:after(5, function() main.gamestate:addMailFromID(4) end)
  end
}
MAILS[4] = {
  sender = "[System]",
  subject = "ERROR",
  content = "The mail you tried to send could not be delivered. Please check the recipient and content, then try again.",
  onRead = function(mail, main)
    --main.timedmanager:after(5, function() main.mails:makeMail(MAILS[2]) end)
  end,
  onReply = function(mail, main, text)
    --main.timedmanager:after(5, function() main.gamestate:addMailFromID(4) end)
  end
}
MAILS[5] = {
  sender = "Company",
  subject = "First Job",
  content = "Your supplied Employee ID seems to be wrong. Please install the files program by typing 'install files' into the terminal. The files program is used to navigate your system and inspect files.\n\nPlease report back with your Employee ID, which can be found in a document titled 'Employee.txt'.",
  onRead = function(mail, main)
    --main.timedmanager:after(5, function() main.mails:makeMail(MAILS[2]) end)
  end,
  onReply = function(mail, main, text)
    if text == "123" then
      local m = main.gamestate:addMailFromID(6)
    else
      local m = main.gamestate:addMailFromID(5)
    end
  end
}
MAILS[6] = {
  sender = "Company",
  subject = "Good Job",
  content = "Thank you for confirming your Employee ID.",
  onRead = function(mail, main)
    --main.timedmanager:after(5, function() main.mails:makeMail(MAILS[2]) end)
  end,
  onReply = function(mail, main, text)
    
  end
}
function Self:init(args)
  self.main = args.main
  self.hasContents = true
  self.hasCallbacks = true
  Super.init(self)

  self.callbacks:declare("onMailAdded")
  
  self.callbacks:register("onMailAdded", function(mails)
    SFX_NEW_MAIL:play()
  end)



  return self
end

function Self:replyMail(mail, text)
  SET_MAIL(mail, "reply", text)
  if not mail.onReply_called then
    GET_MAIL(mail, "onReply")(mail, self.main, text)
    self.callbacks:call("onMailReply", {mail, text})
    mail.onReply_called = true
  end
end

function Self:readMail(mail)
  SET_MAIL(mail, "read", true)
  if not mail.onRead_called then
    GET_MAIL(mail, "onRead")(mail, self.main)
    self.callbacks:call("onMailRead", {mail})
    mail.onRead_called = true
  end
end

function Self:makeMail(mail)
  self.contents:insert(mail)

  self.callbacks:call("onMailAdded", {mail})
  return mail
end



function Self:getMails()
  return self.contents:getList()
end

return Self
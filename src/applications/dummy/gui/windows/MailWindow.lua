local Super = require 'engine.gui.Window'
local Self = Super:clone("MailWindow")



function Self:init(args)
  args.w = 320
  args.h = 240
  args.title = "Mail"
  Super.init(self, args)


  
  self.openmail = nil

  self.mail_list_width = 80
  self.mail_list = require 'engine.gui.List':new{main=self.main, x = -self.w/2 + self.mail_list_width/2, y = -1+16, w = self.mail_list_width, h = self.h - 32}
  self:insert(self.mail_list)

  self.scroll_y = -40
  self.sending_reply = false

  
  self.main.mails.callbacks:register("onMailAdded", function(mail)
    self:addMailToList(mail)
  end)
  for i, mail in ipairs(self.main.mails:getMails()) do
    self:addMailToList(mail)
  end

  self.stencilFunction = function()
    love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  end


  self.button_up = require 'engine.gui.Button':new{main=self.main, x = -self.w/2 + self.mail_list_width/2, y = -self.h/2 + 8+16, w = self.mail_list_width, h = 16}
  self:insert(self.button_up)
  self.button_up.callbacks:register("onClicked", function() self.mail_list:up() end)
  local arrow_up = require 'engine.gui.Node':new{main=self.main, x = 0, y = 0}
  arrow_up.callbacks:register("onDraw", function(selff)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0,0,0)
    love.graphics.line(-4, 4, 4, 4)
    love.graphics.line(-4, 4, 0, -4)
    love.graphics.line(4, 4, 0, -4)
  end)
  self.button_up:insert(arrow_up)

  self.button_down = require 'engine.gui.Button':new{main=self.main, x = -self.w/2 + self.mail_list_width/2, y = self.h/2 - 8, w = self.mail_list_width, h = 16}
  self:insert(self.button_down)
  self.button_down.callbacks:register("onClicked", function() self.mail_list:down() end)
  local arrow_down = require 'engine.gui.Node':new{main=self.main, x = 0, y = 0}
  arrow_down.callbacks:register("onDraw", function(selff)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0,0,0)
    love.graphics.line(-4, -4, 4, -4)
    love.graphics.line(-4, -4, 0, 4)
    love.graphics.line(4, -4, 0, 4)
  end)
  self.button_down:insert(arrow_down)


  self.reply_field = require 'engine.gui.TextField':new{
    main = self.main,
    x = -16 + ((self.w/2 - 16*3/2 - 16*3/2) + (-self.w/2 + self.mail_list_width/2 +self.mail_list_width/2)),
    y = self.h/2 - 8,
    w = ((self.w/2 - 16*3/2 - 16*3/2) - (-self.w/2 + self.mail_list_width/2 +self.mail_list_width/2)),
    h = 16,
    visibleAndActive = false,
    accepting_input = false,
  }
  self.reply_field.callbacks:register("onSubmit", function(selff, input)
    if self.openmail then
      local input = self.openmail:getExpectedReply()
      self.main.mails:replyMail(self.openmail, input)
      selff.input = input
    end
  end)
  self:insert(self.reply_field)


  self.reply_button = require 'engine.gui.Button':new{main=self.main, x = self.w/2 - 16*3/2, y = self.h/2 - 8 , w=16*3, h=16, text = "Reply", visibleAndActive = false,}
  self.reply_button.callbacks:register("onClicked", function()
    if self.openmail then
      self.sending_reply = true
      self.send_bar:start()
    end
  end)
  self:insert(self.reply_button)





  self.scrollbar = require 'engine.gui.Scrollbar':new{main=self.main, x = self.w/2 - 8, y = 0, h = self.h-32}
  self:insert(self.scrollbar)
  self.scrollbar.visibleAndActive = (self.openmail)
  self.scrollbar.callbacks:register("onUp", function()
    self.scroll_y = self.scroll_y + (10)
  end)
  self.scrollbar.callbacks:register("onDown", function()
    self.scroll_y = self.scroll_y - (10)
  end)

  self.callbacks:register("update", function(selff, dt)
    self.scrollbar.visibleAndActive = (self.openmail)

    self.send_bar.visibleAndActive = self.sending_reply
    
    self.reply_button.visibleAndActive = self.openmail
    self.reply_field.visibleAndActive = self.openmail
    if self.openmail then
      local canReply = self.main.mails:canSolve(self.openmail)
      self.reply_button.enabled = not self.openmail.reply and canReply and not self.sending_reply
      self.reply_field.enabled = not self.openmail.reply and canReply

      self:refreshButtonStates()
    end
  end)


  self.send_bar = require 'engine.gui.ProgressBar':new{
    main=self.main,
    x = -16 + ((self.w/2 - 16*3/2 - 16*3/2) + (-self.w/2 + self.mail_list_width/2 +self.mail_list_width/2)),
    y = self.h/2 - 8,
    w = ((self.w/2 - 16*3/2 - 16*3/2) - (-self.w/2 + self.mail_list_width/2 +self.mail_list_width/2)),
    h = 16,
  }
  self:insert(self.send_bar)
  self.send_bar.callbacks:register("onFilled", function()
    --self.main.contacts:replycontact(self.opencontact)
    self.send_bar:setProgress(0)
    self.sending_reply = false

    local input = self.openmail:getExpectedReply()
    self.reply_field.input = input
    self.reply_field:submit()
    self.openmail.reply = input
  end)

  return self
end

function Self:addMailToList(mail)
  local b = require 'engine.gui.Button':new{main=self.main, x = 0, y = 0, w = self.mail_list_width, h =32}
  self.mail_list:insert(b, 1)
  
  b.callbacks:register("onClicked", function(b)
    self.openmail = mail
    self.scroll_y = -28
    self.main.mails:readMail(mail)
    
    self.reply_field.input = mail.reply or ""
  end)
  local sender_text = require 'engine.gui.Text':new{main=self.main, x = -37, y = -10, text = "", lineHeight = 1.4, font = FONTS["mono16"]}
  
  local sender_text_color = {0.3, 0.3, 0.3,1}
  local subject_text_color = {0, 0, 0,1}
  b:insert(sender_text)

  local function create_base_button_text()
    return {
      sender_text_color, ""..mail:getSender(),
      subject_text_color, "\n"..mail:getSubject(),
    }
  end
  sender_text:setColoredText(create_base_button_text())
  b.callbacks:register("update", function(selff)
    if self.openmail == mail then
      b:setColor(200/255, 200/255, 200/255)
    else
      b:setColor(192/255, 192/255, 192/255)
    end
    local temporary_text = create_base_button_text()
    if mail.read then
      if mail.onReply_called then--solved
        table.insert(temporary_text, 1, {0, 0, 0})
        table.insert(temporary_text, 2, "")
        sender_text:setColoredText(temporary_text)
      elseif self.main.mails:canSolve(mail) then--unsolved but solvable
        table.insert(temporary_text, 1, {0.7, 1, 0.0})
        table.insert(temporary_text, 2, "*")
        sender_text:setColoredText(temporary_text)
      else--unsolved
        table.insert(temporary_text, 1, {0, 0.5, 1})
        table.insert(temporary_text, 2, "?")
        sender_text:setColoredText(temporary_text)
      end
    else--unread
      table.insert(temporary_text, 1, {1, 0, 0})
      table.insert(temporary_text, 2, "!")
      sender_text:setColoredText(temporary_text)
    end
  end)
  sender_text:setAlignment("left")
end


function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)

  --c0c0c0 192/255
  love.graphics.setColor(192/255, 192/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)

  local previous_font = love.graphics.getFont()
  love.graphics.setFont(FONTS["mono16"])
  if self.openmail then
    --love.graphics.setColor(0.4,0.4,0.4)
    love.graphics.push()
    love.graphics.stencil(self.stencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    love.graphics.translate(0, self.scroll_y)
    local a = 1
    love.graphics.scale(1/a, 1/a)
    local content = {}

    table.insert(content, {0.8, 0.8, 0.8, 1})
    table.insert(content, self.openmail:getSender() .. "\n\n")
    table.insert(content, {0.8, 0.8, 0.8, 1})
    table.insert(content, self.openmail:getSubject() .. "\n\n\n")
    table.insert(content, {0, 0, 0, 1})
    table.insert(content, self.openmail:getContent())
    
    
    
    local wrapLimit = self.w - self.mail_list_width - 4 - self.scrollbar.w/2
    local x = a*(-self.w/2 + self.mail_list_width + 2)
    local y = a*(-self.h/2 + 40 + 16)
    love.graphics.printf(content, x, y, (wrapLimit-16)/a, "left", 0, 1, 1, 0, 0, 0, 0)
    
    love.graphics.setStencilTest()
    love.graphics.pop()
  end
  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

function Self:refreshButtonStates()
  --self.reply_button.enabled = self.opencontact and self.main.contacts:canSolve(self.opencontact) and not self.sending_reply
  
  for i, contact_button in ipairs(self.mail_list.contents:getList()) do
    contact_button.enabled = self.openmail and not self.sending_reply
  end
end

return Self
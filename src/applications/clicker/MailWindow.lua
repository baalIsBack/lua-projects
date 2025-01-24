local Super = require 'engine.gui.Window'
local Self = Super:clone("MailWindow")

local FONT_DEFAULT = love.graphics.newFont("submodules/lua-projects-private/font/spacecargo.ttf", 10)--love.graphics.newFont("submodules/lua-projects-private/font/Weiholmir Standard/Weiholmir_regular.ttf", 7*2)

function Self:init(args)
  args.w = 320
  args.h = 240
  args.title = "Mail"
  Super.init(self, args)

  self.mails = args.mails
  
  self.openmail = nil

  self.mail_list_width = 80
  self.mail_list = require 'engine.gui.List':new{x = -self.w/2 + self.mail_list_width/2, y = -1+16, w = self.mail_list_width, h = self.h - 32}
  self:insert(self.mail_list)

  self.scroll_y = 0

  
  self.mails.callbacks:register("onMailAdded", function(mail)
    self:addMailToList(mail)
  end)
  for i, mail in ipairs(self.mails:getMails()) do
    self:addMailToList(mail)
  end

  self.stencilFunction = function()
    love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  end


  self.button_up = require 'engine.gui.Button':new{x = -self.w/2 + self.mail_list_width/2, y = -self.h/2 + 8+16, w = self.mail_list_width, h = 16}
  self:insert(self.button_up)
  self.button_up.callbacks:register("onClicked", function() self.mail_list:up() end)
  local arrow_up = require 'engine.gui.Node':new{x = 0, y = 0}
  arrow_up.callbacks:register("onDraw", function(selff)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0,0,0)
    love.graphics.line(-4, 4, 4, 4)
    love.graphics.line(-4, 4, 0, -4)
    love.graphics.line(4, 4, 0, -4)
  end)
  self.button_up:insert(arrow_up)

  self.button_down = require 'engine.gui.Button':new{x = -self.w/2 + self.mail_list_width/2, y = self.h/2 - 8, w = self.mail_list_width, h = 16}
  self:insert(self.button_down)
  self.button_down.callbacks:register("onClicked", function() self.mail_list:down() end)
  local arrow_down = require 'engine.gui.Node':new{x = 0, y = 0}
  arrow_down.callbacks:register("onDraw", function(selff)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0,0,0)
    love.graphics.line(-4, -4, 4, -4)
    love.graphics.line(-4, -4, 0, 4)
    love.graphics.line(4, -4, 0, 4)
  end)
  self.button_down:insert(arrow_down)


  self.reply_field = require 'engine.gui.TextField':new{
    x = -16 + ((self.w/2 - 16*3/2 - 16*3/2) + (-self.w/2 + self.mail_list_width/2 +self.mail_list_width/2)),
    y = self.h/2 - 8,
    w = ((self.w/2 - 16*3/2 - 16*3/2) - (-self.w/2 + self.mail_list_width/2 +self.mail_list_width/2)),
    h = 16,
    visibleAndActive = false,
  }
  self.reply_field.callbacks:register("onSubmit", function(selff, input)
    if self.openmail then
      self.main.gamestate:replyMail(self.openmail, input)
      selff.input = input
    end
  end)
  self:insert(self.reply_field)

  self.reply_button = require 'engine.gui.Button':new{x = self.w/2 - 16*3/2, y = self.h/2 - 8 , w=16*3, h=16, visibleAndActive = false,}
  local text = require 'engine.gui.Text':new{x = 0, y = 0, text = "Reply"}
  self.reply_button:insert(text)
  self.reply_button.callbacks:register("onClicked", function()
    if self.openmail then
      self.reply_field:submit()
    end
  end)
  self:insert(self.reply_button)

  self.scrollbar = require 'engine.gui.Scrollbar':new{x = self.w/2 - 8, y = 0, h = self.h-32}
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
  end)

  return self
end

function Self:addMailToList(mail)
  local b = require 'engine.gui.Button':new{x = 0, y = 0, w = self.mail_list_width, h =32}
  self.mail_list:insert(b, 1)
  local unread_marker = require 'engine.gui.Text':new{x = -37, y = -8, mail_id = mail.id, text = "!", color={1, 0, 0}}
  if mail.read then
    unread_marker.text = ""
  end
  
  b.callbacks:register("onClicked", function(b)
    self.openmail = mail
    self.scroll_y = 0
    self.main.gamestate:readMail(mail)
    
    unread_marker.text = ""
    self.reply_field.input = mail.reply or ""
  end)
  b.callbacks:register("update", function(b)
    if self.openmail == mail then
      b:setColor(0.8, 0.8, 0)
    else
      b:setColor(1, 1, 1)
    end
    
    self.reply_button.visibleAndActive = self.openmail
    self.reply_field.visibleAndActive = self.openmail
    if self.openmail then
      local id = self.openmail and self.openmail.id or -1
      
      self.reply_button.enabled = not self.openmail.reply
      self.reply_field.enabled = not self.openmail.reply
      
    end
  end)
  local sender = require 'engine.gui.Text':new{x = -37, y = -8, text = " "..GET_MAIL(mail, "sender"), color={0.4,0.4,0.4}}
  sender:setAlignment("left")
  b:insert(sender)
  unread_marker:setAlignment("left")
  b:insert(unread_marker)
  local subject = require 'engine.gui.Text':new{x = -37, y = 6, text = GET_MAIL(mail, "subject")}
  subject:setAlignment("left")
  b:insert(subject)
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
  love.graphics.setFont(FONT_DEFAULT)
  if self.openmail then
    --love.graphics.setColor(0.4,0.4,0.4)
    love.graphics.push()
    love.graphics.stencil(self.stencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    love.graphics.translate(0, self.scroll_y)
    love.graphics.print(GET_MAIL(self.openmail, "sender"), -self.w/2 + self.mail_list_width + 2, -self.h/2 + 6+16)
    
    love.graphics.setColor(0,0,0)
    love.graphics.print(GET_MAIL(self.openmail, "subject"), -self.w/2 + self.mail_list_width + 2, -self.h/2 + 24+16)
    
    local width, wrappedText = FONT_DEFAULT:getWrap(GET_MAIL(self.openmail, "content"), self.w - self.mail_list_width - 4 - self.scrollbar.w/2)
    --love.graphics.print(self.openmail.content, -self.w/2 + self.mail_list_width + 2, -self.h/2 + 40)
    for i, v in ipairs(wrappedText) do
      love.graphics.print(v, -self.w/2 + self.mail_list_width + 2, -self.h/2 + 40 + i*10+16)
    end
    love.graphics.setStencilTest()
    love.graphics.pop()
  end
  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

return Self
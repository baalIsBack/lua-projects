local Super = require 'engine.gui.Window'
local Self = Super:clone("ContactsWindow")



function Self:init(args)
  args.w = 320
  args.h = 240
  args.title = "Contacts"
  Super.init(self, args)


  self.contacts = self.main.contacts
  
  self.opencontact = nil

  self.contact_list_width = 80
  self.contact_list = require 'engine.gui.List':new{main=self.main, x = -self.w/2 + self.contact_list_width/2, y = -1+16, w = self.contact_list_width, h = self.h - 32}
  self:insert(self.contact_list)

  self.scroll_y = -40

  self.sending_reply = false
  
  
  for i, contact in ipairs(self.main.contacts:getContacts()) do
    self:addContactToList(contact)
  end

  self.main.contacts.callbacks:register("onContactAdded", function(contact)
    self:addContactToList(contact)
  end)
  

  self.stencilFunction = function()
    love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  end


  self.button_up = require 'engine.gui.Button':new{main=self.main, x = -self.w/2 + self.contact_list_width/2, y = -self.h/2 + 8+16, w = self.contact_list_width, h = 16}
  self:insert(self.button_up)
  self.button_up.callbacks:register("onClicked", function() self.contact_list:up() end)
  local arrow_up = require 'engine.gui.Node':new{main=self.main, x = 0, y = 0}
  arrow_up.callbacks:register("onDraw", function(selff)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0,0,0)
    love.graphics.line(-4, 4, 4, 4)
    love.graphics.line(-4, 4, 0, -4)
    love.graphics.line(4, 4, 0, -4)
  end)
  self.button_up:insert(arrow_up)

  self.button_down = require 'engine.gui.Button':new{main=self.main, x = -self.w/2 + self.contact_list_width/2, y = self.h/2 - 8, w = self.contact_list_width, h = 16}
  self:insert(self.button_down)
  self.button_down.callbacks:register("onClicked", function()
    self.contact_list:down()
      
  end)
  local arrow_down = require 'engine.gui.Node':new{main=self.main, x = 0, y = 0}
  arrow_down.callbacks:register("onDraw", function(selff)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0,0,0)
    love.graphics.line(-4, -4, 4, -4)
    love.graphics.line(-4, -4, 0, 4)
    love.graphics.line(4, -4, 0, 4)
  end)
  self.button_down:insert(arrow_down)


  self.reply_button = require 'engine.gui.Button':new{main=self.main, x = self.w/2 - 16*3/2, y = self.h/2 - 8 , w=16*3, h=16, text = "Reply", visibleAndActive = false,}
  self.reply_button.callbacks:register("onClicked", function()
    if self.opencontact then
      self.sending_reply = true
      self.send_bar:start()
    end
  end)
  self:insert(self.reply_button)

  self.send_bar = require 'engine.gui.ProgressBar':new{
    main=self.main,
    x = -16 + ((self.w/2 - 16*3/2 - 16*3/2) + (-self.w/2 + self.contact_list_width/2 +self.contact_list_width/2)),
    y = self.h/2 - 8,
    w = ((self.w/2 - 16*3/2 - 16*3/2) - (-self.w/2 + self.contact_list_width/2 +self.contact_list_width/2)),
    h = 16,
  }
  self:insert(self.send_bar)
  self.send_bar.callbacks:register("onFilled", function()
    self.main.contacts:replycontact(self.opencontact)
    self.send_bar:setProgress(0)
    self.sending_reply = false
  end)




  self.scrollbar = require 'engine.gui.Scrollbar':new{main=self.main, x = self.w/2 - 8, y = 0, h = self.h-32}
  self:insert(self.scrollbar)
  self.scrollbar.visibleAndActive = (self.opencontact)
  self.scrollbar.callbacks:register("onUp", function()
    self.scroll_y = self.scroll_y + 10
  end)
  self.scrollbar.callbacks:register("onDown", function()
    self.scroll_y = self.scroll_y - 10
  end)

  self.callbacks:register("update", function(selff, dt)
    self.send_bar:setSpeed(self.main.values:getContactSendSpeed())


    self.scrollbar.visibleAndActive = self.opencontact
    self.reply_button.visibleAndActive = self.opencontact
    self.send_bar.visibleAndActive = self.opencontact
    if self.opencontact then
      self:refreshButtonStates()
    end
  end)

  return self
end

function Self:addContactToList(contact)
  local b = require 'engine.gui.Button':new{main=self.main, x = 0, y = 0, w = self.contact_list_width, h =32}
  self.contact_list:insert(b, 1)
  
  b.callbacks:register("onClicked", function(b)
    self.opencontact = contact
    self.scroll_y = -28
  end)
  local sender_text = require 'engine.gui.Text':new{main=self.main, x = -37, y = -10, text = "", lineHeight = 1.4, font = FONTS["mono16"]}
  
  local sender_text_color = {0.3, 0.3, 0.3, 1}
  b:insert(sender_text)

  
  sender_text:setColoredText({
    sender_text_color, "Employee: \n"..contact:getEmployeeID(),
  })
  sender_text:setAlignment("left")
  b.callbacks:register("update", function(selff)
    if self.opencontact == contact then
      b:setColor(200/255, 200/255, 200/255)
    else
      b:setColor(192/255, 192/255, 192/255)
    end
  end)
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
  if self.opencontact then
    --love.graphics.setColor(0.4,0.4,0.4)
    love.graphics.push()
    love.graphics.stencil(self.stencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    love.graphics.translate(0, self.scroll_y)
    local a = 1
    love.graphics.scale(1/a, 1/a)
    
    
    local wrapLimit = self.w - self.contact_list_width - 4 - self.scrollbar.w/2
    local x = a*(-self.w/2 + self.contact_list_width + 2)
    local y = a*(-self.h/2 + 40 + 16)


    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf("Requires:", x, y, (wrapLimit-16)/a, "left", 0, 1, 1, 0, 0, 0, 0)
    y = y + 16
    for obj, count in pairs(self.opencontact:getRequirements()) do
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(obj.IMG, x, y)
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.printf(" x " .. count, x + 32, y + 16, (wrapLimit-16)/a, "left", 0, 1, 1, 0, 0, 0, 0)
      y = y + 32
    end

    y = y + 32

    love.graphics.printf("Rewards:", x, y, (wrapLimit-16)/a, "left", 0, 1, 1, 0, 0, 0, 0)
    y = y + 16
    for obj, count in pairs(self.opencontact:getRewards()) do
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(obj.IMG, x, y)
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.printf(" x " .. count, x + 32, y + 16, (wrapLimit-16)/a, "left", 0, 1, 1, 0, 0, 0, 0)
      y = y + 32
    end


    
    love.graphics.setStencilTest()
    love.graphics.pop()
  end
  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

function Self:refreshButtonStates()
  self.reply_button.enabled = self.opencontact and self.main.contacts:canSolve(self.opencontact) and not self.sending_reply
  
  for i, contact_button in ipairs(self.contact_list.contents:getList()) do
    contact_button.enabled = self.opencontact and not self.sending_reply
  end
end

return Self
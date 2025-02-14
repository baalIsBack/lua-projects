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

  
  self.main.contacts.callbacks:register("onContactAdded", function(contact)
    --self:addContactToList(contact)
  end)
  self.main.contacts:addContactFromID(1)
  for i, contact in ipairs(self.main.contacts:getContacts()) do
    self:addContactToList(contact)
  end
  

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
  self.button_down.callbacks:register("onClicked", function() self.contact_list:down() end)
  local arrow_down = require 'engine.gui.Node':new{main=self.main, x = 0, y = 0}
  arrow_down.callbacks:register("onDraw", function(selff)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0,0,0)
    love.graphics.line(-4, -4, 4, -4)
    love.graphics.line(-4, -4, 0, 4)
    love.graphics.line(4, -4, 0, 4)
  end)
  self.button_down:insert(arrow_down)


  self.reply_button = require 'engine.gui.Button':new{main=self.main, x = self.w/2 - 16*3/2, y = self.h/2 - 8 , w=16*3, h=16, visibleAndActive = false,}
  local text = require 'engine.gui.Text':new{main=self.main, x = 0, y = 0, text = "Reply"}
  self.reply_button:insert(text)
  self.reply_button.callbacks:register("onClicked", function()
    if self.opencontact then
      self.main.contacts:replycontact(self.opencontact)
    end
  end)
  self:insert(self.reply_button)

  self.scrollbar = require 'engine.gui.Scrollbar':new{main=self.main, x = self.w/2 - 8, y = 0, h = self.h-32}
  self:insert(self.scrollbar)
  self.scrollbar.visibleAndActive = (self.opencontact)
  self.scrollbar.callbacks:register("onUp", function()
    self.scroll_y = self.scroll_y + (10)
  end)
  self.scrollbar.callbacks:register("onDown", function()
    self.scroll_y = self.scroll_y - (10)
  end)

  self.callbacks:register("update", function(selff, dt)
    self.scrollbar.visibleAndActive = (self.opencontact)
  end)

  return self
end

function Self:addContactToList(contact)
  local b = require 'engine.gui.Button':new{main=self.main, x = 0, y = 0, w = self.contact_list_width, h =32}
  self.contact_list:insert(b, 1)
  
  b.callbacks:register("onClicked", function(b)
    self.opencontact = contact
    self.scroll_y = -28
    
    --self.reply_field.input = contact.reply or ""
  end)
  local sender_text = require 'engine.gui.Text':new{main=self.main, x = -37, y = -10, text = "", lineHeight = 1.4, font = FONTS["mono16"]}
  
  local sender_text_color = {0.3, 0.3, 0.3, 1}
  local subject_text_color = {0, 0, 0, 1}
  b:insert(sender_text)

  local function create_base_button_text()
    return {
      sender_text_color, ""..contact:getName() ,
    }
  end
  sender_text:setColoredText(create_base_button_text())
  b.callbacks:register("update", function(b)
    if self.opencontact == contact then
      b:setColor(0.8, 0.8, 0)
    else
      b:setColor(1, 1, 1)
    end
    
    
    self.reply_button.visibleAndActive = self.opencontact
    --self.reply_field.visibleAndActive = self.opencontact
    if self.opencontact then
      local canReply = self.main.contacts:canSolve(self.opencontact)
      self.reply_button.enabled = not self.opencontact.reply and canReply
      --self.reply_field.enabled = not self.opencontact.reply and canReply
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
  if self.opencontact then
    --love.graphics.setColor(0.4,0.4,0.4)
    love.graphics.push()
    love.graphics.stencil(self.stencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    love.graphics.translate(0, self.scroll_y)
    local a = 1
    love.graphics.scale(1/a, 1/a)
    local content = {}

    --table.insert(content, {0.8, 0.8, 0.8, 1})
    table.insert(content, {0, 0, 0, 1})
    table.insert(content, "Employee ID: ..." .. self.opencontact:getEmployeeID() .. "\n\n")
    table.insert(content, {0, 0, 0, 1})
    table.insert(content, "Name: ..." .. self.opencontact:getName() .. "\n\n")
    table.insert(content, {0, 0, 0, 1})
    table.insert(content, "Birthday: ..." .. self.opencontact:getBirthday() .. "\n\n")
    table.insert(content, {0, 0, 0, 1})
    table.insert(content, "Address: ..." .. self.opencontact:getAddress() .. "\n\n")
    
    
    
    local wrapLimit = self.w - self.contact_list_width - 4 - self.scrollbar.w/2
    local x = a*(-self.w/2 + self.contact_list_width + 2)
    local y = a*(-self.h/2 + 40 + 16)
    love.graphics.printf(content, x, y, (wrapLimit-16)/a, "left", 0, 1, 1, 0, 0, 0, 0)
    
    love.graphics.setStencilTest()
    love.graphics.pop()
  end
  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

return Self
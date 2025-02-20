local Super = require 'applications.dummy.gui.windows.Process'
local Self = Super:clone("DummyWindow")


Self.ID_NAME = "files"

function Self:init(args)
  args.w = 320+32+32
  args.h = 240
  args.title = "Files"
  Super.init(self, args)
  
  self.icon_count_width = 5
  self.icon_count_height = 3
  
  self.y_scroll = 0

  self.icons = {}


  --add scrollbar
  self.scrollbar = require 'engine.gui.Scrollbar':new{main=self.main, x = args.w/2 - 8, y = 8, w = 16, h = 240-16, orientation = "vertical"}
  self:insert(self.scrollbar)
  self.scrollbar.callbacks:register("onUp", function()
    self.y_scroll = self.y_scroll - 1
  end)
  self.scrollbar.callbacks:register("onDown", function()
    self.y_scroll = self.y_scroll + 1
  end)
  
  self.callbacks:register("update", function()
    self:reevaluateIcons()
  end)

  self:switchLocation()

  return self
end

function Self:reevaluateIcons()
  for i, v in ipairs(self.icons) do
    if v.pos_y - self.y_scroll < 0 or v.pos_y - self.y_scroll >= self.icon_count_height then
      v.visibleAndActive = false
    else
      v.visibleAndActive = true
    end
    --v.visibleAndActive = true
    --v:setName(v.pos_y)
    v.x = ((v.pos_x)-2)*(64+4)-16
    v.y = (math.floor((i-1)/self.icon_count_width)-1)*(64) - (self.y_scroll*64)
  end
end

function Self:addIcon(icon_type, info)
  local pos = #self.icons
  local pos_x = (pos)%(self.icon_count_width)
  local pos_y = math.floor((pos)/self.icon_count_width)

  local proto_t = {
    main = self.main,
    --x = ((pos_x)-2)*(64+4)-16,
    --y = (pos_y-1)*(64+4),
    pos_x = pos_x,
    pos_y = pos_y,
    w = 64,
    h = 64,
    name = require'engine.randomnoun'(),
    --img = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_console_prompt.png"),
  }

  local icon = nil
  local requiredFile = self.main.files:getRandomRequiredFile()
  icon = require('applications.dummy.gui.elements.' .. icon_type):new(proto_t)
  
  if icon then
    icon.text.color = {0, 0, 0}
  end
  if icon_type == "Icon_File_Document" then
    if not info.generatedRequiredFile and requiredFile and math.random(0, 3-1) <= 0 then
      icon:setName(requiredFile)
      icon.callbacks:register("onClicked", function(selff)
        self.main.flags:set("file_opened_"..icon.name)
        self.main.files:remove(icon.name)
      end)
      info.generatedRequiredFile = true
      icon.text.color = {1, 0, 1}
    end
  elseif icon_type == "Icon_Mail" then
    icon:setName("Mail")
  elseif icon_type == "Icon_Terminal" then
    icon:setName("Terminal")
  end

  if icon then
    icon.pos = pos
    self:insert(icon)
    table.insert(self.icons, icon)
  end
  
end


function Self:removeAllIcons()
  for i, v in ipairs(self.icons) do
    self.contents:remove(v)
  end
  self.icons = {}
end

function Self:switchLocation()
  self.y_scroll = 0
  self:removeAllIcons()
  self:generateIcons()
  self:reevaluateIcons()
end

function Self:generateIcons()
  local loot = self.main.filemanager:determineContents()
  table.insert(loot, "Icon_Folder")--has to be there or player gets stuck
  local table_shuffle = require 'lib.shuffle'
  table_shuffle(loot)
  local info = {}
  for i, loot_type in ipairs(loot) do
    self:addIcon(loot_type, info)
  end
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

  love.graphics.setColor(0/255, 0/255, 0/255)
  local w, h = 8, 8
  love.graphics.rectangle("line", math.floor( -(self.w/2) + w/2 ), math.floor( -(self.h/2) + h/2 + 16 ), self.w - w - 16, self.h - h - 16)
  
  love.graphics.setColor(255/255, 255/255, 255/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) + w/2 ), math.floor( -(self.h/2) + h/2 + 16 ), self.w - w - 16, self.h - h - 16)
  

  local previous_font = love.graphics.getFont()
  love.graphics.setFont(FONT_DEFAULT)

  
  love.graphics.setColor(1, 1, 1)
  love.graphics.setColor(1, 0, 0)
  
  --

  love.graphics.setFont(previous_font)

  
  self.contents:callall("draw")


  love.graphics.pop()
end

return Self
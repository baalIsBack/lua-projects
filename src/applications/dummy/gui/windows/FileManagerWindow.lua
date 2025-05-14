local Super = require 'applications.dummy.gui.windows.Process'
local Self = Super:clone("FileManagerWindow")


Self.ID_NAME = "filemanager"

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
    self:repositionIcons()
  end)

  
  return self
end



function Self:repositionIcons()
  for i, v in ipairs(self.icons) do
    
    v.x = ((i)-3)*(64+4)-16
    v.y = (math.floor((i-1)/self.icon_count_width)-1)*(64) - (self.y_scroll*64)
  end
end

function Self:addIcon(icon)
  
  

  self:insert(icon)
  table.insert(self.icons, icon)
end


function Self:removeAllIcons()
  for i, v in ipairs(self.icons) do
    self.contents:remove(v)
  end
  self.icons = {}
end


function Self:draw()
  if not self:isReal() then
    return
  end
  self:applySelectionColorTransformation()
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
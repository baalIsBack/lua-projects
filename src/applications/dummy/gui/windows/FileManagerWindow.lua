local Super = require 'applications.dummy.gui.windows.Process'
local Self = Super:clone("FileManagerWindow")


Self.INTERNAL_NAME = "filemanager"

function Self:init(args)
  args.w = 320+32+32
  args.h = 240
  args.title = "Files"
  Super.init(self, args)
  
  self.icon_count_width = 5
  self.icon_count_height = 3
  
  self.y_scroll = 0

  self.icons = {}

  self.stencilFunction = function()
    love.graphics.rectangle("fill", math.floor( -(self.w/2)-2 ), math.floor( -(self.h/2) ), self.w, self.h-4)
  end
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

  self.space_bar = require 'engine.gui.ProgressBar':new{
    main=self.main,
    x = 0-8,
    y = self.h/2 - 16 + 4,
    w = self.w - 16 - 4 - 4,
    h = 16,
  }
  self:insert(self.space_bar)
  self.space_bar:start()

  
  return self
end



function Self:repositionIcons()
  for i, v in ipairs(self.icons) do
    local xx, yy = (i-1) % self.icon_count_width, math.floor((i-1) / self.icon_count_width)
    if yy - self.y_scroll < 0 or yy - self.y_scroll >= self.icon_count_height then
      v:setReal(false)
    else
      v:setReal(true)
    end
    --v:setReal(true)
    --v:setName(v.pos_y)
    v.x = ((xx)-2)*(64+4)-16
    v.y = (math.floor((i-1)/self.icon_count_width)-1)*(64) - (self.y_scroll*64)
  end
end

function Self:addIcon(icon)
  
  

  self:insert(icon)
  table.insert(self.icons, icon)
  self:repositionIcons()
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
  love.graphics.rectangle("line", math.floor( -(self.w/2) + w/2 ), math.floor( -(self.h/2) + h/2 + 16 ), self.w - w - 16, self.h - h - 16 -16 - 4)
  
  love.graphics.setColor(255/255, 255/255, 255/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) + w/2 ), math.floor( -(self.h/2) + h/2 + 16 ), self.w - w - 16, self.h - h - 16 -16 -4)
  

  local previous_font = love.graphics.getFont()
  love.graphics.setFont(FONT_DEFAULT)

  
  love.graphics.setColor(1, 1, 1)
  love.graphics.setColor(1, 0, 0)
  
  --

  love.graphics.setFont(previous_font)

    
  love.graphics.stencil(self.stencilFunction, "replace", 1)
--  love.graphics.setStencilTest("greater", 0)
  self.contents:callall("draw")
  love.graphics.setStencilTest()

  love.graphics.pop()
end



return Self
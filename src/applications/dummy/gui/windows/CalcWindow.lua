local Super = require 'applications.dummy.gui.windows.Process'
local Self = Super:clone("CalcWindow")


Self.ID_NAME = "calc"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_calendar-3.png")

function Self:init(args)
  args.w = 320
  args.h = 240
  args.title = "Calc"
  Super.init(self, args)


  

  self.button1 = require 'engine.gui.Button':new{main=self.main, x = -self.w/2 + 16 - 1, y = -self.h/2 + 16 + 16-2, w = 22, h = 22}
  self:insert(self.button1)
  self.button1.callbacks:register("onClicked", function() print("oi") end)
  
  self.button1:insert(require 'engine.gui.Image':new{main=self.main, img = love.graphics.newImage("submodules/lua-projects-private/gfx/oldschool95/icon_new_file.png")})

  return self
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

  local previous_font = love.graphics.getFont()
  love.graphics.setFont(FONT_DEFAULT)

  
  local cell_width, cell_height = 64+16, 15
  local top_border_height = cell_height*3
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) +top_border_height ), self.w, self.h -top_border_height)
  love.graphics.setColor(128/255, 128/255, 128/255)
  --320, 240
  --vertical lines with 10px distance
  for i = -self.w/2, self.w/2, cell_width do
    love.graphics.line(i, -self.h/2 + top_border_height, i, self.h/2)
  end
  --horizontal lines with 10px distance
  for i = -self.h/2 + top_border_height, self.h/2, cell_height do
    love.graphics.line(-self.w/2, i, self.w/2, i)
  end
  love.graphics.setColor(192/255, 192/255, 192/255)
  
  

  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

return Self
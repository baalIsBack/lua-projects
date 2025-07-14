local Super = require 'applications.dummy.gui.windows.Process'
local Self = Super:clone("DebugkWindow")

Self.INTERNAL_NAME = "debug"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_unknown_drive-3.png")

function Self:init(args)
  args.w = 320
  args.h = 240+150
  Super.init(self, args)
  

  self:insert(require 'engine.gui.Checkbox':new{main = self.main, y = -60, text= "Checkbox"})
  self:insert(require 'engine.gui.RadioButton':new{main = self.main, y = -40, text= "RadioButton1", group = "group1"})
  self:insert(require 'engine.gui.RadioButton':new{main = self.main, y = -20, text= "RadioButton2", group = "group1"})
  self:insert(require 'engine.gui.Button_Ok':new{main = self.main,})
  self:insert(require 'engine.gui.Button_Cancel':new{main = self.main,y=20})
  self:insert(require 'engine.gui.Button_Apply':new{main = self.main,y=40})
  self:insert(require 'engine.gui.TextField':new{main = self.main, y=60, w = 128, accepting_input = true,})
  self:insert(require 'engine.gui.TextField':new{main = self.main, y=80, w = 128, accepting_input = false,})
  self:insert(require 'engine.gui.Button':new{main = self.main, y = 100, text= "Button"})
  self:insert(require 'engine.gui.Listbox':new{main = self.main, y = 120+16, w = 128, h = 3*16, title = "Listbox", items={"a", "b", "c", "d", "e", "f", "Deine Mudda"}})
  --self:insert(require 'engine.gui.DropdownListbox':new{main = self.main, y = 120+16 + 3*16, w = 128, title = "Listbox", items={"a", "b", "c", "d", "e", "f", "Deine Mudda"}})
  

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
  local previous_font = love.graphics.getFont()
  love.graphics.setFont(FONT_DEFAULT)

  --c0c0c0 192/255
  love.graphics.setColor(192/255, 192/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)


  
  
  
  

  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

return Self
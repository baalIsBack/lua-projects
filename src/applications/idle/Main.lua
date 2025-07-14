local Super = require 'engine.Scene'
local Self = Super:clone("Main")

require 'lib.hexgrid'
Tween = require 'lib.tween'

FONTS = {}

local nuklear = require 'nuklear'

function Self:init()
  Super.init(self)

  FONTS["mono16"] = love.graphics.newImageFont("submodules/lua-projects-private/font/jasoco/font1.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 :-!.,\"?>_#<{}()[]\\+/;%&='*", 0)
  FONTS["mono16"]:setLineHeight(1)
  love.graphics.setFont(FONTS["mono16"])

  math.randomseed(os.time())

  self.ui = nuklear.newUI()
  
  -- Add window state tracking
  self.windowOpen = true

  self.operations = 0

  return self
end

local combo = {value = 1, items = {'A', 'B', 'C'}}

function Self:update(dt)
  self.ui:frameBegin()
  
  -- Only create window if it should be open
  if self.windowOpen then
    local windowResult = self.ui:windowBegin('Simple Example', 100, 100, 200, 360,
        'border', 'title', 'movable', 'closable')
    
    if windowResult then
      self.ui:layoutRow('dynamic', 30, 1)
      self.ui:label('Operations: ' .. self.operations)
      if self.ui:button('Calculate!') then
        self.operations = self.operations + 1
      end
      self.ui:layoutRow('dynamic', 30, 2)
      self.ui:label('Combo box:')
      if self.ui:combobox(combo, combo.items) then
        print('Combo!', combo.items[combo.value])
      end
      self.ui:layoutRow('dynamic', 30, 3)
      if self.ui:button('Button') then
        print('Button!')
      end
    else
      -- Window was closed by the close button
      self.windowOpen = false
    end
    
    self.ui:windowEnd()
  end
  
  self.ui:frameEnd()
end

function Self:draw()
  self.ui:draw()

  
end
function Self:keypressed(key, scancode, isrepeat)
  self.ui:keypressed(key, scancode, isrepeat)
  
  -- Press 'space' to reopen window
  if key == "space" and not self.windowOpen then
    self.windowOpen = true
  end
end

function Self:keyreleased(key, scancode)
	self.ui:keyreleased(key, scancode)
end

function Self:mousepressed(x, y, button, istouch, presses)
	self.ui:mousepressed(x, y, button, istouch, presses)
end

function Self:mousereleased(x, y, button, istouch, presses)
	self.ui:mousereleased(x, y, button, istouch, presses)
end

function Self:mousemoved(x, y, dx, dy, istouch)
	self.ui:mousemoved(x, y, dx, dy, istouch)
end

function Self:textinput(text)
	self.ui:textinput(text)
end

function Self:wheelmoved(x, y)
	self.ui:wheelmoved(x, y)
end



return Self



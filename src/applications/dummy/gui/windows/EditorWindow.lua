local Super = require 'applications.dummy.gui.windows.Process'
local Self = Super:clone("EditorWindow")


Self.ID_NAME = "editor"

function Self:init(args)
  args.w = 320/2
  args.h = 240
  args.title = "Editor"
  Super.init(self, args)

  self.input = ""
  self.accepting_input = true
  self.cursor_position = 1
  self.cursor_timer = 0
  self.cursor_state_visible = true
  self.maximum_visible_lines = 17

  self.sound_pool = {}
  for i=1, 5 do
    self.sound_pool[i] = love.audio.newSource("submodules/lua-projects-private/sfx/grace.wav", "static")
  end
  

  self.callbacks:register("keypressed", function(self, key, scancode, isrepeat)
    
    if not self:hasFocus() or not self.accepting_input then
      return
    end
    for i, v in ipairs(self.sound_pool) do
      if not v:isPlaying() then
        v:play()
        break
      end
    end
    if key == "backspace" then
      if self.cursor_position > 1 then
        self.input = self.input:sub(1, self.cursor_position-2) .. self.input:sub(self.cursor_position)
        self.cursor_position = math.max(1, self.cursor_position-1)
      end
    elseif key == "return" then
      self.main.notes:addNote(self.input)
      self.input = ""
      self.cursor_position = 1
    elseif key == "left" then
      self.cursor_position = math.max(1, self.cursor_position-1)
    elseif key == "right" then
      self.cursor_position = math.min(#self.input+1, self.cursor_position+1)
    end
  end)
  self.callbacks:register("textinput", function(self, text)
    if not self:hasFocus() or not self.accepting_input then
      return
    end
    self.input = self.input:sub(1, self.cursor_position-1) .. require 'engine.sstring'.toFirstLower(text) .. self.input:sub(self.cursor_position)
    self.cursor_position = self.cursor_position + 1
  end)

  self.callbacks:register("update", function(self, dt)
    if not self:hasFocus() then
      self.cursor_state_visible = false
      return
    end
    self.cursor_timer = self.cursor_timer + dt
    if self.cursor_timer > 0.5 then
      self.cursor_timer = 0
      self.cursor_state_visible = not self.cursor_state_visible
    end
  end)

  

  return self
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

  
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", math.floor( -(self.w/2)+2 ), math.floor( -(self.h/2)+2 ), self.w-4, self.h-4)
  
  

  
  
  local x = -self.w/2 + 3
  local y = -self.h/2 + (1)*12 + 16 + 5 + (0-1)*16
  love.graphics.setColor(0, 0, 0)
  for i, v in ipairs(self.main.notes.note_list) do
    love.graphics.print(v, x, y + (i-1)*12)
  end

  love.graphics.print(self.input, x, y + (#self.main.notes.note_list)*12)
  if self.cursor_state_visible then
    --TODO adjust so this stays correct when wrapping text
    local s = string.rep(" ", self.cursor_position-1)
    local space = love.graphics.getFont():getWidth(s)--"  " .. string.rep(" ", self.cursor_position-1)
    love.graphics.setColor(0, 0, 0)
    --love.graphics.print("]", x + space, y + (#self.main.notes.note_list)*12)
    love.graphics.print("_", x + space, y + (#self.main.notes.note_list)*12)
    --love.graphics.print("*", x + space, y + (#self.main.notes.note_list)*12)

    
  end

  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

return Self
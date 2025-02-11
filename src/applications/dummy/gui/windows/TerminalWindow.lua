local Super = require 'engine.gui.Window'
local Self = Super:clone("TerminalWindow")


function Self:init(args)
  args.w = 320
  args.h = 240
  args.title = "Terminal"
  Super.init(self, args)
  self.terminal = args.terminal
  self.main.terminal = self.terminal
  --self.terminal:appendLog("Welcome to the terminal!")

  self.input = ""
  self.cursor_position = 1
  self.cursor_timer = 0
  self.cursor_state_visible = true
  self.accepting_input = true
  self.maximum_visible_lines = 17


  self.font_color = args.font_color or {1, 1, 1}

  self.sound_pool = {}
  for i=1, 5 do
    self.sound_pool[i] = love.audio.newSource("submodules/lua-projects-private/sfx/grace.wav", "static")
  end

  self.stencilFunction = function()
    love.graphics.rectangle("fill", math.floor( -(self.w/2)-2 ), math.floor( -(self.h/2) ), self.w, self.h-4)
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
      self.terminal:execute(self.input)
      self.input = ""
      self.cursor_position = 1
    elseif key == "left" then
      self.cursor_position = math.max(1, self.cursor_position-1)
    elseif key == "right" then
      self.cursor_position = math.min(#self.input+1, self.cursor_position+1)
    end
  end)
  self.callbacks:register("textinput", function(self, text)
    local text = require 'engine.sstring'.sanitizeAscii(text)
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
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)

  local previous_font = love.graphics.getFont()
  love.graphics.setFont(FONT_DEFAULT)

  
  love.graphics.setColor(self.font_color)
  
  love.graphics.stencil(self.stencilFunction, "replace", 1)
  love.graphics.setStencilTest("greater", 0)

  local logs = self.terminal:getLogs(self.maximum_visible_lines)
  for i, line in ipairs(logs) do
    love.graphics.print(line, -self.w/2 + 2, 2-self.h/2 + (((#logs - i))*12) + 16 + 2)
  end

  if self.accepting_input then
    local text = "> "..self.input
    local width, wrappedText = FONT_DEFAULT:getWrap(text, self.w - 4)
    
    --TODO look at next todo
    love.graphics.print("> "..self.input, -self.w/2 + 2, 2-self.h/2 + (#logs)*12 + 16 + 2)
    
    if self.cursor_state_visible then
      --TODO adjust so this stays correct when wrapping text
      local space = "  " .. string.rep(" ", self.cursor_position-1)
      --love.graphics.print(space.."]", -self.w/2, -self.h/2 + (#logs)*12 + 16 + 2 + (#wrappedText-1)*16)
      love.graphics.print(space.."_", -self.w/2 + 2, 2-self.h/2 + (#logs)*12 + 16 + 2 + (#wrappedText-1)*16)
      --love.graphics.print(space.."*", -self.w/2, -self.h/2 + (#logs)*12 + 16 + 2 + (#wrappedText-1)*16)
    end
  end

  love.graphics.setStencilTest()
  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

return Self
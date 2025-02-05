local Super = require 'engine.gui.Node'
local Self = Super:clone("TextField")

function Self:init(args)
  args.color = args.color or {205/255, 205/255, 192/255}
  Super.init(self, args)
  
  self.sound_pool = {}
  for i=1, 5 do
    self.sound_pool[i] = love.audio.newSource("submodules/lua-projects-private/sfx/grace.wav", "static")
  end

  self.input = ""
  self.cursor_position = 1
  self.cursor_timer = 0
  self.cursor_state_visible = true
  self.accepting_input = args.accepting_input
  if self.accepting_input == nil then
    self.accepting_input = true
  end

  self.callbacks:declare("onSubmit")

  self.callbacks:register("keypressed", function(self, key, scancode, isrepeat)
    
    if not self:hasFocus() or not self.accepting_input or not self.enabled then
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
      self:submit()
    elseif key == "left" then
      self.cursor_position = math.max(1, self.cursor_position-1)
    elseif key == "right" then
      self.cursor_position = math.min(#self.input+1, self.cursor_position+1)
    end
  end)
  self.callbacks:register("textinput", function(self, text)
    if not self:hasFocus() or not self.accepting_input or not self.enabled then
      return
    end
    self.input = self.input:sub(1, self.cursor_position-1) .. require 'engine.sstring'.toFirstLower(text) .. self.input:sub(self.cursor_position)
    self.cursor_position = self.cursor_position + 1
  end)
  self.callbacks:register("update", function(self, dt)
    if not self:hasFocus() then
      self.cursor_state_visible = false
    end
    --split text at cursor position into two strings
    local left = self.input:sub(1, self.cursor_position-1) --draw first string
    local middle = self.input:sub(self.cursor_position, self.cursor_position)
    local right = self.input:sub(self.cursor_position+1) --draw second string
    
    if self.cursor_state_visible and self.enabled then
      middle = "_"
    end
    self.text:setText(left .. middle .. right)
    self.text2:setText("")--self.input

    if not self:hasFocus() then
      return
    end

    self.cursor_timer = self.cursor_timer + dt
    if self.cursor_timer > 0.5 and self.accepting_input then
      self.cursor_timer = 0
      self.cursor_state_visible = not self.cursor_state_visible
    end
  end)

  self.text = require 'engine.gui.Text':new{
    main = self.main,
    text = self.input,
    color = {0, 0, 0},
    x = -self.w/2 + 2,
    y = 0,
    alignment="left",
    maxWidth = self.w - 4,
  }
  self:insert(self.text)

  self.text2 = require 'engine.gui.Text':new{
    main = self.main,
    text = self.input,
    color = {0, 0, 0},
    x = -self.w/2 + 2,
    y = 0,
    alignment="left",
    maxWidth = self.w - 4,
  }
  self:insert(self.text2)



  

	return self
end

function Self:submit()
  local input = self.input
  self.input = ""
  self.cursor_position = 1
  self.callbacks:call("onSubmit", {self, input})
end

function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)
  
  love.graphics.setColor(self.color)
  local r, g, b, a = love.graphics.getColor( )
  if not self.enabled then
    love.graphics.setColor(r/1.2, g/1.2, b/1.2)
  end

  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)

  
  
  
  
  self.contents:callall("draw")

  love.graphics.pop()
end

return Self

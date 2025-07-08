local Super = require 'engine.Scene'
local Self = Super:clone("Main")

require 'lib.hexgrid'
Tween = require 'lib.tween'

rounded = require 'engine.rounded'

FONTS = {}

local nuklear = require 'nuklear'

-- Create canvases
sceneCanvas = love.graphics.newCanvas()
brightCanvas = love.graphics.newCanvas()
blurCanvas1 = love.graphics.newCanvas()
blurCanvas2 = love.graphics.newCanvas()

-- Load shaders
thresholdShader = love.graphics.newShader[[
    extern number threshold;
    vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
        vec4 pixel = Texel(tex, texCoord);
        float brightness = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
        return (brightness > threshold) ? pixel : vec4(0.0);
    }
]]

blurShader = love.graphics.newShader[[
    extern vec2 direction;
    const float offset = 1.0 / 300.0;

    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
        vec4 sum = vec4(0.0);
        sum += Texel(tex, tc - 4.0 * direction * offset) * 0.05;
        sum += Texel(tex, tc - 3.0 * direction * offset) * 0.09;
        sum += Texel(tex, tc - 2.0 * direction * offset) * 0.12;
        sum += Texel(tex, tc - 1.0 * direction * offset) * 0.15;
        sum += Texel(tex, tc                          ) * 0.16;
        sum += Texel(tex, tc + 1.0 * direction * offset) * 0.15;
        sum += Texel(tex, tc + 2.0 * direction * offset) * 0.12;
        sum += Texel(tex, tc + 3.0 * direction * offset) * 0.09;
        sum += Texel(tex, tc + 4.0 * direction * offset) * 0.05;
        sum += vec4(0.0, 0.0, 0.0, 1.0); // Ensure alpha is 1.0
        return sum;
    }
]]

function Self:init()
  Super.init(self)

  FONTS["mono16"] = love.graphics.newImageFont("submodules/lua-projects-private/font/jasoco/font1.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 :-!.,\"?>_#<{}()[]\\+/;%&='*", 0)
  FONTS["mono16"]:setLineHeight(1)
  love.graphics.setFont(FONTS["mono16"])

  math.randomseed(os.time())

  self.ui = nuklear.newUI()
  
  -- Add window state tracking
  self.windowOpen = false
  

  love.graphics.setLineWidth( 4 )
  love.graphics.setLineStyle("smooth")
  love.graphics.setLineJoin("bevel")

  self.entities = {}
  self:insert(require 'applications.explorer.Player':new({x = 100, y = 100}))

  self.coins = 0

  DEBUG = false

  return self
end

function Self:findEntitysByTag(tag)
  local result = {}
  for _, entity in ipairs(self.entities) do
    if entity.tags and entity.tags[tag] then
      table.insert(result, entity)
    end
  end
  return result
end

function Self:insert(entity)
  
  table.insert(self.entities, entity)
  entity.main = self
end

function Self:remove(entity)
  for i, e in ipairs(self.entities) do
    if e == entity then
      table.remove(self.entities, i)
      return
    end
  end
  print("Entity not found in scene!")
  
end
local counter = 0

function Self:update(dt)
  for _, entity in ipairs(self.entities) do
    entity:update(dt)
  end
  for i = #self.entities, 1, -1 do
    if self.entities[i]._canBeRemoved then
      table.remove(self.entities, i)
    end
  end


  counter = counter + dt
  if counter > 3 then
    counter = 0

    --get x and y of any point on any screen border
    local screenWidth, screenHeight = love.graphics.getDimensions()
    local borderX = math.random(0, screenWidth)
    local borderY = math.random(0, screenHeight)
    local x, y = 0, 0
    local r = math.random(1, 4)
    if r == 1 then
      x = borderX
      y = 0
    elseif r == 2 then
      x = screenWidth
      y = borderY
    elseif r == 3 then
      x = borderX
      y = screenHeight
    elseif r == 4 then
      x = 0
      y = borderY
    end

    local b = require 'applications.explorer.Enemy':new({
      x = x,
      y = y,
      dx = math.random(-1, 1),
      dy = math.random(-1, 1),
      speed = 100
    })
    self:insert(b)

  end

end



function Self:draw()
  self.ui:draw()
  
  

  -- STEP 1: draw full scene to sceneCanvas
  love.graphics.setCanvas(sceneCanvas)
  love.graphics.clear()
  love.graphics.setShader()


  for _, entity in ipairs(self.entities) do
    if entity.draw then
      entity:draw()
    end
  end

  love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
  love.graphics.print("Coins: " .. self.coins, 10, 10)








    -- you could also draw text, shapes, etc. here
    love.graphics.setCanvas()

    -- STEP 2: extract bright areas
    love.graphics.setCanvas(brightCanvas)
    love.graphics.clear()
    love.graphics.setShader(thresholdShader)
    thresholdShader:send("threshold", 0.2)
    love.graphics.draw(sceneCanvas)
    love.graphics.setShader()
    love.graphics.setCanvas()

    -- STEP 3a: horizontal blur
    love.graphics.setCanvas(blurCanvas1)
    love.graphics.clear()
    love.graphics.setShader(blurShader)
    blurShader:send("direction", {1.0, 0.0})
    love.graphics.draw(brightCanvas)
    love.graphics.setShader()
    love.graphics.setCanvas()

    -- STEP 3b: vertical blur
    love.graphics.setCanvas(blurCanvas2)
    love.graphics.clear()
    love.graphics.setShader(blurShader)
    blurShader:send("direction", {0.0, 1.0})
    love.graphics.draw(blurCanvas1)
    love.graphics.setShader()
    love.graphics.setCanvas()

    -- STEP 4: composite scene + blurred glow
    love.graphics.setShader()
    love.graphics.draw(sceneCanvas)
    love.graphics.setBlendMode("add") -- bloom glow uses additive blending
    love.graphics.draw(blurCanvas2)
    love.graphics.setBlendMode("alpha")
  
end
function Self:keypressed(key, scancode, isrepeat)
  self.ui:keypressed(key, scancode, isrepeat)
  
  -- Press 'space' to reopen window
  if key == "space" and not self.windowOpen then
    self.windowOpen = true
  end

  for _, entity in ipairs(self.entities) do
    if entity.keypressed then
      entity:keypressed(key, scancode, isrepeat)
    end
  end

  if key == "f1" then
    DEBUG = not DEBUG
    if DEBUG then
      print("Debug mode enabled")
    else
      print("Debug mode disabled")
    end
  end
end

function Self:keyreleased(key, scancode)
	self.ui:keyreleased(key, scancode)
  for _, entity in ipairs(self.entities) do
    if entity.keyreleased then
      entity:keyreleased(key, scancode)
    end
  end
end

function Self:mousepressed(x, y, button, istouch, presses)
	self.ui:mousepressed(x, y, button, istouch, presses)
  for _, entity in ipairs(self.entities) do
    if entity.mousepressed then
      entity:mousepressed(x, y, button, istouch, presses)
    end
  end
end

function Self:mousereleased(x, y, button, istouch, presses)
	self.ui:mousereleased(x, y, button, istouch, presses)
  for _, entity in ipairs(self.entities) do
    if entity.mousereleased then
      entity:mousereleased(x, y, button, istouch, presses)
    end
  end
end

function Self:mousemoved(x, y, dx, dy, istouch)
	self.ui:mousemoved(x, y, dx, dy, istouch)
  for _, entity in ipairs(self.entities) do
    if entity.mousemoved then
      entity:mousemoved(x, y, dx, dy, istouch)
    end
  end
end

function Self:textinput(text)
	self.ui:textinput(text)
  for _, entity in ipairs(self.entities) do
    if entity.textinput then
      entity:textinput(text)
    end
  end
end

function Self:wheelmoved(x, y)
	self.ui:wheelmoved(x, y)

  for _, entity in ipairs(self.entities) do
    if entity.wheelmoved then
      entity:wheelmoved(x, y)
    end
  end
end



return Self



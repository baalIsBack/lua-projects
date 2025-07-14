--erdrückende atmosphäre
--etwas gruselig
--ähnlich zu buckshot roulette
--1-bit mit braungrauer farbe

--buch mit "Die Leere" aber weitergeschrieben in ki zukunft cube


if arg[2] == "debug" or os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
	require 'lldebugger'.start()
end
function assert(cond, p)
  if not cond then
    print("Assertion failed: " .. tostring(p))
    err()
  end
end

love.graphics.setDefaultFilter("nearest", "nearest")


require 'engine.extension'






local scenemanager



--Prototype = require 'engine.Prototype'
--cron = require 'engine.cron'
--Scenemanager = require 'engine.Scenemanager'
--Animation = require 'engine.Animation'
local IMG_MOUSE = love.graphics.newImage("submodules/lua-projects-private/gfx/Mini Pixel Pack 3/Effects/Sparkle (16 x 16).png")


function love.load()
  
	--UI_FONT = love.graphics.newFont("Hyperdrift-private/assets/font/spacecargo.ttf", math.floor(2 * 5))
  --UI_FONT = love.graphics.newFont(math.floor(2 * 5))

	love.graphics.setBackgroundColor(0, 0, 16 / 255)
	--love.graphics.setFont(FONT)
	scenemanager = require 'engine.Scenemanager':new()

--  scenemanager:register("Main", require'applications.dummy.Main':new())
--  scenemanager:register("Main", require'applications.filefighter.Main':new())
  --scenemanager:register("Main", require'applications.idle_factory.Main':new())
  
  --scenemanager:register("Main", require'applications.shadertest.Main':new())
  --scenemanager:register("Main", require'applications.battlenetwork.Main':new())
  
  --scenemanager:register("Main", require'applications.farm.Main':new())
  --scenemanager:register("Main", require'applications.space.Main':new())
  

  --scenemanager:register("Main", require'applications.hex.Main':new())
  --scenemanager:register("Main", require'applications.idle_clicker.Main':new())
  scenemanager:register("Main", require'applications.explorer.Main':new())
  
end

debug.getregistry().Quad.flip = function (self, x, y)
  local vpx, vpy, vpw, vph = self:getViewport()
  local vpsx, vpsy = self:getTextureDimensions()
  if x then
    vpx = -vpx - vpw
    vpsx = -vpsx
  end
  if y then
    vpy = -vpy - vph
    vpsy = -vpsy
  end
  self:setViewport(vpx, vpy, vpw, vph, vpsx, vpsy)
end

function love.update(dt)
	if not love.window.hasFocus() then
		--love.timer.sleep(0.2)
	end
	if dt > 0.2 then
		dt = dt - 0.2
	end
	scenemanager:update(dt)

  --quit if esc is pressed
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end

end

function love.draw()
	love.graphics.setBackgroundColor(0, 0, 16 / 255)
	love.graphics.setColor(1, 1, 1)

  local sx, sy = require 'engine.Screen':getScale()
  love.graphics.scale(sx, sy)
	scenemanager:draw()
end

function love.quit()
  if scenemanager.quit then
    return scenemanager:quit()
  end
  
	return false
end

function love.keypressed(key, scancode, isrepeat)
  scenemanager:keypressed(key, scancode, isrepeat)
end

function love.textinput(text)
  scenemanager:textinput(text)
end

function love.mousereleased( x, y, button, istouch, presses )
  scenemanager:mousereleased( x, y, button, istouch, presses )
end

function love.mousepressed( x, y, button, istouch, presses )
  scenemanager:mousepressed( x, y, button, istouch, presses )
  
end

function love.mousemoved(x, y, dx, dy, istouch)
  scenemanager:mousemoved(x, y, dx, dy, istouch)
  
end

function love.keyreleased(key, scancode)
	scenemanager:keyreleased(key, scancode)
end

function love.wheelmoved(x, y)
	scenemanager:wheelmoved(x, y)
end
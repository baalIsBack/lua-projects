--erdrückende atmosphäre
--etwas gruselig
--ähnlich zu buckshot roulette
--1-bit mit braungrauer farbe

--buch mit "Die Leere" aber weitergeschrieben in ki zukunft cube


if arg[2] == "debug" or os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
	require 'lldebugger'.start()
end


love.graphics.setDefaultFilter("nearest", "nearest")


require 'engine.extension'






local scenemanager



--Prototype = require 'engine.Prototype'
--cron = require 'engine.cron'
--Scenemanager = require 'engine.Scenemanager'
--Animation = require 'engine.Animation'


function love.load()
  
	--UI_FONT = love.graphics.newFont("Hyperdrift-private/assets/font/spacecargo.ttf", math.floor(2 * 5))
  --UI_FONT = love.graphics.newFont(math.floor(2 * 5))

	love.graphics.setBackgroundColor(0, 0, 16 / 255)
	--love.graphics.setFont(FONT)
	scenemanager = require 'engine.Scenemanager':new()

  scenemanager:register("Main", require'applications.dummy.Main':new())
  --scenemanager:register("Main", require'applications.hex.Main':new())
  --scenemanager:register("Main", require'applications.space.Main':new())
  
end

function love.update(dt)
	if not love.window.hasFocus() then
		--love.timer.sleep(0.2)
	end
	if dt > 0.2 then
		dt = dt - 0.2
	end
	scenemanager:update(dt)
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

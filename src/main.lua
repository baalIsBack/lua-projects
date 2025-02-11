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
FONTS = {}
FONTS["mono16"] = love.graphics.newImageFont("submodules/lua-projects-private/font/jasoco/font1.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 :-!.,\"?>_#<{}()[]\\+/;%&='*", 1)
FONTS["mono16"]:setLineHeight(1)

FONTS["dialog"] = love.graphics.newImageFont("submodules/lua-projects-private/font/jasoco/font2.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`_*#=[]'{}", 1)
FONTS["dialog"]:setLineHeight(.6)

FONTS["tiny"] = love.graphics.newImageFont("submodules/lua-projects-private/font/jasoco/font3.png", " 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.-,!:()[]{}<>", 1)
FONTS["tiny"]:setLineHeight(.8)

FONTS["1980"] = love.graphics.newFont("submodules/lua-projects-private/font/1980/1980v23P03.ttf", 20)

for i, v in ipairs(FONTS) do
  v:setFilter("nearest", "nearest")
end

function love.load()
  math.randomseed(os.time())
  FONT_DEFAULT = love.graphics.newFont("submodules/lua-projects-private/font/spacecargo.ttf", 10)--love.graphics.newFont("submodules/lua-projects-private/font/Weiholmir Standard/Weiholmir_regular.ttf", 7*2)
  FONT_DEFAULT = love.graphics.newFont("submodules/lua-projects-private/font/superpyxel/superpyxelreads.ttf", 10)
  FONT_DEFAULT = FONTS["mono16"]
  FONT = love.graphics.newFont(16)--"Hyperdrift-private/assets/font/Weiholmir Standard/Weiholmir_regular.ttf"
  FONT:setFilter("nearest", "nearest")
	--UI_FONT = love.graphics.newFont("Hyperdrift-private/assets/font/spacecargo.ttf", math.floor(2 * 5))
  --UI_FONT = love.graphics.newFont(math.floor(2 * 5))

	love.graphics.setBackgroundColor(0, 0, 16 / 255)
	--love.graphics.setFont(FONT)
	scenemanager = require 'engine.Scenemanager':new()

  scenemanager:register("Main", require'applications.dummy.Main':new())
  scenemanager:switch("Main")
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
	return false
end

function love.keypressed(key, scancode, isrepeat)
  scenemanager:keypressed(key, scancode, isrepeat)
end

function love.textinput(text)
  scenemanager:textinput(text)
end

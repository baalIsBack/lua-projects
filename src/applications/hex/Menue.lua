local Super = require 'engine.Prototype'
local Self = Super:clone("Menue")



function Self:init(args)

  self.main = args.main
  self.layout = Layout(layout_flat, Point(24, 24), Point(24, 24))
    self.mapDots = {}
  for i=1, 400 do
    table.insert(self.mapDots, {
      x = math.random(0, 800),
      y = math.random(0, 600),
      size = 1
    })
  end

  self.buttons = {}
  table.insert(self.buttons, require 'applications.hex.Button':new{
    main = self.main,
    x = 200,
    y = 100,
    w = 100,
    h = 20,
    text = "Button 1",
    color = {0.8, 0.8, 0.8},
    text_color = {0, 0, 0},
    f = function(button)
      self.main.contents:insert(self.main.grid)
      self.main.contents:remove(self)
    end
  })

  return self
end

function Self:draw()
  love.graphics.setBackgroundColor(232/255, 210/255, 130/255)

  for i, dot in ipairs(self.mapDots) do
    --love.graphics.setColor(218/255, 177/255, 99/255)
    love.graphics.setColor(206/255, 146/255, 72/255)
    love.graphics.rectangle("fill", dot.x, dot.y, dot.size*2, 2*dot.size)
  end

  for i, button in ipairs(self.buttons) do
    button:draw()
  end
end

function Self:update(dt)
  for i, button in ipairs(self.buttons) do
    button:update(dt)
  end
end


function Self:mousepressed(x, y, button, istouch, presses)
  for _, b in ipairs(self.buttons) do
    b:mousepressed(x, y, button, istouch, presses)
  end
end

return Self
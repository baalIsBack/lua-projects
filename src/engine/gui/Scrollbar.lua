local Super = require 'engine.gui.Node'
local Self = Super:clone("Scrollbar")

function Self:init(args)
  Super.init(self, args)

  self.callbacks:declare("onUp")
  self.callbacks:declare("onDown")
  
  self.w = 16
  self.h = args.h

  

  --self:insert(require 'engine.gui.Text':new{main=self.main, x=0, y=0, text=self.title, color={1,1,1}, alignment="center"})
  self.button_up = require 'engine.gui.Button':new{main=self.main, x=0, y=-self.h/2 + 8, w=16, h=16, visibleAndActive=true}
  self:insert(self.button_up)
  local arrow_up = require 'engine.gui.Node':new{main=self.main, x = 0, y = 0}
  arrow_up.callbacks:register("onDraw", function(selff)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0,0,0)
    love.graphics.line(-4, 4, 4, 4)
    love.graphics.line(-4, 4, 0, -4)
    love.graphics.line(4, 4, 0, -4)
  end)
  self.button_up:insert(arrow_up)
  self.button_up.callbacks:register("onClicked", function() self:up() end)

  self.button_down = require 'engine.gui.Button':new{main=self.main, x=0, y=self.h/2 - 8, w=16, h=16, visibleAndActive=true}
  self:insert(self.button_down)
  local arrow_down = require 'engine.gui.Node':new{main=self.main, x = 0, y = 0}
  arrow_down.callbacks:register("onDraw", function(selff)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0,0,0)
    love.graphics.line(-4, -4, 4, -4)
    love.graphics.line(-4, -4, 0, 4)
    love.graphics.line(4, -4, 0, 4)
  end)
  self.button_down:insert(arrow_down)
  self.button_down.callbacks:register("onClicked", function() self:down() end)

	return self
end

function Self:up()
  self.callbacks:call("onUp", {self})
end

function Self:down()
  self.callbacks:call("onDown", {self})
end


function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  

  love.graphics.setLineWidth(2)

  love.graphics.setColor(205/255, 205/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)
  
  self.contents:callall("draw")

  love.graphics.pop()
end

return Self

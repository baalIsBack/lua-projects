local Super = require 'engine.gui.Node'
local Self = Super:clone("ProgressBar")

function Self:init(args)
  Super.init(self, args)

  self.title = args.title or ""
  self.w = args.w
  self.h = 16


  
  self.progress = 0
  self.speed = args.speed or 0.1
  self.running = args.running or false
  self.loop = args.loop or false

  self.callbacks:declare("onFilled")
  

  self:insert(require 'engine.gui.Text':new{main=self.main, x=0, y=0, text=self.title, color={1,1,1}, alignment="center"})

  self.callbacks:register("update", function(self, dt)
    if self.running then
      self:setProgress(self.progress + self.speed * dt)
    end
  end)
  

	return self
end


function Self:draw()
  if not self:isReal() then
    return
  end
  self:applySelectionColorTransformation()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  
 
  love.graphics.setLineWidth(2)

  --love.graphics.setColor(1/255, 0/255, 129/255)
  love.graphics.setColor(192/255, 192/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)

  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2)+2 ), math.floor( -(self.h/2)+2 ), (self.w-4)*1, self.h-4)
  
  love.graphics.setColor(1/255, 0/255, 129/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2)+2 ), math.floor( -(self.h/2)+2 ), (self.w-4)*self.progress, self.h-4)
  
  love.graphics.setColor(1, 1, 1)
  local font = love.graphics.getFont()
  local str = string.format("%.0f%%", self.progress*100)
  love.graphics.print(str, -font:getWidth(str)/2, -font:getHeight(str)/2)
  
  self.contents:callall("draw")

  love.graphics.pop()
end

function Self:setProgress(value)
  self.progress = value
  if self.progress < 0 then
    self.progress = 0
  end
  if self.progress > 1 then
    self.progress = 1
    self.callbacks:call("onFilled", {self})
    if self.loop then
      self.progress = 0
    else
      self:stop()
    end
  end  
end

function Self:start()
  self.running = true
end

function Self:stop()
  self.running = false
end

function Self:setSpeed(speed)
  self.speed = speed
end

function Self:isRunning()
  return self.running
end

return Self

local Super = require 'engine.gui.Button'
local Self = Super:clone("Icon")

Self.INTERNAL_NAME = "noid"
Self.DISPLAY_NAME = "noname"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_closed.png")
Self.filetype = "unknown"

function Self:init(args)
  args.w = args.w or 64
  args.h = args.h or 64
  Super.init(self, args)

  self.callbacks:declare("onOpen")
  
  -- Add these variables to store drag offset
  self._dragOffsetX = 0
  self._dragOffsetY = 0
  self.lastClickTime = 0

  self.callbacks:register("onClicked", function(selff)
    --self.main.filegenerator:setLootTable("folder")
    --local window = self.main.processes:getProcess("fileserver")
    
    local currentTime = love.timer.getTime()
    if currentTime - self.lastClickTime < 0.3 and self:canOpen() then
      -- Double click detected, open the folder
      self:open()
    else
      -- Single click, just update the last click time
      self.lastClickTime = currentTime
    end
  end)

  self.callbacks:register("onDragBegin", function(selff, x, y)
    -- Store the offset between mouse position and folder position
    local mx, my = Mouse:getPosition()
    self._dragOffsetX = self.x - mx
    self._dragOffsetY = self.y - my

    self.main.desktop:grab(self)
  end)

  self.callbacks:register("onDrag", function(selff, dx, dy)
    -- Apply the stored offset during drag
    if self.main.desktop.hand == self then
      local mx, my = Mouse:getPosition()
      self.x = mx + self._dragOffsetX
      self.y = my + self._dragOffsetY
    end
  end)

  self.pos_y = args.pos_y or 0
  self.pos_x = args.pos_x or 0

  
  
  self.name = args.name or self.DISPLAY_NAME
  
  self.z = -1
  
  
  self.image = require 'engine.gui.Image':new{main=self.main, img = args.img or self.IMG, x = 0, y = 0}
  self.text = require 'engine.gui.Text':new{main=self.main, text = self.name, color={1,1,1}, x = 0, y = 25}
  self.max_length_before_shortening = 10
  
  self:setName(self.name)
  self:insert( self.image )
  self:insert( self.text )

  
  
	return self
end

function Self:canOpen()
  return true
end

function Self:open()
  self.callbacks:call("onOpen", {self})
end

function Self:setName(name)
  self.name = name
  self.text:setText(name)
  if string.len(self.name) > self.max_length_before_shortening then
    self.text:setText(string.sub(self.name, 1, self.max_length_before_shortening-3).."...")
  end
end

function Self:draw()
  if not self:isReal() then
    return
  end
  self:applySelectionColorTransformation()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)
  
  
  love.graphics.setColor(1, 1, 1)
  if self._isStillClicking then
    love.graphics.setColor(192/255, 192/255, 230/255, 0.4)
    love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  end
  
  self.contents:callall("draw")
  if self.hasBeenOpened then
    love.graphics.setColor(0.5, 0.5, 0.5, 0.3)
    love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  end
  

  love.graphics.pop()
end

return Self

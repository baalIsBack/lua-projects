local Super = require 'engine.gui.Button'
local Self = Super:clone("Icon")

Self.ID_NAME = "noid"
Self.NAME = "noname"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_closed.png")

function Self:init(args)
  Super.init(self, args)

  self.filetype = args.filetype or "unknown"

  self.pos_y = args.pos_y or 0
  self.pos_x = args.pos_x or 0

  
  
  self.name = args.name or self.NAME
  
  self.z = -1
  
  
  self.image = require 'engine.gui.Image':new{main=self.main, img = args.img or self.IMG, x = 0, y = 0}
  self.text = require 'engine.gui.Text':new{main=self.main, text = self.name, color={1,1,1}, x = 0, y = 25}
  self.max_length_before_shortening = 10
  
  self:setName(self.name)
  self:insert( self.image )
  self:insert( self.text )

  
  
	return self
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

function Self:open()
  if not self.hasBeenOpened then
    local id, count
    id = "opened_" .. self.NAME
    count = self.main.values:get(id) or 0
    self.main.values:set(id, count + 1)

    
    id = "currently_collected_" .. self.NAME
    count = self.main.values:get(id) or 0
    self.main.values:set(id, count + 1)

    self.hasBeenOpened = true
    return true
  end
  return false
end

return Self

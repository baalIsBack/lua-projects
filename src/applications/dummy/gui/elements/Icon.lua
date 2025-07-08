local Super = require 'engine.gui.Button'
local Self = Super:clone("Icon")

Self.INTERNAL_NAME = "noid"
Self.DISPLAY_NAME = "noname"
Self.IMG = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w98_directory_closed.png")
Self.filetype = "unknown"

function Self:VALUE_OPEN_COUNT()
  return "opened_" .. self.INTERNAL_NAME
end

function Self:VALUE_CURRENTLY_COLLECTED_COUNT()
  return "currently_collected_" .. self.INTERNAL_NAME
end

function Self:init(args)
  args.w = args.w or 64
  args.h = args.h or 64
  Super.init(self, args)

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
    
    --[[HIER TODO this one right here
    suche nach vorkommen von ".values:get("und
    ".values:set(" (Im zweifel auch indem du dich
    in die calls reinhookst und dort die calls 
    abfaengst mit error()) und ersetze alles mit
    statischen variablen namen so wie hier:]]



    count = self.main.values:get(self:VALUE_OPEN_COUNT()) or 0
    self.main.values:set(self:VALUE_OPEN_COUNT(), count + 1)

    
    count = self.main.values:get(self:VALUE_CURRENTLY_COLLECTED_COUNT()) or 0
    self.main.values:set(self:VALUE_CURRENTLY_COLLECTED_COUNT(), count + 1)

    --local filemanagerwindow = self.main.processes:getProcess("filemanager")
    self.main.systems.filemanager.contents:insert(self)
    --filemanagerwindow:addIcon(self:clone())

    self.hasBeenOpened = true
    return true
  end
  return false
end



function Self:loadStatics(main)
  main.values.safe = true
  table.insert(main.values.defaults, {Self.VALUE_OPEN_COUNT, 0})
  table.insert(main.values.defaults, {Self.VALUE_CURRENTLY_COLLECTED_COUNT, 0})
  
  
  
  main.values.safe = false
end

return Self

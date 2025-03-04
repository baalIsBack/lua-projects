local Super = require 'engine.gui.Node'
local Self = Super:clone("Listbox")

function Self:init(args)
  Super.init(self, args)

  self.title = args.title or ""
  self.w = args.w
  self.h = args.h

  self.list = require 'engine.gui.List':new{
    main=args.main,
    x = -8,
    y = 0,
    w = self.w-16,
    h = self.h,
    elementSize = 16,
  }
  self:insert(self.list)

  self.scrollbar = require 'engine.gui.Scrollbar':new{
    main=args.main,
    x = self.w/2 - 8,
    y = 0,
    w = 16,
    h = self.h,
  }
  self:insert(self.scrollbar)

  self.scrollbar.callbacks:register("onUp", function()
    self.list:up()
  end)
  self.scrollbar.callbacks:register("onDown", function()
    self.list:down()
  end)

  local obj, b
  for i, v in ipairs(args.items) do

    
    b = require 'engine.gui.Button':new{
      main=args.main,
      x = 0,
      y = 0,
      w = self.w-16,
      h = 16,
      text = v,
      _invisible = true,
    }
    b.text:setAlignment("left")
    b.text.x = -self.w/2 + 12
    b.callbacks:register("onClicked", function()
      self:select(i)
    end)
    self.list:insert(b)
  end
  
  

  self.selection = 1
  

	return self
end

function Self:select(i)
  print(i)

  self.selection = i
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

  
  self.contents:callall("draw")

  love.graphics.setColor(192/255, 192/255, 230/255, 0.4)
  local pos = (self.selection - self.list.first_item_id)
  if pos >= 0 and pos < self.list.numberOfShownElements then
    love.graphics.rectangle("fill", 2-self.w/2, 2-self.h/2 + 16*pos, self.w-4-16, 16-4)
  end
  love.graphics.pop()
end



return Self

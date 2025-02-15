local Super = require 'engine.gui.Window'
local Self = Super:clone("CalcWindow")

function Self:init(args)
  args.w = 320
  args.h = 240
  args.title = "Stat"
  Super.init(self, args)
  

  self.list = require 'engine.gui.List':new{
    main=self.main,
    x = 0-8,
    y = 0+8,
    w = self.w-16-16,
    h = self.h-16-16,
    items = {}
  }
  self:insert(self.list)
  self.scrollbar = require 'engine.gui.Scrollbar':new{
    main=self.main,
    x = self.w/2-16+8,
    y = 8,
    h = self.h-16,
    orientation = "vertical"
  }
  self:insert(self.scrollbar)

  self.scrollbar.callbacks:register("onUp", function() print(self.list.first_item_id) self.list:up() end)
  self.scrollbar.callbacks:register("onDown", function() print(self.list.first_item_id) self.list:down() end)
  
  self.trackables = {}

  

  

  self.callbacks:register("update", function(self, dt)
    for i, v in ipairs(self.trackables) do
      v.node.text_node:setText("  " .. v.proto.NAME .. " x " .. self.main.values:get("currently_collected_"..v.value_id))
    end
  end)
  
  --self.list:insert(t)
  return self
end

function Self:finalize()
  if self.main.values:get("opened_Image") > 0 then
    self:addNewUniqueStat(require('applications.dummy.gui.elements.Icon_File_Image'))
  end
  if self.main.values:get("opened_Brick") > 0 then
    self:addNewUniqueStat(require('applications.dummy.gui.elements.Icon_Brick'))
  end
  if self.main.values:get("opened_Document") > 0 then
    self:addNewUniqueStat(require('applications.dummy.gui.elements.Icon_File_Document'))
  end
end

function Self:addNewUniqueStat(proto, value_id)
  local node, t

  for i, v in ipairs(self.trackables) do
    if v.value_id == proto.NAME then
      return
    end
  end

  node = require 'engine.gui.Node':new{
    main = self.main,
    x = -110,
    y = 0,
    w = 100,
    h = 36,
  }
  
  node:insert(require 'engine.gui.Image':new{
    main = self.main,
    x = -16,
    y = 0,
    img = proto.IMG,
  })
  t = require 'engine.gui.Text':new{
    main = self.main,
    x = 0,
    y = 0,
    text = " x 0",
    alignment = "left",
  }
  node:insert(t)
  node.text_node = t
  self.list:insert(node)
  table.insert(self.trackables, {node = node, value_id=proto.NAME, proto=proto})
end


function Self:draw()
  if not self.visibleAndActive then
    return
  end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setLineWidth(2)
  local previous_font = love.graphics.getFont()
  love.graphics.setFont(FONT_DEFAULT)

  --c0c0c0 192/255
  love.graphics.setColor(192/255, 192/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)


  
  
  
  

  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

return Self
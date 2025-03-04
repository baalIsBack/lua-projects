local Super = require 'applications.dummy.gui.windows.Process'
local Self = Super:clone("ProcessWindow")


Self.ID_NAME = "processes"

function Self:init(args)
  args.w = 320
  args.h = 240
  args.title = "Processes"
  Super.init(self, args)
  

  self.free_space_text = require 'engine.gui.Text':new{main=self.main, text = "", color={0, 0, 0}, x = 2-self.w/2, y = 16+4+2-self.h/2, alignment = "left"}
  self:insert(self.free_space_text)


  self.callbacks:register("update", function(dt)
    self.free_space_text:setText("Ram: " .. self.main.values:get("ram_current_used") .. "MB/" .. self.main.values:get("ram_total_size") .. "MB")
  end)


  self.list = require 'engine.gui.List':new{
    main=self.main,
    x = 0-8,
    y = 16*2,
    w = self.w-16,
    h = self.h-32*2,
    items = {},
    numberOfShownElements = 5,
  }
  self:insert(self.list)
  self.scrollbar = require 'engine.gui.Scrollbar':new{
    main=self.main,
    x = self.w/2-16+8,
    y = self.list.y,
    h = self.list.h,
    orientation = "vertical"
  }
  self:insert(self.scrollbar)

  self.scrollbar.callbacks:register("onUp", function() print(self.list.first_item_id) self.list:up() end)
  self.scrollbar.callbacks:register("onDown", function() print(self.list.first_item_id) self.list:down() end)
  
  self.trackables = {}

  

  

  self.callbacks:register("update", function(selff, dt)
    for i, v in ipairs(self.trackables) do
      v.node.text_node:setText("  " .. v.process.title .. ": " .. self.main.values:get("ram_usage_"..v.process.ID_NAME) .. "MB")
    end
  end)
  


  return self
end

function Self:finalize()
  self.main.processes.callbacks:register("onOpen", function(selff, process)
    self:addProcess(process)
  end)

  self.main.processes.callbacks:register("onClose", function(selff, process)
    self:removeProcess(process)
  end)
end

function Self:addProcess(process)
  local node, t


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
    img = (process.targetProcess and process.targetProcess.IMG) or process.IMG,
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
  table.insert(self.trackables, {node = node, process = process})
end

function Self:removeProcess(process)
  local foundHit = false
  for i, v in ipairs(self.trackables) do
    if v.process == process then
      self.list:remove(v.node)
      table.remove(self.trackables, i)
      foundHit = true
      break
    end
  end
  if not foundHit then
    print("Could not remove process: " .. process.ID_NAME)
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

  --c0c0c0 192/255
  love.graphics.setColor(192/255, 192/255, 192/255)
  love.graphics.rectangle("fill", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  --draw border like it is shaded
  love.graphics.setColor(128/255, 128/255, 128/255)
  love.graphics.rectangle("line", math.floor( -(self.w/2) ), math.floor( -(self.h/2) ), self.w, self.h)
  love.graphics.line(-self.w/2, self.h/2, self.w/2, self.h/2)

  local previous_font = love.graphics.getFont()
  love.graphics.setFont(FONT_DEFAULT)

  
  love.graphics.setColor(1, 1, 1)
  
  --

  love.graphics.setFont(previous_font)

  self.contents:callall("draw")

  love.graphics.pop()
end

return Self
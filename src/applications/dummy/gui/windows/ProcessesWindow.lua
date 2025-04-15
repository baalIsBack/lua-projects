local Super = require 'applications.dummy.gui.windows.Process'
local Self = Super:clone("ProcessWindow")


Self.ID_NAME = "processes"
Self.IMG_TOTAL_ICON = love.graphics.newImage("submodules/lua-projects-private/gfx/win_icons_png/w2k_network_computer-0.png")

function Self:init(args)
  args.w = 320
  args.h = 240
  args.title = "Processes"
  Super.init(self, args)
  
  self.process_list = {}

  self.free_space_text = require 'engine.gui.Text':new{main=self.main, text = "", color={0, 0, 0}, x = 2-self.w/2, y = 16+4+2-self.h/2, alignment = "left"}
  self:insert(self.free_space_text)


  self.callbacks:register("update", function(dt)
    self.free_space_text:setText("Ram: " .. self.main.values:get("ram_usage_current") .. "MB/" .. self.main.values:get("ram_usage_total") .. "MB")
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
    for i, v in ipairs(self.main.processes.contents.content_list) do
      local found = false
      for j, w in ipairs(self.trackables) do
        if w.process == v then
          found = true
          break
        end
      end
      if not found then
        self:addProcess(v)
      end
    end
    -- do the same but flip both loops with each other and ensure deletion
    for i, v in ipairs(self.trackables) do
      local found = false
      for j, w in ipairs(self.main.processes.contents.content_list) do
        if w == v.process or i <= 2 then
          found = true
          break
        end
      end
      if not found then
        self:removeProcess(v.process)
      end
    end


    for i, v in ipairs(self.trackables) do
      v.node.text_node:setText("  "
      .. left_pad(v.process.title, 12, " ")
      .. left_pad(""..self.main.values:get("ram_usage_"..v.process.ID_NAME).."MB", 6, " ")
      .. left_pad(""..self.main.values:get("rom_usage_"..v.process.ID_NAME).."MB", 8, " ")
      .. left_pad(""..self.main.values:get("cycles_usage_"..v.process.ID_NAME), 8, " "))
    end
  end)
  
  local total_text = require 'engine.gui.Text':new{
    main = self.main,
    x = -self.w/2 + 8+32+8,
    y = -70,
    text = "  "
    .. mid_pad("Name", 12, " ")
    .. left_pad("Ram", 6, " ")
    .. left_pad("space", 8, " ")
    .. left_pad("Cycles", 8, " "),
    alignment = "left",
  }
  self:insert(total_text)

  self:addTotal()
  self:addCurrent()

  return self
end

function Self:finalize()
  for i, process in ipairs(self.main.processes.contents.content_list) do
    self:addProcess(process)
  end
end

function Self:addProcess(process)
  local node, t, b


  node = require 'engine.gui.Node':new{
    main = self.main,
    x = -110,
    y = 0,
    w = 100,
    h = 36,
  }

  b = require 'engine.gui.Button':new{
    main = self.main,
    x = -30,
    y = 0,
    w = 10,
    h = 10,
    text = "x",
  }
  node:insert(b)
  b.text:setFont(FONTS["dialog"])
  b.text.x = 1
  b.text.y = -2
  b.enabled = true
  b.callbacks:register("onClicked", function()
    self.main.processes:closeProcess(process)
  end)

  node:insert(require 'engine.gui.Image':new{
    main = self.main,
    x = -16 + 16,
    y = 0,
    img = process.IMG,
  })
  t = require 'engine.gui.Text':new{
    main = self.main,
    x = 6,
    y = 0,
    text = "  "
    .. mid_pad(""..process.ID_NAME, 12, " ")
    .. left_pad(""..self.main.values:get("ram_usage_"..process.ID_NAME), 6, " ")
    .. left_pad(""..self.main.values:get("rom_usage_"..process.ID_NAME), 8, " ")
    .. left_pad("Cycles", 8, " "),
    alignment = "left",
  }
  node:insert(t)
  node.text_node = t
  self.list:insert(node)
  table.insert(self.trackables, {node = node, process = process})
  
end

function Self:addProcess2(process)
  local y = #self.process_list * 64


  local image = require 'engine.gui.Image':new{
    img = process.IMG,
    x = 20,
    y = y+5,
    w = 20,
    h = 20,
    main = self.main,
  }
  self:insert(image)

  local label = require 'engine.gui.Text':new{
    text = process.ID_NAME or "Unknown Process",
    x = 50,
    y = y+12,
    main = self.main
  }
  self:insert(label)

  local kill_button = require 'engine.gui.Button':new{
    text = "Kill",
    x = self.w - 60,
    y = y+7,
    w = 40,
    h = 20,
    main = self.main,
  }
  kill_button.onClick = function()
    self.main.processes:closeProcess(process)
    self:refresh()
  end
  self:insert(kill_button)

  table.insert(self.process_list, {
    process = process,
    image = image,
    label = label,
    kill_button = kill_button
  })

  return self
end

function Self:addTotal()
  local node, t, b


  node = require 'engine.gui.Node':new{
    main = self.main,
    x = -110,
    y = 0,
    w = 100,
    h = 36,
  }

  b = require 'engine.gui.Button':new{
    main = self.main,
    x = -30,
    y = 0,
    w = 10,
    h = 10,
    text = "x",
  }
  node:insert(b)
  b.text:setFont(FONTS["dialog"])
  b.text.x = 1
  b.text.y = -2
  b.enabled = false

  node:insert(require 'engine.gui.Image':new{
    main = self.main,
    x = -16 + 16,
    y = 0,
    img = self.IMG_TOTAL_ICON,
  })
  t = require 'engine.gui.Text':new{
    main = self.main,
    x = 6,
    y = 0,
    text = "  "
    .. mid_pad("Total", 12, " ")
    .. left_pad(""..self.main.values:get("ram_usage_total"), 6, " ")
    .. left_pad(""..self.main.values:get("rom_usage_total"), 8, " ")
    .. left_pad("Cycles", 8, " "),
    alignment = "left",
  }
  node:insert(t)
  node.text_node = t
  self.list:insert(node)
  table.insert(self.trackables, {node = node, process = {
    title = "Total",
    ID_NAME = "total",
  }})

end

function Self:addCurrent()
  local node, t, b


  node = require 'engine.gui.Node':new{
    main = self.main,
    x = -110,
    y = 0,
    w = 100,
    h = 36,
  }

  b = require 'engine.gui.Button':new{
    main = self.main,
    x = -30,
    y = 0,
    w = 10,
    h = 10,
    text = "x",
  }
  node:insert(b)
  b.text:setFont(FONTS["dialog"])
  b.text.x = 1
  b.text.y = -2
  b.enabled = false

  node:insert(require 'engine.gui.Image':new{
    main = self.main,
    x = -16 + 16,
    y = 0,
    img = self.IMG_TOTAL_ICON,
  })
  t = require 'engine.gui.Text':new{
    main = self.main,
    x = 6,
    y = 0,
    text = "  "
    .. mid_pad("Current", 12, " ")
    .. left_pad(""..self.main.values:get("ram_usage_current"), 6, " ")
    .. left_pad(""..self.main.values:get("rom_usage_current"), 8, " ")
    .. left_pad("Cycles", 8, " "),
    alignment = "left",
  }
  node:insert(t)
  node.text_node = t
  self.list:insert(node)
  table.insert(self.trackables, {node = node, process = {
    title = "Current",
    ID_NAME = "current",
  }})

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
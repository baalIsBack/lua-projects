local Super = require 'applications.dummy.gui.windows.Process'
local Self = Super:clone("AntivirusWindow")

Self.ID_NAME = "antivirus"

function Self:init(args)
  args.w = 320
  args.h = 240
  Super.init(self, args)
  


  self.virus_count_text = require 'engine.gui.Text':new{
    main = self.main,
    x = -self.w/2 +6,
    y = -self.h/2+8 + 16,
    text = "Virus count: 0",
    alignment = "left",
  }
  self:insert(self.virus_count_text)

  self.progressbar = require 'engine.gui.ProgressBar':new{
    main= self.main,
    x = 0,
    y = self.h/2-16,
    w = self.w-16,
    h = 16,
    speed = self.main.values:getVirusFinderSpeed(),
  }
  self.progressbar.callbacks:register("onFilled", function(selff)
    if self.main.values:get("virus_value") > 0 then
      self.main.values:inc("virus_value", -1)
      self.main.values:inc("virus_found", 1)
    end
  end)
  self:insert(self.progressbar)

  self.callbacks:register("update", function(self, dt)
    self.progressbar:setSpeed(self.main.values:getVirusFinderSpeed())
  end)


  local scan_button = require 'engine.gui.Button':new{
    main = self.main,
    x = 0,
    y = self.h/2-32-8,
    w = 32,
    h = 16,
    text = "Scan",
  }
  self:insert(scan_button)
  scan_button.callbacks:register("onClicked", function(selff)
    if not self.progressbar:isRunning() then
      self.progressbar:setProgress(0)
    end
    self.progressbar:start()
  end)




  local remove_button = require 'engine.gui.Button':new{
    main = self.main,
    x = -64,
    y = self.h/2-32-8,
    h = 16,
    text = "Remove",
  }
  self:insert(remove_button)
  remove_button.callbacks:register("onClicked", function(selff)
    --print()
    local virus_level, virus_amount = self.main.antivirus:getVirusHardness()
    self.main.processes:openProcess(self.main.processes.battle)
    self.main.processes.battle.battle:startBattle()
    self.main.processes.battle:setVirusLevel(virus_level)
    self.main.processes.battle:setVirusAmount(virus_amount)

    
    
    --self.battle:startBattle()
    --self:reloadText()
    --attack_button.enabled = true
    --defend_button.enabled = true
    --regen_button.enabled = true
  end)




  

  
  self.callbacks:register("update", function(self)
    self.virus_count_text:setText("Virus count: " .. self.main.values:get("virus_found"))
  end)
  
  self:insert(require 'applications.dummy.gui.elements.Virus':new{
    main = self.main,
    x = 0,
    y = 0,
  })
  --self.list:insert(t)
  return self
end


function Self:draw()
  if not self:isReal() then
    return
  end
  local a = self.main.antivirus:getVirusHardness()
  self:applySelectionColorTransformation()
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
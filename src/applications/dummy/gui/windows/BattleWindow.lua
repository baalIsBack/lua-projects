local Super = require 'applications.dummy.gui.windows.Process'
local Self = Super:clone("BattleWindow")

Self.ID_NAME = "battle"

function Self:init(args)
  args.w = 48*3
  args.h = 240
  Super.init(self, args)
  


  


  self.battle = require 'applications.dummy.system.Battle':new{
    main = self.main,
  }

  self.virus_amount = 0

  

  local wh = 48
  local offset_x = wh/2
  local offset_y = -40


  local choice1_button = require 'engine.gui.Button':new{
    main = self.main,
    x = offset_x-wh*3/2,
    y = offset_y-wh/2,
    w = wh,
    h = wh,
    text = "Study",
  }
  self:insert(choice1_button)
  choice1_button.callbacks:register("onClicked", function(selff)
    print( self.battle.sum_values_player)
    self.battle:doRound("coop")
    print( self.battle.sum_values_player)

    self:reloadText()
  end)
  self.choice1_button = choice1_button

  local choice2_button = require 'engine.gui.Button':new{
    main = self.main,
    x = offset_x-wh*3/2,
    y = offset_y-wh/2 + wh,
    w = wh,
    h = wh,
    text = "Purge",
  }
  self:insert(choice2_button)
  choice2_button.callbacks:register("onClicked", function(selff)
    self.battle:doRound("defect")
    self:reloadText()
  end)
  self.choice2_button = choice2_button

  local choice3_button = require 'engine.gui.Button':new{
    main = self.main,
    x = offset_x-wh/2,
    y = offset_y-wh/2 -wh*2/3,
    w = wh,
    h = wh/3,
    text = "Idle",
    enabled = false,
  }
  self:insert(choice3_button)

  local choice4_button = require 'engine.gui.Button':new{
    main = self.main,
    x = offset_x+wh/2,
    y = offset_y-wh/2 -wh*2/3,
    w = wh,
    h = wh/3,
    text = "Infect",
    enabled = false,
  }
  self:insert(choice4_button)


  local payout1_textfield = require 'engine.gui.TextField':new{
    main = self.main,
    x = offset_x-wh/2,
    y = offset_y-wh/2,
    w = wh,
    h = wh,
    input = self.battle.values.a .. " XP\n" .. self.battle.values.b .. " Inf",
    enabled = false,
    accepting_input = false,
  }
  self:insert(payout1_textfield)

  local payout2_textfield = require 'engine.gui.TextField':new{
    main = self.main,
    x = offset_x+wh/2,
    y = offset_y-wh/2,
    w = wh,
    h = wh,
    input = self.battle.values.c .. " XP\n" .. self.battle.values.d .. " Inf",
    enabled = false,
    accepting_input = false,
  }
  self:insert(payout2_textfield)

  local payout3_textfield = require 'engine.gui.TextField':new{
    main = self.main,
    x = offset_x-wh/2,
    y = offset_y+wh/2,
    w = wh,
    h = wh,
    input = self.battle.values.e .. " XP\n" .. self.battle.values.f .. " Inf",
    enabled = false,
    accepting_input = false,
  }
  self:insert(payout3_textfield)

  local payout4_textfield = require 'engine.gui.TextField':new{
    main = self.main,
    x = offset_x+wh/2,
    y = offset_y+wh/2,
    w = wh,
    h = wh,
    input = self.battle.values.g .. " XP\n" .. self.battle.values.h .. " Inf",
    enabled = false,
    accepting_input = false,
  }
  self:insert(payout4_textfield)



  
  self.round_text = require 'engine.gui.Text':new{
    main = self.main,
    x = -self.w/2 +2,
    y = 16+4,
    text = "Round: 1",
    alignment = "left",
  }
  self:insert(self.round_text)

  self.experience_text = require 'engine.gui.Text':new{
    main = self.main,
    x = -self.w/2 +2,
    y = 16+4+14,
    text = "XP: 0",
    alignment = "left",
  }
  self:insert(self.experience_text)

  self.virus_infection_text = require 'engine.gui.Text':new{
    main = self.main,
    x = -self.w/2 +2,
    y = 16+4+14*2,
    text = "Inf: 0",
    alignment = "left",
  }
  self:insert(self.virus_infection_text)

  self.virus_remainder_text = require 'engine.gui.Text':new{
    main = self.main,
    x = -self.w/2 +2,
    y = 16+4+14*3,
    text = "Virus: 0",
    alignment = "left",
  }
  self:insert(self.virus_remainder_text)



  self.callbacks:register("onActivate", function(self)
    self.battle:startBattle()
    self:reloadText()
  end)

  self.callbacks:register("update", function(self)
    self:reloadText()
  end)


  self.battle.callbacks:register("onGameOver", function(selff)
    self.main.values:inc("experience", self.battle.sum_values_player)
    self.main.values:set("virus_found", self:expectedRestViruses())
  end)


  
  return self
end

function Self:expectedRestViruses()
  local current_virus_found = self.main.values:get("virus_found")
  local new_virus_found = current_virus_found
  if self.battle.sum_values_bot > 0 then
    new_virus_found = current_virus_found + math.max(self.virus_amount + 1, self.virus_amount * (1.2+(self.battle.sum_values_bot / 1000)))
  else
    new_virus_found = current_virus_found - self.virus_amount * (1+(-self.battle.sum_values_bot / 1000))
    new_virus_found = math.max(0, new_virus_found)
  end
  return math.floor(new_virus_found)
end

function Self:reloadText()
  self.experience_text:setText("XP: " .. self.battle.sum_values_player)
  self.virus_infection_text:setText("Inf: " .. self.battle.sum_values_bot)
  self.round_text:setText("Round: " .. #self.battle.history +1)

  self.virus_remainder_text:setText("Virus: " .. self:expectedRestViruses())

  if self.battle:isOver() then
    self.choice1_button.enabled = false
    self.choice2_button.enabled = false
  end

  --self.enemyhp:setText("Enemy HP: " .. self.battle.enemy.hp)
  --self.playerhp:setText("Player HP: " .. self.battle.player.hp)
end

function Self:setVirusAmount(virus_amount)
  self.virus_amount = virus_amount
end

function Self:setVirusLevel(virus_level)
  self.battle:setLevel(virus_level)
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
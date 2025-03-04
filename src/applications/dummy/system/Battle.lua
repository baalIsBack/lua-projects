local Super = require 'engine.Prototype'
local Self = Super:clone("Battle")




function Self:init(args)--mail_prototype_id, id, read, reply)
  self.main = args.main
  self.hasCallbacks = true
  Super.init(self, args)
  
  self.values = {
    a = 20,
    b = 2,
    c = 10,
    d = 14,
    e = 0,
    f = -10,
    g = 0,
    h = -1,
  }

  self.sum_values_player = 0
  self.sum_values_bot = 0
  self.history = {}

  self.bot_type = "random"
  self.state = "running"

  self.callbacks:declare("onGameOver")
  self.callbacks:declare("onRoundOver")

  return self
end

function Self:getRoundNumber()
  return #self.history +1
end

function Self:isOver()
  return self.state == "over"
end

function Self:determinePossibleNextRound(chance)
  local chance = chance or 0.1
  local r = math.random(0, 10000000)/10000000
  if r >= chance then
    return true
  end
  self.state = "over"
  return false
end

function Self:setLevel(level)
  if level == 1 then
    self.bot_type = "good"
    self.values = {
      a = 20,
      b = 2,
      c = 10,
      d = 14,
      e = 0,
      f = -10,
      g = 0,
      h = -1,
    }
  elseif level == 2 then
    self.bot_type = "bad"
    self.values = {
      a = 20,
      b = 2,
      c = 10,
      d = 14,
      e = 0,
      f = -10,
      g = 0,
      h = -1,
    }
  elseif level == 3 then
    self.bot_type = "bad"
    self.values = {
      a = 20,
      b = 2,
      c = 10,
      d = 14,
      e = 0,
      f = -10,
      g = 0,
      h = -1,
    }
  else
    self.bot_type = "random"
    self.values = {
      a = 20,
      b = 2,
      c = 10,
      d = 14,
      e = 0,
      f = -10,
      g = 0,
      h = -1,
    }
  end
end

function Self:doRound(playeraction)
  if self:isOver() then
    return
  end
  local botaction = self:determineBotAction()
  if playeraction == "coop" and botaction == "coop" then
    self.sum_values_player = self.sum_values_player + self.values.a
    self.sum_values_bot = self.sum_values_bot + self.values.b
  elseif playeraction == "coop" and botaction == "defect" then
    self.sum_values_player = self.sum_values_player + self.values.c
    self.sum_values_bot = self.sum_values_bot + self.values.d
  elseif playeraction == "defect" and botaction == "coop" then
    self.sum_values_player = self.sum_values_player + self.values.e
    self.sum_values_bot = self.sum_values_bot + self.values.f
  elseif playeraction == "defect" and botaction == "defect" then
    self.sum_values_player = self.sum_values_player + self.values.g
    self.sum_values_bot = self.sum_values_bot + self.values.h
  else
    print(playeraction, botaction)
    unknown_action()
  end
  self:log(playeraction, botaction)
  if self:getRoundNumber() > 10 then
    if not self:determinePossibleNextRound() then
      self.callbacks:call("onGameOver", {self, self.sum_values_player, self.sum_values_bot})
    end
    return
  end
  self.callbacks:call("onRoundOver", {self, self.sum_values_player, self.sum_values_bot})
end

function Self:log(playeraction, botaction)
  table.insert(self.history, {playeraction, botaction})
end

function Self:determineBotAction()
  if self.bot_type == "good" then
    return "coop"
  elseif self.bot_type == "bad" then
    return "defect"
  elseif self.bot_type == "random" then
    if math.random(0, 1) == 0 then
      return "coop"
    else
      return "defect"
    end
  else
    unknown_bot_type()
  end
end

function Self:startBattle()
  self.sum_values_p1 = 0
  self.sum_values_p2 = 0
  self.history = {}
  self.state = "running"
end




return Self
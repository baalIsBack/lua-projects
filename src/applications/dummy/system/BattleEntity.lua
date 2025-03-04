local Super = require 'engine.Prototype'
local Self = Super:clone("BattleEntity")


function Self:init(args)
  self.main = args.main
  Super.init(self, args)
  self.opponent = args.opponent

  self.hp = args.hp or 100

  self.damage_addition = args.damage_addition or 0
  self.damage_multiplier = args.damage_multiplier or 1
  self.damage_more = args.damage_more or 1
  self.damage_value = args.damage_value or 1

  self.block_addition = args.block_addition or 0
  self.block_multiplier = args.block_multiplier or 1
  self.block_more = args.block_more or 1
  self.block_value = args.block_value or 0
  self.block_regen = args.block_regen or 0
  self.block_degen_perc = args.block_degen_perc or 1

  self.speed_addition = args.speed_addition or 0
  self.speed_multiplier = args.speed_multiplier or 1
  self.speed_more = args.speed_more or 1
  self.speed_value = args.speed_value or 1


  return self
end

function Self:newRound()
  self:degenBlock()
  self:regenBlock()
end

function Self:block(block_strength)
  self.block_value = self.block_value + self:calculateBlock(block_strength or 1)
end

function Self:attack(attack_strength)
  self.block_value = self.block_value + self:calculateDamage(attack_strength or 1)
end

function Self:degenBlock()
  self.block_value = self.block_value - self.block_value * self.block_degen_perc
  if self.block_value < 0 then self.block_value = 0 end
end

function Self:calculateBlock(base)
  return (base + self.block_addition) * self.block_multiplier * self.block_more
end

function Self:calculateSpeed(base)
  return (base + self.speed_addition) * self.speed_multiplier * self.speed_more
end

function Self:regenBlock()
  self.block_value = self.block_value + self:calculateBlock(self.block_regen)
  if self.block_value < 0 then self.block_value = 0 end
end

function Self:calculateDamage(base)
  return (base + self.damage_addition) * self.damage_multiplier * self.damage_more
end

return Self
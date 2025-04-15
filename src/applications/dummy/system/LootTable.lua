local Super = require 'engine.Prototype'
local Self = Super:clone("LootTable")

function Self:init(args)
  Super.init(self, args)

  self.minAmount = args.minAmount or 0
  self.maxAmount = args.maxAmount or 1
  self.loot = args.loot or {}
  self.requiredLoot = args.requiredLoot or {}

  return self
end

return Self
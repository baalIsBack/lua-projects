local Super = require 'engine.Prototype'
local Self = Super:clone("FileManager")

local lootTableDefinitions = require 'src.applications.dummy.system.LootTableDefinitions'
local lootTables, namedLootTables = lootTableDefinitions[1], lootTableDefinitions[2]


function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  Super.init(self)
  
  self.currentcontents = nil

  self.lootTable = namedLootTables["folder"]

  self.alias_table = nil

  self:determineContents()

  return self
end

function Self:setLootTable(name)
  assert(namedLootTables[name], "Loot table not found: " .. name)
  self.lootTable = namedLootTables[name]
end

function Self:determineContentQuantity()
  local r = math.random(self.lootTable.minAmount, self.lootTable.maxAmount * self.main.values:get("files_icon_quantity"))
  return r
end

function Self:determineContents()
  self:reloadAliasTable()
  self.currentcontents = {}
  for i=1, self:determineContentQuantity(), 1 do
    local lootID = self.alias_table()
    local content = self.lootTable.loot[lootID].content
    local amount = math.random(self.lootTable.loot[lootID].amountMin, self.lootTable.loot[lootID].amountMax)
    
    for j=1, amount, 1 do
      local loot = content
      if loot then
        table.insert(self.currentcontents, loot)
      end
    end
  end
  print(#self.lootTable.requiredLoot)

  for i, loot in ipairs(self.lootTable.requiredLoot) do
    local amount = math.random(loot.amountMin, loot.amountMax)
    for j=1, amount, 1 do
      if loot then
        table.insert(self.currentcontents, loot.content)
      end
    end
  end


  local table_shuffle = require 'lib.shuffle'
  table_shuffle(self.currentcontents)

  return self.currentcontents
end

function Self:reloadAliasTable()
  local alias_t = {}
  for i, v in ipairs(self.lootTable.loot) do
    table.insert(alias_t, v.weight)
  end
  self.alias_table = require 'lib.alias_table':new(alias_t)
  
end

function Self:serialize()
  local t = {
    
  }
  return t
end

function Self:deserialize(raw)
  
  return self
end



return Self
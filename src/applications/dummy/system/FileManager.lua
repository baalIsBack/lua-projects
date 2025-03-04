local Super = require 'engine.Prototype'
local Self = Super:clone("FileManager")

local function makeLoot(content, weight, amountMin, amountMax)
  return {content = content, weight = weight, amountMin = amountMin, amountMax = amountMax,}
  
end

function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  Super.init(self)
  
  self.currentcontents = nil

  self.lootTable = {}
  table.insert(self.lootTable, makeLoot("Icon_Folder", 500, 1, 1))
  table.insert(self.lootTable, makeLoot("Icon_File_Document", 2500, 0, 1))
  table.insert(self.lootTable, makeLoot("Icon_Brick", 2500, 1, 1))
  table.insert(self.lootTable, makeLoot("Icon_File_Image", 2500, 1, 1))
  table.insert(self.lootTable, makeLoot("Icon_Mail", 10, 1, 1))
  table.insert(self.lootTable, makeLoot("Icon_Terminal", 10, 1, 1))
  table.insert(self.lootTable, makeLoot("Icon_Program", 1000, 1, 1))
  table.insert(self.lootTable, makeLoot("Icon_Archive", 1000, 1, 1))

  self.alias_table = nil

  self:determineContents()

  return self
end

function Self:determineContentQuantity()
  return math.random(0, self.main.values:get("files_icon_quantity"))
end

function Self:determineContents()
  self:reloadAliasTable()
  self.currentcontents = {}
  for i=1, self:determineContentQuantity(), 1 do
    local lootID = self.alias_table()
    local content = self.lootTable[lootID].content
    local amount = math.random(self.lootTable[lootID].amountMin, self.lootTable[lootID].amountMax)
    
    for j=1, amount, 1 do
      local loot = content
      if loot then
        table.insert(self.currentcontents, loot)
      end
    end
  end
  return self.currentcontents
end

function Self:reloadAliasTable()
  local alias_t = {}
  for i, v in ipairs(self.lootTable) do
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
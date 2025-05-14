local Super = require 'engine.Prototype'
local Self = Super:clone("FileManager")

local lootTableDefinitions = require 'src.applications.dummy.system.LootTableDefinitions'
local lootTables, namedLootTables = lootTableDefinitions[1], lootTableDefinitions[2]


function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  Super.init(self)
  
  self.currentcontents = {}

  

  return self
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
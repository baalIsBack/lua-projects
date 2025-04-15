
local lootTables = {}
local namedLootTables = {}

local LootTable = require 'applications.dummy.system.LootTable'

local function makeLootTable(name, t_args)
  local t = LootTable:new(t_args)
  table.insert(lootTables, t)
  namedLootTables[name] = t
end

local function makeLoot(content, weight, amountMin, amountMax)
  if amountMax then
    return {content = content, weight = weight, amountMin = amountMin, amountMax = amountMax,}
  end
end



makeLootTable("folder", {minAmount = 0, maxAmount = 4, loot = {
  makeLoot("Icon_File_Text", 1200, 1, 1),
  makeLoot("Icon_Folder", 500, 1, 1),
  makeLoot("Icon_File_System", 2500, 1, 1),
  makeLoot("Icon_File_Archive", 100, 1, 1),
}, requiredLoot = {
  makeLoot("Icon_Folder", -1, 1, 1),
}})

makeLootTable("zip", {minAmount = 1, maxAmount = 3, loot = {
  makeLoot("Icon_File_Text", 1200, 1, 1),
  makeLoot("Icon_Folder", 100, 1, 1),
  makeLoot("Icon_File_Document", 50, 1, 1),
  makeLoot("Icon_File_Image", 50, 1, 1),
}, requiredLoot = {
  makeLoot("Icon_Folder", -1, 1, 1),
  makeLoot("Icon_File_Document", -1, 1, 1),
}})

makeLootTable("test", {minAmount = 10, maxAmount = 10, loot = {
  makeLoot("Icon_File_Text", 1000, 1, 1),
  makeLoot("Icon_Folder", 500, 1, 1),
  makeLoot("Icon_File_Document", 2500, 1, 1),
  makeLoot("Icon_File_System", 2500, 1, 1),
  makeLoot("Icon_File_Image", 2500, 1, 1),
  makeLoot("Icon_Mail", 10, 1, 1),
  makeLoot("Icon_Terminal", 10, 1, 1),
  makeLoot("Icon_Program", 1000, 1, 1),
  makeLoot("Icon_File_Archive", 1000, 1, 1),
  makeLoot("Icon_File_Certificate", 1000, 1, 1),
  makeLoot("Icon_File_Channel", 1000, 1, 1),
  makeLoot("Icon_File_Cinematic", 1000, 1, 1),
  makeLoot("Icon_File_Colorprofile", 1000, 1, 1),
  makeLoot("Icon_File_Config", 1000, 1, 1),
  makeLoot("Icon_File_Disc", 1000, 1, 1),
  makeLoot("Icon_File_Drawing", 1000, 1, 1),
  makeLoot("Icon_File_Font", 1000, 1, 1),
  makeLoot("Icon_File_Gesture", 1000, 1, 1),
  makeLoot("Icon_File_Music", 1000, 1, 1),
  makeLoot("Icon_File_OS", 1000, 1, 1),
  makeLoot("Icon_File_Sound", 1000, 1, 1),
  makeLoot("Icon_File_Text", 1000, 1, 1),
  makeLoot("Icon_File_Tip", 1000, 1, 1),
  makeLoot("Icon_File_TTFont", 1000, 1, 1),
  makeLoot("Icon_File_Video", 1000, 1, 1),
  makeLoot("Icon_File_Webdoc", 1000, 1, 1),
  makeLoot("Icon_Folder_Channel", 1000, 1, 1),
}, requiredLoot = {
  makeLoot("Icon_Folder", -1, 1, 1),
  makeLoot("Icon_File_Archive", -1, 1, 1),
}})



return {lootTables, namedLootTables}
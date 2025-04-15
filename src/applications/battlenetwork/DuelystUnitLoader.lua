local Super = require 'engine.Prototype'
local Self = Super:clone("DuelystLoader")

local json = require 'engine.json'

function Self:init(args)
  Super.init(self, args)


  self.pngFiles, self.jsonFiles = self:checkAllFiles()


  return self
end

function Self:checkAllFiles()
  local defaultUnitPath = "submodules/lua-projects-private/gfx/duelyst/troopAnimations"
  local allFiles = love.filesystem.getDirectoryItems(defaultUnitPath)
  --filter files ending in .png and .json into two tables
  local pngFiles = {}
  local jsonFiles = {}
  for i, file in ipairs(allFiles) do
    if string.find(file, ".png") then
      table.insert(pngFiles, file)
    elseif string.find(file, ".json") then
      table.insert(jsonFiles, file)
    end
  end
  return pngFiles, jsonFiles
end

function Self:loadByName(unitName)
  for i, name in ipairs(self.pngFiles) do
    if name == unitName .. ".png" then
      return self:loadByID(i)
    end
  end
  print("ERROR: Could not load Duelyst Asset: " .. unitName)
  asdff()
end

--prints names and how many
--DEPRECATED should work but unused
function Self:check()
  local sums = {}
  print("CHECK START")
  for _alpha, unitName in ipairs(self.pngFiles) do
    local defaultUnitPath = "submodules/lua-projects-private/gfx/duelyst/troopAnimations"
    local unitName = unitName:sub(1, -5)
    
    local jsonFile, error = love.filesystem.read(defaultUnitPath .. "/" .. unitName .. ".plist.json")
    local jsonTable = json.decode(jsonFile)

    for name, anim in pairs(jsonTable.lists) do
      sums[name] = (sums[name] or 0) + 1
    end
  end
  print("CHECK DONE")
  show(sums)
  print("CHECK END")

end

function Self:loadByID(unitName)
  local defaultUnitPath = "submodules/lua-projects-private/gfx/duelyst/troopAnimations"
  local unitName = self.pngFiles[unitName]:sub(1, -5)
  
  local image = love.graphics.newImage(defaultUnitPath .. "/" .. unitName .. ".png")
  local jsonFile, error = love.filesystem.read(defaultUnitPath .. "/" .. unitName .. ".plist.json")
  local jsonTable = json.decode(jsonFile)

  local animationNames = {}

  local sprites = {}
  local spritesByName = {}

  for name, anim in pairs(jsonTable.lists) do
    table.insert(animationNames, name)
    local quads = {}
    for i, frame in ipairs(anim) do
      table.insert(quads, love.graphics.newQuad(frame.x, frame.y, jsonTable.frameWidth, jsonTable.frameHeight, image:getDimensions()))
    end

    local spr = require 'engine.Sprite':new{
      fps = 1.5 * (1000/jsonTable.frameDuration),
      loop = true,
      quads = quads,
      offsetX = jsonTable.extraX,
      offsetY = jsonTable.extraY,
      img = image,
    }
    table.insert(sprites, spr)
    spritesByName[name] = spr
  end
  return sprites, spritesByName
end

function Self:load(what)
  if type(what) == "string" then
    return self:loadByName(what)
  elseif type(what) == "number" then
    return self:loadByID(what)
  end
end


return Self:new()
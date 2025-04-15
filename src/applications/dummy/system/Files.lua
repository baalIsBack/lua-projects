local Super = require 'engine.Prototype'
local Self = Super:clone("Files")



function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  Super.init(self)
  
  self.required_files = {}

  return self
end

function Self:add(file_name, chance)
  if not self.required_files[file_name] then
    self.required_files[file_name] = chance
  end
end

function Self:remove(file_name)
  if self.required_files[file_name] then
    self.required_files[file_name] = nil
  end
end

function Self:getRandomRequiredFile()
  local ls = {}
  for name, chance in pairs(self.required_files) do
    if chance ~= nil then
      table.insert(ls, {name, chance})
      print("aaa", name, chance)
    end
  end
  local result = ls[math.random(1, #ls)]
  if result == nil then
    return nil, nil
  end
  return result[1], result[2]
end

function Self:serialize()
  local t = self.required_files
  return t
end

function Self:deserialize(raw)
  self.required_files = raw
  return self
end



return Self
local Super = require 'engine.Prototype'
local Self = Super:clone("Files")



function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  Super.init(self)
  
  self.required_files = {}

  return self
end

function Self:add(file_name)
  if not self.required_files[file_name] then
    self.required_files[file_name] = true
  end
end

function Self:remove(file_name)
  if self.required_files[file_name] then
    self.required_files[file_name] = nil
  end
end

function Self:getRandomRequiredFile()
  local ls = {}
  for k, v in pairs(self.required_files) do
    if v ~= nil then
      table.insert(ls, k)
    end
  end
  local a = ls[math.random(1, #ls)]
  return a
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
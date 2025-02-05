local Super = require 'engine.Prototype'
local Self = Super:clone("Flags")


local CALLBACKS = {
  a = function(self, flag_name)
    print(1)
  end,
  flag1 = function(self, flag_name)
    print(2)
  end,
}

function Self:init(args)
  self.main = args.main
  self.hasSerialization = true
  Super.init(self)
  
  self.flags = {}

  self.manual_callbacks = CALLBACKS

  return self
end

function Self:set(flag_name)
  if not self.flags[flag_name] then
    self.flags[flag_name] = true
    if self.manual_callbacks[flag_name] then
      self.manual_callbacks[flag_name](self, flag_name)
    end
  end
end

function Self:checkList(ls)
  for i, v in ipairs(ls) do
    if not self.flags[v] then
      return false
    end
  end
  return true
end

--flags should be a convex hull of results; you can only add flags but never remove them(except for major reset)
function Self:unset(flag_name)
  error("flags should be a convex hull of results; you can only add flags but never remove them(except for major reset)")
  self.flags[flag_name] = nil
end

function Self:get(flag_name)
  return self.flags[flag_name]
end

function Self:serialize()
  local t = self.flags
  return t
end

function Self:deserialize(raw)
  self.flags = raw
  return self
end



return Self
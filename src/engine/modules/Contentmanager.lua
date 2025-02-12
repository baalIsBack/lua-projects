local Super = require 'engine.Prototype'
local Self = Super:clone("Contentmanager")


function Self:init()
  Super.init(self)

  self.content_list = {}
  
  return self
end

function Self:insert(obj, id)
  if id then
    table.insert(self.content_list, id, obj)
  else
    table.insert(self.content_list, obj)
  end
end

function Self:contains(element)
  return CONTAINS(self.content_list, element)
end

function Self:remove(obj)
  if type(obj) == "number" then
    if #self.content_list >= obj then
      table.remove(self.content_list, obj)
    else
      error()
    end
  end
  for i = #self.content_list, 1, -1 do
    if self.content_list[i] == obj then
      table.remove(self.content_list, i)
      return true
    end
  end
  return false
end

function Self:forall(f, ...)
  for i, v in ipairs(self.content_list) do
    f(v, ...)
  end
end

function Self:callall(f_name, ...)
  for i, v in ipairs(self.content_list) do
    v[f_name](v, ...)
  end
end

function Self:isEmpty()
  return #self.content_list == 0
end

function Self:removeall(f)
  local v
  for i = #self.content_list, 1, -1 do
    v = self.content_list[i]
    if f(v) then
      table.remove(self.content_list, i)
    end
  end
end

function Self:all(f_name, ...)
  local accumulator = true
  for i, v in ipairs(self.content_list) do
    accumulator = accumulator and v[f_name](v, ...)
  end
  return accumulator
end

function Self:any(f_name, ...)
  if (#self.content_list == 0) then
    return false
  end
  for i, v in ipairs(self.content_list) do
    if v[f_name](v, ...) then
      return true
    end
  end
  return false
end

function Self:getList()
  return self.content_list
end


return Self



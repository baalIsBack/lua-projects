local Prototype = require 'engine.Prototype'
local Stack = Prototype:clone("Stack")


--Methods
function Stack:init()
  self.contents = {}
  return self
end

function Stack:shuffle()
  for i = #self.contents, 2, -1 do
    local j = math.random(i)
    self.contents[i], self.contents[j] = self.contents[j], self.contents[i]
  end
  return self
end

function Stack:push(element)
  table.insert(self.contents, element)
  return self
end

function Stack:pop()
  self:assertNotEmpty()
  table.remove(self.contents, self:index())
  return self
end

--Functions
function Stack:peek()
  self:assertNotEmpty()
  return self.contents[self:index()]
end

function Stack:index()
  return #self.contents
end

function Stack:isEmpty()
  return self:index() == 0
end

function Stack:assertNotEmpty()
  assert(not self:isEmpty(), "Can not access elements of empty Stack.")
  return self
end

return Stack

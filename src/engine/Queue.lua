local Stack = require 'engine.Stack'
local Queue = Stack:clone("Queue")

--- Queue implementation using Stack with modified index
-- @module Queue


--Functions
function Queue:index()
  return math.min(1, #self.contents)
end

return Queue

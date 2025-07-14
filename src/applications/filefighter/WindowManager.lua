local Super = require 'engine.Prototype'
local Self = Super:clone("WindowManager")


function Self:init(args)
  self.hasContents = true
  self.main = args.main or require 'engine.Main'
  Super.init(self, args)

  
  return self
end

function Self:makeWindow(prototype, args)
  if prototype.UNIQUE and self:hasWindow(prototype) then
    return
  end
  local window = prototype:new(args)
  self.main.desktop.contents:insert(window)
end

function Self:hasWindow(prototype)
  for _, window in ipairs(self.main.desktop.contents.content_list) do
    if window:super() == prototype then
      return true
    end
  end
  return false
end



return Self

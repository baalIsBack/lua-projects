local Super = require 'engine.Prototype'
local Self = Super:clone("Explorer")



function Self:init(args)
  self.hasContents = true
  self.main = args.main
  Super.init(self, args)

  
  
  
	return self
end

function Self:add(file)
  if not file then
    return
  end
  if not self.main.explorerWindow then
    self.contents:insert(file)
  end
end



return Self

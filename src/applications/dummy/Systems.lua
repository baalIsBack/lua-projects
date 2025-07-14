local Super = require 'engine.Prototype'
local Self = Super:clone("Systems")



function Self:init(args)
  self.main = args.main
  Super.init(self)

  self.filemanager = require 'applications.dummy.system.FileManager':new{main=self}
  
  
  return self
end



return Self
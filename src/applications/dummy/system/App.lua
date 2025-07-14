local Super = require 'engine.Prototype'
local Self = Super:clone("App")


Self.INTERNAL_ID = "app"
Self.DISPLAY_NAME = "App"

function Self:init(args)
  self.main = args.main  
  Super.init(self, args)

  self.icon_prototype = args.icon_prototype
  self.window_prototype = args.window_prototype

  
	return self
end

function Self:makeIcon()
  local icon_instance = self.icon_prototype:new{
    main = self.main,
  }
  return icon_instance
end

function Self:makeWindow()
  local window_instance = self.window_prototype:new{
    main = self.main,
  }
  return window_instance
end

return Self

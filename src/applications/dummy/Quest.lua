local Super = require 'engine.Prototype'
local Self = Super:clone("Quest")

local SFX_NEW_MAIL = love.audio.newSource("submodules/lua-projects-private/sfx/Blip_Select4.wav", "static")





function Self:init(args)
  self.main = args.main
  self.hasCallbacks = true
  Super.init(self)


  self.source_quests = args.source_quests or {}
  self.unlocked = args.unlocked or false
  self.questType = args.questType or 0
  self.construction_args = args.construction_args or {}
  self.target_quests = args.target_quests or {}
  self.resolved = args.resolved or false

  return self
end

function Self:save() end
function Self:load(prototype) end
  


return Self
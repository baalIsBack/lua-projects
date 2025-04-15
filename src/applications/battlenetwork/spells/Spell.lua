local Super = require 'engine.Prototype'
local Self = Super:clone("Spell")

local IMG_ICONS = love.graphics.newImage("submodules/lua-projects-private/gfx/ro_skills.png")

function Self:init(args)
  Super.init(self, args)

  self.battle = args.battle
  self.img = IMG_ICONS
  self.quad = love.graphics.newQuad(math.random(0, 10)*24, math.random(0, 10)*24, 24, 24, IMG_ICONS:getDimensions())

  return self
end

function Self:effect(caster)
  caster.hp = caster.hp + 100
end


return Self
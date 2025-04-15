local Super = require 'engine.gui.Node'
local Self = Super:clone("Virus")

--local IMG_VIRUS = love.graphics.newImage("submodules/lua-projects-private/gfx/spider.png")--w98_game_spider-0.png,w98_game_mine_1-0.png
local IMG_VIRUS = love.graphics.newImage("submodules/lua-projects-private/gfx/Mini Pixel Pack 3/Enemies/Alan (16 x 16).png")--w98_game_spider-0.png,w98_game_mine_1-0.png



-- Returns a normalized 2D vector from an angle
local function angleToVector(angle)
    return {
        x = math.cos(angle),
        y = math.sin(angle)
    }
end

Self.VIRUS_VALUE = 1

function Self:init(args)
  Super.init(self, args)

  self.cage = args.cage

  self.img = IMG_VIRUS

  self.w = 16
  self.h = 16

  self.callbacks:declare("onKill")


  

  self.callbacks:register("onKill", function(self)
    self.main.values:inc("virus_found", -self.VIRUS_VALUE)
    self:markForDeletion()
    self:makeExplosion()
  end)
  self.callbacks:register("onMousePressed", function(self)
    self.callbacks:call("onKill", {self})
  end)
  
  self.callbacks:register("update", function(self, dt)
    self.animation:update(dt)
  end)
  
  

	return self
end


function Self:draw()
  if not self:isReal() then
    return
  end
  self:applySelectionColorTransformation()
  
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  

  love.graphics.setLineWidth(2)

  love.graphics.draw(self.img, self.animation:getQuad(), -16/2, -16/2, 0, 1, 1, 0, 0)
  --love.graphics.rectangle("line", -self.w/2, -self.h/2, self.w, self.h)
  
  self.contents:callall("draw")

  love.graphics.pop()
end

function Self:makeExplosion()
  self.cage:insert(require 'applications.dummy.gui.elements.Explosion':new{
    main = self.main,
    cage = self.cage,
    x = self.x,
    y = self.y,
  })
end

return Self

local Super = require 'applications.dummy.gui.elements.viruses.Virus'
local Self = Super:clone("Alan")

local IMG_VIRUS = love.graphics.newImage("submodules/lua-projects-private/gfx/spider.png")--w98_game_spider-0.png,w98_game_mine_1-0.png
IMG_VIRUS = love.graphics.newImage("submodules/lua-projects-private/gfx/Mini Pixel Pack 3/Enemies/Alan (16 x 16).png")--w98_game_spider-0.png,w98_game_mine_1-0.png



-- Returns a normalized 2D vector from an angle
local function angleToVector(angle)
    return {
        x = math.cos(angle),
        y = math.sin(angle)
    }
end

function Self:init(args)
  Super.init(self, args)

  local quads = require 'engine.Animation':quadsFromSheet(IMG_VIRUS, 16, 16)
  self.animation = require 'engine.Animation':new(12, quads, true)
  self.animation:stop()
  self.direction = angleToVector(math.random()*math.pi*2)
  self.movespeed = 40



  self.bombCounter = 0
  
  self.callbacks:register("onHover", function(self, x, y)
    self.animation:play()
  end)
  self.callbacks:register("onMouseExit", function(self, x, y)
    self.animation:stop()
  end)
  self.animation.callbacks:register("finish", function(selff)
    self.animation:stop()
    self.callbacks:call("onKill", {self})
  end)
  self.callbacks:register("update", function(self, dt)
    self.x = self.x + self.direction.x * self.movespeed * dt
    self.y = self.y + self.direction.y * self.movespeed * dt

    local parent = self.parent

    if self.x + self.w/2 > parent.w/2 then
      self.direction.x = -self.direction.x
      self.x = self.x + self.direction.x * self.movespeed * dt
    end

    if self.x - self.w/2 < -parent.w/2 then
      self.direction.x = -self.direction.x
      self.x = self.x + self.direction.x * self.movespeed * dt
    end

    if self.y + self.h/2 > parent.h/2 then
      self.direction.y = -self.direction.y
      self.y = self.y + self.direction.y * self.movespeed * dt
    end

    if self.y - self.h/2 < -parent.h/2 then
      self.direction.y = -self.direction.y
      self.y = self.y + self.direction.y * self.movespeed * dt
    end
  end)

  


	return self
end



return Self

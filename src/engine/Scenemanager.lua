local Super = require 'engine.Prototype'
local Self = Super:clone("Scenemanager")



function Self:init()
	Super.init(self)

	self.scenes = {}
	self.ui_open = false
  self.activeSceneId = nil

	
	return self
end

function Self:register(scene_id, scene)
	self.scenes[scene_id] = scene
  if self.activeSceneId == nil then
    self.activeSceneId = scene_id
  end
end

function Self:draw()
	local active_scene = self:getActiveScene()
  if active_scene then
    active_scene:draw()
  end
end

function Self:update(dt)
  local active_scene = self:getActiveScene()
  if active_scene then
    active_scene:update(dt)
  end
end

function Self:keypressed(key, scancode, isrepeat)
  local active_scene = self:getActiveScene()
  if active_scene then
    active_scene:keypressed(key, scancode, isrepeat)
  end
end

function Self:textinput(text)
  local active_scene = self:getActiveScene()
  if active_scene then
    active_scene:textinput(text)
  end
end

function Self:getActiveScene()
	local x = self.scenes[self.activeSceneId]
	--assert(x, "No Active Scene for Scene!")
	return x
end

function Self:get(scene_id)
	local x = self.scenes[scene_id]
	assert(x, "No Scene found with id: " .. scene_id)
	return x
end

function Self:switch(scene_id)
	if not scene_id then
		scene_id = self.activeSceneId
	end
  local active_scene = self:getActiveScene()
	active_scene.callbacks:call(":deactivate", self:getActiveScene())
	self.activeSceneId = scene_id
  active_scene = self:getActiveScene()
	active_scene.callbacks:call("enable", self:getActiveScene())
end



return Self

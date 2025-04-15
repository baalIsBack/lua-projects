local Super = require 'engine.Prototype'
local Self = Super:clone("Animation")


local table = require 'engine.stable'

function Self:init(fps, quads, loop)
	self.hasJobs = true
	self.hasCallbacks = true
  Super.init(self)
	self.callbacks:declare("finish")

	self.running = true
	self.loop = true
	if loop ~= nil then
		self.loop = loop
	end
	self.quads = quads
	self.quad_id = 1

  self.fps = fps

	self.jobs:every(1 / fps, function(selff)
		if self.running then
			if self.quad_id == #self.quads then
				self.callbacks:call("finish", {self})
				if not self.loop then
          self:pause() -- avoid infinite loop through callbacks
					return
				end
			end
			self.quad_id = (self.quad_id % #self.quads) + 1
		end
	end, self)
	return self
end

function Self:setFps(fps)
  self.jobs:clear()
  self.jobs:every(1 / fps, function(selff)
		if self.running then
			if self.quad_id == #self.quads then
				self.callbacks:call("finish", {self})
				if not self.loop then
          self:pause() -- avoid infinite loop through callbacks
					return
				end
			end
			self.quad_id = (self.quad_id % #self.quads) + 1
		end
	end, self)
end

--[[
	Will load all images; TODO: rename function to represent behavior better
]]
function Self:quadsFromSheet(img, frameW, frameH) --
	local quads = {}
	for x = 0, (img:getWidth() / frameW) - 1, 1 do
		table.insert(quads,
			love.graphics.newQuad(x * frameW, 0 * frameH, frameW, frameH, img:getWidth(), img:getHeight()))
	end
	return quads
end

function Self:stop()
	self.running = false
	self.quad_id = 1
	return self
end

function Self:pause()
	self.running = false
	return self
end

function Self:play()
	self.running = true
	return self
end

function Self:restart()
	self.running = true
	self.quad_id = 1
	return self
end

function Self:reverse()
	table.reverse(self.quads)
	return self
end

function Self:update(dt)
	self.jobs:update(dt)
	return self
end

function Self:getQuad()
	return self.quads[self.quad_id]
end

function Self:isDone()
  return self.quad_id == #self.quads  
end

return Self

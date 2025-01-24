local Super = require 'engine.Prototype'
local Self = Super:clone("Jobs")


function Self:init()
	self.jobs = {}
	return self
end

function Self:update(dt)
	for i, j in ipairs(self.jobs) do
		j:update(dt)
	end
end

function Self:remove(job)
	for i, j in ipairs(self.jobs) do
		if j == job then
			table.remove(self.jobs, i)
			return true
		end
	end
	return false
end

function Self:insert(job)
	table.insert(self.jobs, job)
end

function Self:after(time, f, ...)
	local cron = require 'src.lib.cron'
	self:insert(cron.after(time, f, ...))
end

function Self:every(time, f, ...)
	local cron = require 'src.lib.cron'
	self:insert(cron.every(time, f, ...))
end

return Jobs

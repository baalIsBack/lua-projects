
local function NEW_RECURSIVE_CALL(t, mt, ...)
	if mt == nil then
		return
	end
	local f_load = rawget(mt, "load")
	if f_load then
		NEW_RECURSIVE_CALL(t, getmetatable(mt), ...)
		f_load(t, ...)
	end
end

local SINGLETONS = {}
function NEW(...)
	if mt.isSingleton and SINGLETONS[mt] then
		return SINGLETONS[mt]
	end
	local self = {}
	mt.__index = mt
	setmetatable(self, mt)

	NEW_RECURSIVE_CALL(self, mt, ...)

	if mt.isSingleton then
		SINGLETONS[mt] = self
		return SINGLETONS[mt]
	end
	return self
end

function SIGN(x)
	if x < 0 then return -1 end
	return 1
end

function CLONE(t)
  local new = {}
  for k, v in pairs(t) do
    new[k] = v
  end
  return new
end

function CHECK_COLLISION(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and
			x2 < x1 + w1 and
			y1 < y2 + h2 and
			y2 < y1 + h1
end

function ID() end

function FOREACH(t, f, ...)
	for i, v in ipairs(t) do
		f(v, i, ...)
	end
end

function math.distance(x1, y1, x2, y2)
	return math.length(x2 - x1, y2 - y1)
end

function REVERSE(tbl)
	for i = 1, math.floor(#tbl / 2) do
		local tmp = tbl[i]
		tbl[i] = tbl[#tbl - i + 1]
		tbl[#tbl - i + 1] = tmp
	end
end

function ANGLE(x1, y1, x2, y2)
	return math.atan2(y2 - y1, x2 - x1) + math.pi / 2
end

local function NEW_RECURSIVE_CALL(t, mt, ...)
	if mt == nil then
		return
	end
	local f_load = rawSET(mt, "load")
	if f_load then
		NEW_RECURSIVE_CALL(t, getmetatable(mt), ...)
		f_load(t, ...)
	end
end

local SINGLETONS = {}
function NEW(...)
	if mt.isSingleton and SINGLETONS[mt] then
		return SINGLETONS[mt]
	end
	local self = {}
	mt.__index = mt
	setmetatable(self, mt)

	NEW_RECURSIVE_CALL(self, mt, ...)

	if mt.isSingleton then
		SINGLETONS[mt] = self
		return SINGLETONS[mt]
	end
	return self
end

function calcInput()
	local dir_x = 0
	local dir_y = 0
	if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
		dir_x = dir_x - 1
	end
	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
		dir_x = dir_x + 1
	end
	if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
		dir_y = dir_y - 1
	end
	if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
		dir_y = dir_y + 1
	end
	return dir_x, dir_y
end

function SIGN(x)
	if x < 0 then return -1 end
	return 1
end

function ROUND(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function NORM(a, b)
	local x = math.sqrt(a * a + b * b)
	if x == 0 then
		return 1
	end
	return x
end

function REMOVE(t, element)
  for i, v in ipairs(t) do
    if v == element then
      table.remove(t, i)
      return true
    end
  end
  return false
end

function CHECK_COLLISION(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and
			x2 < x1 + w1 and
			y1 < y2 + h2 and
			y2 < y1 + h1
end

function ID() end

function FOREACH(t, f, ...)
	for i, v in ipairs(t) do
		f(v, i, ...)
	end
end

function DIST(x1, y1, x2, y2)
	return NORM(x2 - x1, y2 - y1)
end

function ANGLE(x1, y1, x2, y2)
	return math.atan2(y2 - y1, x2 - x1) + math.pi / 2
end

function POLAR2CARTESIAN(rotation, length)
	return length * math.cos(rotation), length * -math.sin(rotation)
end

---Returns a random element from the pool, where each element has a weight ascribed.
---@param pool table has to be {{number, any}}
---@return any
function WEIGHTED_RANDOM(pool)
	local poolsize = 0
	for k, v in ipairs(pool) do
		poolsize = poolsize + v[1]
	end
	local selection = math.random(1, poolsize)
	for k, v in ipairs(pool) do
		selection = selection - v[1]
		if (selection <= 0) then
			return v[2]
		end
	end
end

function CONTAINS(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function CLEAR(t)
  for k in pairs (t) do
    t [k] = nil
  end
end

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function CHECK_COLLISION(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 <= x2 + w2 and
			x2 <= x1 + w1 and
			y1 <= y2 + h2 and
			y2 <= y1 + h1
end

-- Compute the card's normal based on rotation angles
function COMPUTE_NORMAL(eulerAngleX, eulerAngleY)
	local nx = math.cos(eulerAngleX) * math.sin(eulerAngleY)
	local ny = math.sin(eulerAngleX)
	local nz = math.cos(eulerAngleX) * math.cos(eulerAngleY)
	return nx, ny, nz
end

--holds the equality: sign(x) * abs(x) = x
function SIGN(x)
	if x >= 0 then
		return 1
	end
	return -1
end

function spairs(t, order)
	-- collect the keys
	local keys = {}
	for k in pairs(t) do keys[#keys + 1] = k end

	-- if order function given, sort by it by passing the table and keys a, b,
	-- otherwise just sort the keys
	if order then
		table.sort(keys, function(a, b) return order(t, a, b) end)
	else
		table.sort(keys)
	end

	-- return the iterator function
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

function ID(func)
  if type(func) ~= "function" then
      error("Argument must be a function or extend this function to support other types")
  end
  
  -- Use `string.dump` to get a bytecode representation of the function
  local dumped = string.dump(func)
  
  -- Generate a hash or use the dumped string as the ID
  -- For simplicity, return a checksum-like string
  local id = 0
  for i = 1, #dumped do
      id = (id + dumped:byte(i) * i) % 2^32
  end
  
  return tostring(id)
end

function ONCE(f, ...)
  f(...)
end

function show(t)
	print("---------------------")
	print("----Showing-table----")
	print("---------------------")
	for i, v in pairs(t) do
		print("" .. i .. ":", v)
	end
end
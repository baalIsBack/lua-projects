local Super = require 'engine.Scene'
local Self = Super:clone("Main")

--totally reset random
math.randomseed(os.time())
math.random(); math.random(); math.random()


function uuid()
  local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  return string.gsub(template, "[xy]", function(c)
      local v = (c == "x") and math.random(0, 15) or math.random(8, 11)
      return string.format("%x", v)
  end)
end

function Self:init()
  Super.init(self)

  main = self

  math.randomseed(os.time())
  require 'engine.Screen':setScale(1, 1)


  self.multiplayer = require 'engine.Multiplayer':new(true, "localhost", 6750)
  self:insert(self.multiplayer)

  
  self.players = {}
  self.player = require 'applications.space.Player':new{}
  self.player:setOwner()
  
  -- Register callbacks before sending
  self.multiplayer.callbacks:register("onConnect", function(selff, peer)
    -- Send initial data after connection is confirmed
    self.multiplayer:send({
      self.player.serialization:serialize()
    })
  end)

  self.multiplayer.callbacks:register("onReceive", function(selff, data)
    for i, datapoint in ipairs(data) do
      self:processData(datapoint)
    end
  end)



  self.multiplayer:finalize()
  

  return self
end

function makeGameObject(data)
  local new_obj
  if data.type == "Player" then
    new_obj = require 'applications.space.Player':new{}
  elseif data.type == "Dummy" then
    new_obj = require 'applications.space.Dummy':new{}
  else
    new_obj = require 'applications.space.GameObject':new{}
  end
  new_obj.serialization:deserialize(data)
  return new_obj
end


function Self:processData(data)
  for index, value in ipairs(self.players) do

    if value.serialization.vals._netID == data._netID then
      --if exists
      value.serialization:deserialize(data)
      value.serialization:sync()
      
      return
    end
  end
  --if new
  local new_obj = makeGameObject(data)
  table.insert(self.players, new_obj)
end

function Self:sendAll()
  local all = {}
  for i, v in ipairs(self.players) do
    table.insert(all, v.serialization:serialize())
  end
  self.multiplayer:send(all)
end

function Self:draw()
  for i, player in ipairs(self.players) do
    player:draw()
  end
  self.contents:callall("draw")
end
local counter = 0
function Self:update(dt)
  counter = counter + dt
  local mx, my = require 'engine.Mouse':getPosition()

  self.multiplayer:listen()
  
  local syncs = {}
  local mustSync = self.multiplayer:sync()
  for i, obj in ipairs(self.players) do
    obj:update(dt)
    if counter > 0.02 and mustSync and obj.serialization:requiresSync() and obj:isClientControlled() then
      table.insert(syncs, obj.serialization:serialize())
      obj.serialization:sync()
    end
  end
  if #syncs > 0 and counter > 0.02 then
    self.multiplayer:send(syncs)
    counter = 0
  end
  --



  self.contents:callall("update", dt)
end

function Self:keypressed(key, scancode, isrepeat)
  self.contents:callall("keypressed", key, scancode, isrepeat)
end

function Self:textinput(text)
  self.contents:callall("textinput", text)
end

function Self:quit()
  self.contents:callall("quit")
end

function Self:insert(node)
  self.contents:insert(node)
  node.main = self
end

function Self:remove(node)
  self.contents:remove(node)
end

-- In Multiplayer.lua, change this function:
function Self:waitForConnection(maxTimeout)
  local timeWaited = 0
  local step = 10  -- Check every 10ms
  
  while not self.connected and timeWaited < maxTimeout do
    self:listen_client(step)
    timeWaited = timeWaited + step
    -- Remove this sleep that's causing the slowdown:
    -- love.timer.sleep(0.001)  
  end
  
  return self.connected
end

return Self



local Super = require 'engine.Prototype'
local Self = Super:clone("Multiplayer")

local enet = require "enet"
require 'lib.TSerial'


function Self:init(isHost, ip, port)
  self.hasCallbacks = true
  Super.init(self)

  self.callbacks:declare("onConnect")
  self.callbacks:declare("onReceive")
  self.callbacks:declare("onDisconnect")

  self.ip = ip or "localhost"
  self.port = port or 6750
  self.isHost = isHost
  self.clientID = uuid()
  self.debug = false
  self.connected = false  -- Track connection state

  self.maxSyncRate = 0.01  -- Maximum sync rate in seconds
  self.maxSyncRateCounter = 0  -- Counter for sync rate
  
  return self
end

function Self:sync()
  if self.maxSyncRateCounter >= self.maxSyncRate then
    --self:sendAll()
    self.maxSyncRateCounter = 0
    return true
  end
  return false
end

function Self:finalize_old()
  
  

  if self.isHost then
    
    self.server = enet.host_create(self.ip .. ":"..self.port)
    if self.debug then print("[DEBUG] Server created at " .. self.ip .. ":" .. self.port) end
  end

  self.host = enet.host_create()
  self.client = self.host:connect(self.ip .. ":"..self.port)
  if self.debug then print("[DEBUG] Client connecting to " .. self.ip .. ":" .. self.port) end
  
  -- Initial connection establishment
  if self.debug then print("[DEBUG] Waiting for connection...") end
  self:waitForConnection(100)  -- Wait up to 1 second for connection
  if self.debug then print("[DEBUG] Connection wait complete. Connected: " .. tostring(self.connected)) end
  
end

function Self:finalize()
  -- Step 1: Always create a client first and try to connect
  self.host = enet.host_create()
  self.client = self.host:connect(self.ip .. ":" .. self.port)
  if self.debug then print("[DEBUG] Attempting to connect to " .. self.ip .. ":" .. self.port) end
  
  -- Step 2: Wait briefly to see if connection succeeds
  local connectionTimeout = 100  -- 1 second timeout
  local connected = self:waitForConnection(connectionTimeout)
  
  -- Step 3: If connection failed and we're allowed to host, create a server
  if not connected and self.isHost then
    self.host:flush()  -- Ensure all outgoing packets are sent
    self.host:destroy()

    if self.debug then print("[DEBUG] Connection failed. Creating server instead.") end
    self.server = enet.host_create(self.ip .. ":" .. self.port)
    if self.debug then print("[DEBUG] Server created at " .. self.ip .. ":" .. self.port) end
    
    -- We're now the server, but still want to connect our client to it
    self.host = enet.host_create()
    self.client = self.host:connect(self.ip .. ":" .. self.port)
    if self.debug then print("[DEBUG] Client connecting to own server at " .. self.ip .. ":" .. self.port) end
    
    -- Wait for connection to our own server
    self:waitForConnection(connectionTimeout)
  else
    self.isHost = false
  end
  
  if self.debug then print("[DEBUG] Connection finalized. Connected: " .. tostring(self.connected)) end
end

function Self:waitForConnection(maxTimeout)
  local timeWaited = 0
  local step = 10  -- Check every 10ms
  
  while not self.connected and timeWaited < maxTimeout do
    self:listen_client(step)
    timeWaited = timeWaited + step
    love.timer.sleep(0.001)  -- Small sleep to avoid blocking
    if self.debug and timeWaited % 10 == 0 then 
      print("[DEBUG] Still waiting for connection... " .. timeWaited .. "ms elapsed") 
    end
  end
  
  return self.connected
end

function Self:listen(timeout)
  local timeout = timeout or 10
  self:listen_server(timeout)
  self:listen_client(timeout)
end

function Self:listen_server(timeout)
  if not self.isHost then
    return
  end
  local timeout = timeout or 10
  
  --local hostevent = self.server:service(timeout)

  local status, event = pcall(function() return self.server:service(timeout) end)
  local hostevent = event

  if not status then
    if self.debug then print("[DEBUG] Server ENet service error: " .. tostring(event)) end
  end

  if hostevent then
    if hostevent.type == "connect" then
      self.main:sendAll()
    elseif hostevent.type == "receive" and hostevent.data ~= 0 then
      -- Broadcast to all except sender
      if hostevent.peer ~= self.client then
        self.server:broadcast(hostevent.data)
      end
      
    elseif hostevent.type == "disconnect" then
    end
  end
  
  self.server:flush()
end

function Self:listen_client(timeout)
  local timeout = timeout or 10
  
  local hostevent = self.host:service(timeout)
  if hostevent then
    if self.debug then print("[DEBUG] Client received event: " .. hostevent.type) end
    
    if hostevent.type == "connect" then
      self.connected = true
      self.callbacks:call("onConnect", {self, hostevent.peer})
    elseif hostevent.type == "receive" and hostevent.data ~= 0 then
      self.callbacks:call("onReceive", {self, stringToTable((hostevent.data))})
    elseif hostevent.type == "disconnect" then
      self.connected = false
      self.callbacks:call("onDisconnect", {self, hostevent.peer})
    end
  end
  
  self.host:flush()
end

function Self:send(data)
  if self.debug then 
    print("[DEBUG] Sending data to server")
  end
  self.client:send((tableToString(data)))
  --self.host:flush()  -- Ensure all outgoing packets are sent
end


function Self:getPeers()
  if not self.server then
    return {}
  end  
  local peer_count = self.server:peer_count()
  local peers = {}
  for i=1, peer_count do
    table.insert(peers, self.server:get_peer(i))
  end
  return peers
end

function Self:quit()
  self.host:flush()
  self.host:destroy()
end

function Self:update(dt)
  self.maxSyncRateCounter = self.maxSyncRateCounter + dt
  self.host:flush()
end

return Self
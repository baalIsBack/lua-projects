local Super = require 'engine.Scene'
local Self = Super:clone("Main")

function superSend(shader, id, val)
  if shader:hasUniform(id) then
    shader:send(id, val)
  end
end

function Self:init()
  Super.init(self)
  
  -- Load the shadow shader
  self.shadowShader = love.graphics.newShader("shaders/ShadowVertex.love2d.glsl", "shaders/ShadowHighQualityFragment.love2d.glsl")
  
  -- Create a canvas for texture sampling
  local w, h = love.graphics.getDimensions()
  
  -- Set up object and light properties
  self.objectX = 400
  self.objectY = 300
  self.objectWidth = 100
  self.objectHeight = 150
  
  self.lightX = 400
  self.lightY = 100
  self.lightZ = 100
  self.lightRadius = 500
  
  -- Shadow parameters
  self.intensity = 0.5
  self.blurShiftModifier = 0.5
  self.blurIntensityModifier = 5.0
  
  -- Create proper transformation matrices
  self.modelViewMatrix = {
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, -500, 1  -- Move the camera back for perspective
  }
  
  self.projectionMatrix = {
    0.5, 0, 0, 0,   -- Scale X to create perspective
    -0.2, 0.7, 0.2, 0,  -- Add skew for shadow projection
    0, 0, -0.001, 0, -- Z-scaling
    0, 0, 0, 1
  }
  
  -- Create our shadow mesh
  self:createShadowMesh()
  
  -- Add a test mode flag
  self.testMode = 0 -- 0=complex shader, 1=vertex only, 2=fragment only, 3=minimal
  if self.testMode == 0 then
    self.shadowShader = love.graphics.newShader("shaders/ShadowVertex.love2d.glsl", "shaders/ShadowHighQualityFragment.love2d.glsl")
  elseif self.testMode == 1 then
    self.shadowShader = self:testVertexShader()
  elseif self.testMode == 2 then
    self.shadowShader = self:testFragmentShader()
  end
  
  return self
end

function Self:createShadowMesh()
  -- Create a mesh with the attributes needed by the shader
  local vertexFormat = {
    {"VertexPosition", "float", 4},  -- x, y, z, w
    {"VertexTexCoord", "float", 2},  -- u, v
    {"VertexColor", "byte", 4},      -- r, g, b, a
    {"OriginRadius", "float", 4}     -- light x, y, z, radius
  }
  
  -- Create a mesh for a single quad
  self.shadowMesh = love.graphics.newMesh(vertexFormat, 4, "fan", "dynamic")
  
  -- Initially set the vertices
  self:updateShadowMesh()
end

function Self:updateShadowMesh()
  -- Create vertices for a simple quad
  local x, y = self.objectX, self.objectY
  local w, h = self.objectWidth, self.objectHeight
  
  -- Set vertices with all required attributes
  self.shadowMesh:setVertex(1, {
    x, y, 0, 1,                 -- position
    0, 0,                       -- texCoord
    255, 255, 255, 255,         -- color
    self.lightX, self.lightY, self.lightZ, self.lightRadius -- light position & radius
  })
  
  self.shadowMesh:setVertex(2, {
    x + w, y, 0, 1,             -- position
    1, 0,                       -- texCoord
    255, 255, 255, 255,         -- color
    self.lightX, self.lightY, self.lightZ, self.lightRadius -- light position & radius
  })
  
  self.shadowMesh:setVertex(3, {
    x + w, y + h, 0, 1,         -- position
    1, 1,                       -- texCoord
    255, 255, 255, 255,         -- color
    self.lightX, self.lightY, self.lightZ, self.lightRadius -- light position & radius
  })
  
  self.shadowMesh:setVertex(4, {
    x, y + h, 0, 1,             -- position
    0, 1,                       -- texCoord
    255, 255, 255, 255,         -- color
    self.lightX, self.lightY, self.lightZ, self.lightRadius -- light position & radius
  })
end

function Self:draw()
  -- Clear the screen with a dark background
  love.graphics.clear(0.1, 0.1, 0.15)
  
  -- Draw a grid for better visualization
  love.graphics.setColor(0.3, 0.3, 0.3)
  for x = 0, love.graphics.getWidth(), 50 do
    love.graphics.line(x, 0, x, love.graphics.getHeight())
  end
  for y = 0, love.graphics.getHeight(), 50 do
    love.graphics.line(0, y, love.graphics.getWidth(), y)
  end
  

  
  -- Now draw the shadow using our shader

  
  -- Now draw the actual object
  love.graphics.setColor(1, 0.5, 0.2) -- Object color
  love.graphics.rectangle("fill", self.objectX, self.objectY, self.objectWidth, self.objectHeight)
  
  -- Draw the light position
  love.graphics.setColor(1, 1, 0) -- Yellow for light
  love.graphics.circle("fill", self.lightX, self.lightY, 10)
  
  -- Draw UI information
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Light: " .. math.floor(self.lightX) .. "," .. math.floor(self.lightY) .. "," .. math.floor(self.lightZ), 10, 10)
  love.graphics.print("Light Radius: " .. self.lightRadius, 10, 30)
  love.graphics.print("Intensity: " .. self.intensity, 10, 50)
  love.graphics.print("Blur Shift: " .. self.blurShiftModifier, 10, 70)
  love.graphics.print("Blur Intensity: " .. self.blurIntensityModifier, 10, 90)
  love.graphics.print("Controls: WASD = Move Object, Arrows = Move Light", 10, 120)
  love.graphics.print("Z/X = Light Height, C/V = Intensity, B/N = Blur", 10, 140)



    love.graphics.setShader(self.shadowShader)
  
  -- Set all required uniforms

  superSend(self.shadowShader, "ModelViewMatrix", self.modelViewMatrix)

  --superSend(self.shadowShader, "sProjectionMatrix", self.projectionMatrix)
  superSend(self.shadowShader, "u_size", {self.objectWidth, self.objectHeight})
  superSend(self.shadowShader, "u_anchor", {self.objectWidth/2, self.objectHeight})
  superSend(self.shadowShader, "u_intensity", self.intensity)
  superSend(self.shadowShader, "u_blurShiftModifier", self.blurShiftModifier)
  superSend(self.shadowShader, "u_blurIntensityModifier", self.blurIntensityModifier)
  
  -- Draw the shadow mesh
  love.graphics.setColor(1, 0, 1) -- Shadow alpha
  love.graphics.draw(self.shadowMesh)
  
  -- Turn off the shader
  love.graphics.setShader()
end

function Self:update(dt)
  -- Update light position based on mouse if mouse button is held
  if love.mouse.isDown(1) then
    self.lightX, self.lightY = love.mouse.getPosition()
    self:updateShadowMesh()
  end
end

function Self:keypressed(key, scancode, isrepeat)
  local moveDist = 10
  local changed = false
  
  -- Object movement
  if key == "w" then
    self.objectY = self.objectY - moveDist
    changed = true
  elseif key == "s" then
    self.objectY = self.objectY + moveDist
    changed = true
  elseif key == "a" then
    self.objectX = self.objectX - moveDist
    changed = true
  elseif key == "d" then
    self.objectX = self.objectX + moveDist
    changed = true
  end
  
  -- Light movement
  if key == "up" then
    self.lightY = self.lightY - moveDist
    changed = true
  elseif key == "down" then
    self.lightY = self.lightY + moveDist
    changed = true
  elseif key == "left" then
    self.lightX = self.lightX - moveDist
    changed = true
  elseif key == "right" then
    self.lightX = self.lightX + moveDist
    changed = true
  end
  
  -- Light height/radius adjustments
  if key == "z" then
    self.lightZ = math.max(10, self.lightZ - 10)
    changed = true
  elseif key == "x" then
    self.lightZ = self.lightZ + 10
    changed = true
  elseif key == "r" then
    self.lightRadius = math.max(100, self.lightRadius - 50)
    changed = true
  elseif key == "f" then
    self.lightRadius = self.lightRadius + 50
    changed = true
  end
  
  -- Shader parameter adjustments
  if key == "c" then
    self.intensity = math.max(0.1, self.intensity - 0.1)
    changed = true
  elseif key == "v" then
    self.intensity = math.min(1.0, self.intensity + 0.1)
    changed = true
  elseif key == "b" then
    self.blurShiftModifier = math.max(0.1, self.blurShiftModifier - 0.1)
    changed = true
  elseif key == "n" then
    self.blurShiftModifier = self.blurShiftModifier + 0.1
    changed = true
  elseif key == "m" then
    self.blurIntensityModifier = math.max(1.0, self.blurIntensityModifier - 1.0)
    changed = true
  elseif key == "," then
    self.blurIntensityModifier = self.blurIntensityModifier + 1.0
    changed = true
  end
  
  if key == "t" then
    self.testMode = (self.testMode + 1) % 3
    if self.testMode == 0 then
      self.shadowShader = love.graphics.newShader("shaders/ShadowVertex.love2d.glsl", "shaders/ShadowHighQualityFragment.love2d.glsl")
    elseif self.testMode == 1 then
      self.shadowShader = self:testVertexShader()
    elseif self.testMode == 2 then
      self.shadowShader = self:testFragmentShader()
    end
    print("Switched to test mode: " .. self.testMode)
  end
  
  -- Update mesh if anything changed
  if changed then
    self:updateShadowMesh()
  end
end

function Self:testVertexShader()
  
  return love.graphics.newShader("shaders/ShadowVertex.love2d.glsl")
end

function Self:testFragmentShader()
  
  return love.graphics.newShader("shaders/ShadowHighQualityFragment.love2d.glsl")
end

function Self:textinput(text)

end

return Self



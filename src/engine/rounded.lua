local rounded = {}

function rounded.line(loop, ...)
  local args = {...}
  if #args % 2 ~= 0 then
    error("roundedLine requires an even number of arguments")
  end
  local r = love.graphics.getLineWidth()/2
  for i = 1, #args, 2 do
    local x1, y1 = args[i], args[i+1]
    local x2, y2 = args[i+2] or x1, args[i+3] or y1
    love.graphics.circle("fill", x1, y1, r)
  end
  love.graphics.circle("fill", args[#args-1], args[#args], r, 67)
  if loop then
    table.insert(args, args[1])
    table.insert(args, args[2])
    love.graphics.line(args)
  else
    love.graphics.line(args)
  end
end

function rounded.circle(x, y, radius, segments)
  local startAngle, endAngle = 0, 2 * math.pi
  local points = {}
  for i = 0, segments do
      local angle = startAngle + (endAngle - startAngle) * (i / segments)
      table.insert(points, x + math.cos(angle) * radius)
      table.insert(points, y + math.sin(angle) * radius)
  end
  love.graphics.line(points)
end



return rounded
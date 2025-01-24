local sstring = {} --super string


function sstring.toFirstUpper(self)
  return (self:gsub("^%l", string.upper))
end

function sstring.toFirstLower(self)
  return (self:gsub("^%u", string.lower))
end

return sstring
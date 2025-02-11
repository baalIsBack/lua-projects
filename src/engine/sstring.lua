local sstring = {} --super string


function sstring.toFirstUpper(self)
  return (self:gsub("^%l", string.upper))
end

function sstring.toFirstLower(self)
  return (self:gsub("^%u", string.lower))
end

function sstring.sanitizeAscii(text)
  return text:gsub("[^%z\32-\126]", "") -- Remove all non-ASCII characters
end

local utf8offset=require("utf8").offset
local string_sub = string.sub
local select = select
sstring.ulen = require("utf8").len

function sstring.usub(s, start_in_chars, ...)
  local start_in_bytes = utf8offset(s, start_in_chars)
  if start_in_bytes == nil then
    start_in_bytes = #s + 1
    if start_in_chars < 0 then
      start_in_bytes = -start_in_bytes
    end
  end

  if select('#', ...) == 0 then -- no second arg
    return string_sub(s, start_in_bytes)
  end

  local end_in_chars = ...
  if end_in_chars == -1 then -- -1 doesn't go well with the +1 needed later
    return string_sub(s, start_in_bytes)
  end

  local end_in_bytes = utf8offset(s, end_in_chars + 1)
  if end_in_bytes == nil then
    end_in_bytes = #s + 1
    if end_in_chars < 0 then
      end_in_bytes = -end_in_bytes
    end
  end
  return string_sub(s, start_in_bytes, end_in_bytes - 1)
end

return sstring
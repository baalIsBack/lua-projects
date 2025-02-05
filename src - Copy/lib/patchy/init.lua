-- this is just a convenience file.
local current_folder = (...):gsub("%.init$", ""):gsub("%.", "/") .. "."
print(current_folder)
return require(current_folder .. "patchy_2")

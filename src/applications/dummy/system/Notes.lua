local Super = require 'engine.Prototype'
local Self = Super:clone("Notes")

local SFX_NEW_MAIL = love.audio.newSource("submodules/lua-projects-private/sfx/Blip_Select4.wav", "static")


Self.MEMORABLE_NOTES = {}
Self.MEMORABLE_NOTES["test123"] = true



function Self:init(args)
  self.main = args.main
  self.hasCallbacks = true
  self.hasSerialization = true
  Super.init(self)

  self.callbacks:declare("onNoteAdded")
  

  self.note_list = {}
  self.notesMap = {}

  return self
end

function Self:serialize()
  local t = {
    note_list = self.note_list
  }
  return t
end

function Self:deserialize(raw)
  for index, value in ipairs(raw.note_list or {}) do
    self:addNote(value)
  end

  return self
end

function Self:isMemorable(note)
  return Self.MEMORABLE_NOTES[note]
end

function Self:checkList(ls)
  for i, v in ipairs(ls) do
    if not self:checkNote(v) then
      return false
    end
  end
  return true
end

function Self:addNote(note)
  self.callbacks:call("onNoteAdded", {note})
  self.notesMap[note] = note
  table.insert(self.note_list, note)
end

function Self:addNewNote(note)
  if self.notesMap[note] then
    return
  end
  self.callbacks:call("onNoteAdded", {note})
  self.notesMap[note] = note
  table.insert(self.note_list, note)
end

function Self:checkNote(note)
  return self.notesMap[note]
end

return Self
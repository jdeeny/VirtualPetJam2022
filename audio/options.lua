-- Table of clip aliases
local Aliases = {
  new_name = 'old_name'
}


-- A dictionary of sound clip names to tables of options
-- These will be applied to the clips after assets are loaded
local ClipOptions = {
  some_clip = { volume = 0.7 },
  other_clip = { looping = true, volume = 1.0 }
}


return { Aliases = Aliases, ClipOptions = ClipOptions }

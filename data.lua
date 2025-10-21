require "prototypes/worldgen.lua"
require "prototypes/categories.lua"
require "prototypes/tiles.lua"
require "prototypes/items.lua"
require "prototypes/fluids.lua"
require "prototypes/entities.lua"
require "prototypes/recipes.lua"

data:extend{
  {
    type = "custom-event",
    name = "pk-redraw-guis",
  },
}
data.raw["gui-style"].default["pk-filler-horz"] = {
  type = "empty_widget_style",
  horizontally_stretchable = "on",
}

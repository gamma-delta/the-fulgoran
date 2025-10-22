require "prototypes/worldgen.lua"
require "prototypes/categories.lua"
require "prototypes/tiles.lua"
require "prototypes/items.lua"
require "prototypes/fluids.lua"
require "prototypes/entities.lua"
require "prototypes/recipes.lua"
require "prototypes/styles.lua"

data:extend{
  {
    type = "custom-event",
    name = "pk-redraw-guis",
  },
  {
    type = "custom-event",
    name = "pk-seal-failure",
  },
}

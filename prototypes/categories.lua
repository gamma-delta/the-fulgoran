data:extend{
  -- These 3 layers are stacking
  -- ie you can't have something that is oxygenated but not sealed
  -- Lack of this indicates that it's poor foundation
  -- and can't place good machinery on it
  {
    type = "collision-layer",
    name = "pk-floor",
  },
  -- Indicates that an area is surrounded by walls
  {
    type = "collision-layer",
    name = "pk-sealed",
  },
  -- Indicates that an area is surrounded by walls and has oxygen
  {
    type = "collision-layer",
    name = "pk-oxygenated",
  },

  -- Used to indicate that an entity can form oxygen walls
  {
    type = "collision-layer",
    name = "pk-airtight",
  },

  {
    type = "recipe-category",
    name = "pk-internal",
  },
}

local debug_o2 = {
  {icon = "__pk-the-fulgoran__/graphics/icons/molecule-oxygen.png"},
  {
    icon = "__base__/graphics/icons/big-biter-corpse.png",
    scale = 0.3333,
    shift = {-8, -8},
  },
}
data:extend{
  {
    type = "shortcut",
    name = "pk-oxygen-debug",
    localised_name = {"shortcut.pk-oxygen-debug"},
    toggleable = true,
    action = "lua",
    icon_size = 56,
    icons = debug_o2,
    small_icon_size = 24,
    small_icons = debug_o2
  },
}

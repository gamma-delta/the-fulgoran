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

  {
    type = "custom-input",
    name = "pk-oxygen-debug",
    key_sequence = "SHIFT + O",
    action = "lua",
  }
}

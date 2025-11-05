data:extend{
  -- Actually important recipes
  {
    type = "recipe",
    name = "pk-oxygen-diffuser",
    ingredients = {
      {type="item", name="pump", amount=1},
      {type="item", name="pk-filter", amount=5},
      {type="item", name="low-density-structure", amount=10},
      {type="item", name="electronic-circuit", amount=10},
    }
  },
  -- Recipes for recycling
  {
    type = "recipe",
    name = "pk-buggy",
    ingredients = {
      -- EEUs are the most important so you can make burner generators
      {type="item", name="electric-engine-unit", amount=20},
      {type="item", name="low-density-structure", amount=20},
      {type="item", name="plastic-bar", amount=100},
      {type="item", name="processing-unit", amount=20},
    },
    energy_required = 60,
    results = {{type="item", name="pk-buggy", amount=1}}
  },
  
  -- Dumb stuff
  {
    type = "recipe",
    name = "pk-oxygen-diffuser",
    icon = "__pk-the-fulgoran__/graphics/icons/molecule-oxygen.png",
    category = "pk-internal",
    enabled = true,
    hidden = true,
    ingredients = {{type="fluid", name="pk-oxygen", amount=100}},
    energy_required = 0.1,
    results = {{type="fluid", name="pk-work", amount=100}}
  },
  {
    type = "recipe",
    name = "pk-eat-work",
    icon = "__base__/graphics/icons/signal/signal-battery-full.png",
    category = "pk-internal",
    enabled = true,
    hidden = true,
    ingredients = {{type="fluid", name="pk-work", amount=10}},
    energy_required = 1,
    results = {}
  },
}

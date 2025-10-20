data:extend{
  {
    type = "recipe",
    name = "pk-oxygen-diffuser",
    icon = "__pk-the-fulgoran__/graphics/icons/molecule-oxygen.png",
    category = "pk-internal",
    enabled = true,
    hidden = true,
    ingredients = {{type="fluid", name="pk-oxygen", amount=1000}},
    energy_required = 1,
    results = {{type="fluid", name="pk-work", amount=1000}}
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

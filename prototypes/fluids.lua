data:extend{
  -- yoinked from TFF
  -- now that i think about it these acronyms are not very helpful
  {
    type = "item-subgroup",
    name = "pk-gasses",
    group = "fluids",
    order = "b",
  },
  {
    type = "fluid",
    name = "pk-hydrogen",
    icon = "__pk-the-fulgoran__/graphics/icons/molecule-hydrogen.png",
    subgroup = "pk-gasses",
    order = "b[new-gas]-a[elemental]-a[hydrogen]",
    -- room temperature idfc
    default_temperature = 300,
    max_temperature = 300,
    -- Always use the gas visualization
    gas_temperature = 0,
    heat_capacity = "0.01kJ",
    base_color = { 0.9, 0.9, 0.92 },
    flow_color = { 0.8, 0.8, 0.92 },
    auto_barrel = false,
  },
  {
    type = "fluid",
    name = "pk-oxygen",
    icon = "__pk-the-fulgoran__/graphics/icons/molecule-oxygen.png",
    subgroup = "pk-gasses",
    order = "b[new-gas]-a[elemental]-b[oxygen]",
    default_temperature = 300,
    max_temperature = 300,
    gas_temperature = 0,
    heat_capacity = "0.01kJ",
    base_color = { 0.9, 0.3, 0.35 },
    flow_color = { 0.9, 0.2, 0.2 },
    auto_barrel = false,
  },
  {
    type = "fluid",
    name = "pk-work",
    icon = "__base__/graphics/icons/signal/signal-battery-full.png",
    subgroup = "other",
    order = "zzz",
    default_temperature = 0,
    max_temperature = 1000,
    gas_temperature = 0,
    heat_capacity = "1J",
    base_color = {1, 1, 1},
    flow_color = {1, 1, 1},
    auto_barrel = false,
  },
}

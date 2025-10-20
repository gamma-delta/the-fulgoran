-- Move gasses to be gasses
local function togas(name, order)
  local gas = data.raw["fluid"][name]
  gas.subgroup = "pk-gasses"
  gas.order = "a[existing-gas]-" .. order
end
togas("steam", "a")
togas("petroleum-gas", "b")
togas("ammonia", "c")
togas("fluorine", "d")
togas("fusion-plasma", "e")

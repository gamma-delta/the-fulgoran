local tcm = util.copy(require("__base__/prototypes/tile/tile-collision-masks"))

tcm.floor = tcm.ground()
tcm.floor.layers["pk-floor"] = true

data:extend{
  util.merge{data.raw["tile"]["refined-concrete"], {
    name = "pk-hab-floor",
    minable = {mining_time = 0.2, result = "pk-hab-floor"},
    collision_mask = tcm.floor,
    -- as vanilla
    layer = 17,
  }},
}

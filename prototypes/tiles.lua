local tcm = util.copy(require("__base__/prototypes/tile/tile-collision-masks"))

tcm.floor = tcm.ground()
tcm.floor.layers["pk-floor"] = true

data:extend{
  util.merge{data.raw["tile"]["cyan-refined-concrete"], {
    name = "pk-hab-floor",
    minable = {mining_time = 0.2, result = "pk-hab-floor"},
    collision_mask = tcm.floor,
    -- Under concrete I guess?
    layer = 16,
  }},
}
-- sigh
data.raw["tile"]["pk-hab-floor"].localised_name = nil

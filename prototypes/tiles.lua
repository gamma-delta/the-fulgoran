local tcm = util.copy(require("__base__/prototypes/tile/tile-collision-masks"))

tcm.floor = tcm.ground()
tcm.floor.layers["pk-floor"] = true
tcm.sealed = util.copy(tcm.floor)
tcm.sealed.layers["pk-sealed"] = true
tcm.oxygenated = util.copy(tcm.sealed)
tcm.oxygenated.layers["pk-oxygenated"] = true

data:extend{
  util.merge{data.raw["tile"]["refined-concrete"], {
    name = "pk-hab-floor",
    minable = {mining_time = 0.2, result = "pk-hab-floor"},
    collision_mask = tcm.floor,
    -- as vanilla
    layer = 17,
  }},
  util.merge{data.raw["tile"]["refined-concrete"], {
    name = "pk-hab-floor-sealed",
    minable = {mining_time = 0.2, result = "pk-hab-floor"},
    collision_mask = tcm.sealed,
    -- I think these need to be higher so i can quick-replace them
    -- in editor?
    layer = 18,
    -- This is a blatant lie but it means it is minable or something
    placeable_by = {item="pk-hab-floor", count=1}
  }},
  util.merge{data.raw["tile"]["refined-concrete"], {
    name = "pk-hab-floor-oxygenated",
    minable = {mining_time = 0.2, result = "pk-hab-floor"},
    collision_mask = tcm.oxygenated,
    layer = 19,
    placeable_by = {item="pk-hab-floor", count=1}
  }},
}

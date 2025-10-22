local vanilla_collision = require("__core__/lualib/collision-mask-defaults")

local function require_floor(proto, layer)
  local bb = proto.collision_box
  if not proto.tile_buildability_rules then
    proto.tile_buildability_rules = {}
  end
  table.insert(proto.tile_buildability_rules, {
    area = bb,
    remove_on_collision = true,
    required_tiles = {layers={["pk-floor"]=true}}
  })
end

require_floor(data.raw["wall"]["stone-wall"])
require_floor(data.raw["gate"]["gate"])

local function add_layer(proto, layer)
  if proto.collision_mask == nil then
    proto.collision_mask = util.copy(vanilla_collision[proto.type])
  end
  proto.collision_mask.layers[layer] = true
end

add_layer(data.raw["wall"]["stone-wall"], "pk-seal")
local gate = data.raw["gate"]["gate"]

add_layer(gate, "pk-seal")
gate.opened_collision_mask = util.copy(vanilla_collision["gate/opened"])
gate.opened_collision_mask.layers["pk-seal"] = true

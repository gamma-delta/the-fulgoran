local vanilla_collision = require("__core__/lualib/collision-mask-defaults")

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

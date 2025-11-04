local tf_util = require("tf_util")

local function require_floor(proto, req_bool)
  local bb = proto.collision_box
  if not proto.tile_buildability_rules then
    proto.tile_buildability_rules = {}
  end
  local key = req_bool and "required_tiles" or "colliding_tiles"
  table.insert(proto.tile_buildability_rules, {
    area = bb,
    remove_on_collision = true,
    [key] = {layers={["pk-floor"]=true}}
  })
end

local function add_trigger(proto, name)
  local fx_out = tf_util.script_created_effect(name)
  if proto.created_effect then
    fx_out = {proto.created_effect, fx_out}
  end
  proto.created_effect = fx_out
end

local function add_requires_tooltip(proto, value)
  local tt = {
    name = {"pk-text.requires"},
    value = {value},
  }
  if proto.custom_tooltip_fields then
    table.insert(proto.custom_tooltip_fields, tt)
  else
    proto.custom_tooltip_fields = {tt}
  end
end

local function require_em(proto)
  add_trigger(proto, "pk-need-sealed-em")
  add_requires_tooltip(proto, "pk-text.req-em-shielding")
  require_floor(proto, true)
end
local function require_o2(proto)
  add_trigger(proto, "pk-need-sealed-o2")
  add_requires_tooltip(proto, "pk-text.req-o2")
  require_floor(proto, true)
end

---

require_floor(data.raw["wall"]["stone-wall"], true)
require_floor(data.raw["gate"]["gate"], true)
require_floor(data.raw["assembling-machine"]["pk-oxygen-diffuser"], true)
-- don't let lightning strike inside the base
require_floor(data.raw["lightning-attractor"]["pk-lightning-rod"], false)
require_floor(data.raw["lightning-attractor"]["lightning-collector"], false)

for _,it in pairs(data.raw["inserter"]) do
  require_em(it)
end
for _,it in pairs(data.raw["electric-pole"]) do
  require_em(it)
end

require_em(data.raw["assembling-machine"]["assembling-machine-1"])
require_em(data.raw["assembling-machine"]["assembling-machine-2"])
require_em(data.raw["assembling-machine"]["assembling-machine-3"])
require_em(data.raw["assembling-machine"]["chemical-plant"])
require_em(data.raw["assembling-machine"]["electromagnetic-plant"])
-- Oil plant is basically just boiling things or something
require_em(data.raw["furnace"]["recycler"])
require_em(data.raw["accumulator"]["accumulator"])
require_em(data.raw["lab"]["lab"])

require_o2(data.raw["assembling-machine"]["biochamber"])

for _,it in ipairs{
  data.raw["assembling-machine"]["biochamber"],
} do
  add_trigger(it, "pk-need-sealed-o2")
end

local function fixup_layer(proto, layer)
  local bb = proto.collision_box
  if not proto.tile_buildability_rules then 
    proto.tile_buildability_rules = {}
  end
  table.insert(proto.tile_buildability_rules, {
    area = bb,
    remove_on_collision = true,
    required_tiles = {layers={[layer]=true}}
  })
end
local function req_floor(proto)
  fixup_layer(proto, "pk-floor")
end
local function req_sealed(proto)
  fixup_layer(proto, "pk-sealed")
  fixup_layer(proto, "pk-floor")
end
local function req_oxygenated(proto)
  fixup_layer(proto, "pk-oxygenated")
  fixup_layer(proto, "pk-sealed")
  fixup_layer(proto, "pk-floor")
end

req_floor(data.raw["wall"]["stone-wall"])
req_floor(data.raw["gate"]["gate"])

req_sealed(data.raw["assembling-machine"]["biochamber"])
req_sealed(data.raw["accumulator"]["accumulator"])

req_oxygenated(data.raw["furnace"]["stone-furnace"])
req_oxygenated(data.raw["furnace"]["steel-furnace"])

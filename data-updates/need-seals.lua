local tf_util = require("tf_util")

local function add_trigger(proto, name)
  local fx_out = tf_util.script_created_effect(name)
  if proto.created_effect then
    fx_out = {proto.created_effect, fx_out}
  end
  proto.created_effect = fx_out
end

for _,it in ipairs{
  data.raw["inserter"]["inserter"],
  data.raw["inserter"]["fast-inserter"],
  data.raw["inserter"]["long-handed-inserter"],
  data.raw["inserter"]["bulk-inserter"],
} do
  add_trigger(it, "pk-need-sealed-em")
end

for _,it in ipairs{
  data.raw["assembling-machine"]["biochamber"],
} do
  add_trigger(it, "pk-need-sealed-o2")
end

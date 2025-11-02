-- Make lightning worse

-- Imagine society if lua had a working array api
local lp = data.raw["planet"]["fulgora"].lightning_properties
local killme = {}
for _,unimmune in ipairs{
  "rail-signal",
  "rail-chain-signal",
  "locomotive",
  "artillery-wagon",
  "cargo-wagon",
  "fluid-wagon",
  "wall"
} do
  for i,exemption in ipairs(lp.exemption_rules) do
    if exemption.type == "prototype" and exemption.string == unimmune then
      table.insert(killme, i)
      break
    end
  end
end
for i=#killme,1,-1 do
  table.remove(lp.exemption_rules, killme[i])
end

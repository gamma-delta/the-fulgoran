for name,apc in pairs(data.raw["autoplace-control"]) do
  if not name:match("^pk")
    and name ~= "scrap"
    and name ~= "fulgora_islands"
    and name ~= "fulgora_cliff"
  then
    apc.hidden = true
  end
end

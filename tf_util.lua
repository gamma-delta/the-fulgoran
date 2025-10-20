-- The Fulgoran util
local tf_util = {}

tf_util.script_created_effect = function(name)
  return {
    type = "direct",
    action_delivery = {
      type = "instant",
      source_effects = {
        type = "script",
        effect_id = name
      }
    }
  }
end

tf_util.get = function(table, key, default)
  if not table[key] then
    table[key] = default
  end
  return table[key]
end
tf_util.storage_table = function(key)
  return tf_util.get(storage, key, {})
end

tf_util.round_pos = function(it)
  return {
    x = (it.x < 0) and math.ceil(it.x) or math.floor(it.x),
    y = (it.y < 0) and math.ceil(it.y) or math.floor(it.y)
  }
end
tf_util.add_pos = function(a, b)
  return {
    x = (a.x or a[1]) + (b.x or b[1]),
    y = (a.y or a[2]) + (b.y or b[2]),
  }
end

-- checker(position) -> string
-- "ok": can floodfill through here
-- "wall": safely blocks floodfill
-- "fail": instantly fail
tf_util.floodfill = function(start, checker)
  start = tf_util.round_pos(start)
  
  game.print(serpent.line(start))
  if checker(start) ~= "ok" then 
    return {error=start}
  end
  local work = {start}
  local results = {}
  local seen = {}
  local done = 0
  while #work > 0 and done < 10000 do
    done = done + 1
    
    local here = table.remove(work)
    for _,dir in ipairs{
      "north", "south", "east", "west",
      "northeast", "northwest", "southeast", "southwest"
    } do
      local there = tf_util.add_pos(here, util.direction_vectors[defines.direction[dir]])
      -- AUGHH
      local i_hate_lua = util.positiontostr(there)
      if seen[i_hate_lua] then goto continue end
      seen[i_hate_lua] = true
      table.insert(results, there)

      local checked = checker(there)
      game.print("checking " .. serpent.line(there) .. " -> " .. checked)
      if checked == "ok" then
        table.insert(work, there)
      elseif checked == "fail" then
        return {error=there}
      end
      -- Else, if it's a wall, successfully don't care

      ::continue::
    end
  end
  return {ok=results}
end

tf_util.position_has_wall = function(surface, pos)
  local es = surface.find_entities_filtered{
    -- position = tf_util.add_pos(pos, {0.5, 0.5}),
    position = pos,
    collision_mask = "pk-airtight",
  }
  game.print(serpent.line(es))
  return #es > 0
end

tf_util.floodfill_o2 = function(surface, start)
  return tf_util.floodfill(start, function(pos)
    if tf_util.position_has_wall(surface, pos) then
      return "wall"
    elseif surface.get_tile(pos).collides_with("pk-floor") then
      return "ok"
    else
      return "fail"
    end
  end)
end

return tf_util

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
    x = math.floor(it.x),
    y = math.floor(it.y),
  }
end
tf_util.add_pos = function(a, b)
  return {
    x = (a.x or a[1]) + (b.x or b[1]),
    y = (a.y or a[2]) + (b.y or b[2]),
  }
end
tf_util.center_pos = function(it)
  return tf_util.add_pos(it, {
    x = ((it.x or it[1]) > 0) and 0.5 or -0.5,
    y = ((it.y or it[2]) > 0) and 0.5 or -0.5,
  })
end

-- checker(position) -> string
-- "ok": can floodfill through here
-- "wall": safely blocks floodfill
-- "fail": instantly fail
tf_util.floodfill = function(start, checker)
  start = tf_util.round_pos(start)
  
  if checker(start) ~= "ok" then 
    return {error=start, reason="start must be ok"}
  end
  local work = {start}
  local results = {start}
  local seen = {[util.positiontostr(start)] = true}
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

      local checked = checker(there)
      if checked == "ok" then
        table.insert(results, there)
        table.insert(work, there)
      elseif checked == "fail" then
        return {error=there, reason="fail tile during floodfill"}
      end
      -- Else, if it's a wall, successfully don't care

      ::continue::
    end
  end
  return {ok=results}
end

tf_util.position_has_wall = function(surface, pos)
  pos = tf_util.add_pos(pos, {0.5, 0.5})
  local es = surface.find_entities_filtered{
    position = pos,
    collision_mask = "pk-airtight",
    radius = 0.25
  }
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

tf_util.debug_flying_text = function(surface, position, text, splat)
  local ok_players = {}
  for _,player in pairs(game.players) do
    if player.is_shortcut_toggled("pk-oxygen-debug") then
      player.create_local_flying_text(util.merge({
        {
          text = text,
          surface = surface,
          position = position,
        },
        splat
      }))
    end
  end
end

return tf_util

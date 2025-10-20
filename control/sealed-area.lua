local tf_util = require("tf_util")

local veh = {events={}, on_nth_tick={}}

-- Tries to get it via unit number or entity
--- @return {["diffuser"]: LuaEntity, ["valve"]: LuaEntity, ["tank"]: LuaEntity}
local function oxygen_diffuser_assoc(id)
  if type(id) ~= "number" then
    id = id.unit_number
  end
  return tf_util.storage_table("oxygen-diffusers")[id]
end

veh.events[defines.events.on_script_trigger_effect] = function(evt)
  if evt.effect_id ~= "pk-oxygen-diffuser" then return end

  local diffuser = evt.source_entity
  local decon_id = script.register_on_object_destroyed(diffuser)
  tf_util.storage_table("oxygen-diffuser-deathrattle")[decon_id] = true

  local valve = diffuser.surface.create_entity{
    name = "pk-oxygen-diffuser-valve",
    position = diffuser.position,
    force = diffuser.force
  }
  local tank = diffuser.surface.create_entity{
    name = "pk-oxygen-diffuser-storage",
    position = diffuser.position,
    force = diffuser.force
  }
  diffuser.fluidbox.add_linked_connection(1, valve, 1)
  valve.fluidbox.add_linked_connection(2, tank, 1)

  tf_util.storage_table("oxygen-diffusers")[diffuser.unit_number] = {
    -- it turns out you can just put entities in here?
    diffuser = diffuser,
    valve = valve,
    tank = tank,
  }
end

veh.on_nth_tick[10] = function(tick)
  -- Do 1/6th of these
  local chunk_amt = 6
  local chunk_tick_idx = math.floor(tick.tick / tick.nth_tick) % chunk_amt
  local i = 0
  for _,assoc in pairs(storage["oxygen-diffusers"]) do
    if i == (chunk_tick_idx) then
      local diffuser = assoc.diffuser
      local ff = tf_util.floodfill_o2(
        diffuser.surface,
        diffuser.position
      )
      if ff.error then
        tf_util.debug_flying_text(diffuser.surface, diffuser.position,
          ff.reason, {color={1, 0.5, 0.5}})
      else
        local o2_per_square = 100
        local max_o2 = #ff.ok * o2_per_square

        local tank_size = assoc.tank.fluidbox.get_capacity(1)
        local proportion = max_o2 / tank_size
        assoc.valve.valve_threshold_override = proportion

        tf_util.debug_flying_text(
          diffuser.surface, diffuser.position,
          string.format(
            "floodfill found %d, o2 is %f%% of tank max", #ff.ok, proportion*100
          ),
          {})
      end
    end
    i = i+1
  end
end

veh.events[defines.events.on_object_destroyed] = function(evt)
  local odds = tf_util.storage_table("oxygen-diffuser-deathrattle")
  if not odds[evt.registration_number] then return end
  odds[evt.registration_number] = nil
  local assoc = oxygen_diffuser_assoc(evt.useful_id)
  if assoc then
    assoc.valve.destroy()
    assoc.tank.destroy()
    tf_util.storage_table("oxygen-diffusers")[evt.useful_id] = nil
  end
end

-- i hate factorio
veh.events[defines.events.on_lua_shortcut] = function(evt)
  if evt.prototype_name ~= "pk-oxygen-debug" then return end
  local player = game.players[evt.player_index]
  player.set_shortcut_toggled("pk-oxygen-debug", not player.is_shortcut_toggled("pk-oxygen-debug"))
end

--[[
veh.events["pk-oxygen-debug"] = function(evt)
  local player = game.players[evt.player_index]
  local ff = tf_util.floodfill_o2(player.surface, evt.cursor_position)

  if ff.error then
    game.print(ff.reason)
    rendering.draw_sprite{
      target = tf_util.add_pos(ff.error, {0.5, 0.5}),
      surface = player.surface,
      sprite = "utility/danger_icon",
      x_scale = 0.5,
      y_scale = 0.5,
      time_to_live = 120,
      players = {player},
    }
  else
    local box_sz = 0.8
    local box_margin = 1-box_sz
    for _,pos in ipairs(ff.ok) do
      rendering.draw_rectangle{
        players = {player},
        surface = player.surface,
        left_top = tf_util.add_pos(pos, {1-box_sz, 1-box_sz}),
        right_bottom = tf_util.add_pos(pos, {box_sz, box_sz}),
        color = {0.5, 0.7, 1.0, 0.001},
        filled = true,
        time_to_live = 60 * 5,
      }
    end
  end
end
]]

return veh

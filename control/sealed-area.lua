local tf_util = require("tf_util")

local veh = {events={}}

-- Tries to get it via unit number or entity
local function oxygen_diffuser_assoc(id)
  local entity = id
  if type(entity) == "number" then
    entity = game.get_entity_by_unit_number(id)
  end
  if entity == nil then return nil end
  return tf_util.storage_table("oxygen-diffusers")[entity.unit_number]
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
    valve = valve,
    tank = tank,
  }
end

veh.events[defines.events.on_object_destroyed] = function(evt)
  local odds = tf_util.storage_table("oxygen-diffuser-deathrattle")
  if not odds[evt.registration_number] then return end

  local assoc = oxygen_diffuser_assoc(evt.useful_id)
  if assoc then
    game.print("Killing " .. serpent.line(assoc))
    assoc.valve.destroy()
  end
end

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

return veh

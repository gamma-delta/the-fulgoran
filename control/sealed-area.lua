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

  local limiter = diffuser.surface.create_entity{
    name = "pk-oxygen-diffuser-limiter",
    position = diffuser.position,
    force = diffuser.force
  }
  local tank = diffuser.surface.create_entity{
    name = "pk-oxygen-diffuser-storage",
    position = diffuser.position,
    force = diffuser.force
  }
  diffuser.fluidbox.add_linked_connection(1, limiter, 1)
  limiter.fluidbox.add_linked_connection(2, tank, 1)

  -- MAGIC
  local limiter_wc = limiter.get_wire_connector(defines.wire_connector_id.circuit_green, true)
  local tank_wc = tank.get_wire_connector(defines.wire_connector_id.circuit_green, true)
  limiter_wc.connect_to(tank_wc, false, defines.wire_origin.script)
  local limiter_cb = limiter.get_or_create_control_behavior()
  local tank_cb = tank.get_or_create_control_behavior()
  tank_cb.read_contents = true
  limiter_cb.circuit_enable_disable = true
  limiter_cb.circuit_condition = {
    first_signal = {type="fluid", name="pk-work"},
    comparator="<",
    constant=0,
  }

  tf_util.storage_table("oxygen-diffusers")[diffuser.unit_number] = {
    -- it turns out you can just put entities in here?
    diffuser = diffuser,
    limiter = limiter,
    tank = tank,
    owned_tiles = {}
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
      -- another table we need to write back
      local limit_cc = assoc.limiter.get_or_create_control_behavior().circuit_condition
      local ff = tf_util.floodfill_o2(diffuser)

      if ff.error then
        -- you are dumping it all to atmosphere.
        if ff.catastrophe then
          assoc.tank.fluidbox.flush(1, "pk-work")
          limit_cc.constant = 999999999
        else
          limit_cc.constant = 0
        end
        tf_util.alert(diffuser, {type="fluid", name="pk-oxygen"}, ff.reason, true)
      else
        local max_o2 = #ff.ok * settings.startup["pk-oxygen-volume-per-tile"].value
        limit_cc.constant = max_o2
        -- give a little wiggle room
        local must_void = false
        if assoc.tank.fluidbox[1] then
          must_void = max_o2 < assoc.tank.fluidbox[1].amount
          if must_void then
            local fluid = assoc.tank.fluidbox[1]
            fluid.amount = max_o2
            assoc.tank.fluidbox[1] = fluid
          end
        end
        tf_util.debug_flying_text(
          diffuser.surface, diffuser.position,
          string.format(
            "floodfill found %d, need %d o2%s",
            #ff.ok,
            max_o2,
            (must_void and ", voided!" or "")
          ),
          {})
      end

      assoc.limiter.get_or_create_control_behavior().circuit_condition = limit_cc
      script.raise_event("pk-redraw-guis", {})
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
    if assoc.valve then
      assoc.valve.destroy()
    end
    if assoc.limiter then
      assoc.limiter.destroy()
    end
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

veh.events[defines.events.on_selected_entity_changed] = function(evt)
  local player = game.players[evt.player_index]

  local my_renders = tf_util.storage_table("oxygen-diffuser-renders")
  if my_renders[player.index] then
    for _,r in ipairs(my_renders[player.index]) do
      r.destroy()
    end
  end
  my_renders[player.index] = {}

  local e = player.selected
  if not e or e.name ~= "pk-oxygen-diffuser" then return end
  local renders = my_renders[player.index]

  local ff = tf_util.floodfill_o2(e)
  if ff.error then
    table.insert(renders, rendering.draw_text{
      text = ff.reason,
      surface = e.surface,
      target = e,
      color = {1.0, 0.5, 0.5},
      alignment = "center",
      vertical_alignment = "middle"
    })
    table.insert(renders, rendering.draw_sprite{
      sprite = "utility/danger_icon",
      surface = e.surface,
      x_scale = 0.5,
      y_scale = 0.5,
      target = tf_util.add_pos(ff.error, {0.5, 0.5})
    })
  else
    local box_sz = 1
    for _,pos in ipairs(ff.ok) do
      table.insert(renders, rendering.draw_rectangle{
        players = {player},
        surface = player.surface,
        left_top = tf_util.add_pos(pos, {1-box_sz, 1-box_sz}),
        right_bottom = tf_util.add_pos(pos, {box_sz, box_sz}),
        color = util.premul_color{0.5, 0.7, 1.0, 0.3},
        filled = true,
      })
    end
  end
end

return veh

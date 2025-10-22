local tf_util = require("tf_util")
local o2lib = require("control/o2lib")

local veh = {events={}, on_nth_tick={}}

veh.events[defines.events.on_script_trigger_effect] = function(evt)
  if evt.effect_id ~= "pk-need-sealed-o2" and evt.effect_id ~= "pk-need-sealed-em" then
    return
  end
  -- o2 is a "stronger" need than em shielding
  local need_o2 = evt.effect_id == "pk-need-sealed-o2"
  local entity = evt.source_entity

  script.register_on_object_destroyed(entity)
  tf_util.storage_table("need-sealed")[entity] = {
    need_o2 = need_o2,
  }
end

local function find_diffuser_for_entity(entity)
  local tile_pos = tf_util.round_pos(entity.position)
  local key = util.positiontostr(tile_pos)
  local cached = storage["sealed-locations-o2"][key]
  if cached then
    return cached
  elseif cached == false then
    -- it's known to be bad
    return nil
  end
  -- else it had nothing and we need to search

  local ff = tf_util.floodfill_o2(entity.position, entity.surface, nil)
  if ff.error then
    return nil
  else
    return ff.pois[1]
  end
end

local check_per_x_ticks = 20

local function check_em_seal_for_entity(entity)
  local tile_pos = tf_util.round_pos(entity.position)
  local key = util.positiontostr(tile_pos)
  local cached = storage["sealed-locations-em"][key]
  if cached then
    return true
  end
  -- else it had nothing and we need to search
  local ff = tf_util.floodfill_em(entity.position, entity.surface)
  return ff.ok ~= nil
end

local function check_normal_entities(tick)
  local chunk_amt = 10
  local chunk_tick_idx = math.floor(tick.tick / tick.nth_tick) % chunk_amt

  if chunk_tick_idx == 0 then
    -- Start of the "cycle". Clear previous cycle's known sealed locations
    -- this maps position keys to THE DIFFUSER
    storage["sealed-locations-o2"] = {}
    -- maps to true
    storage["sealed-locations-em"] = {}
  end

  local i = 0
  for entity,sealinfo in pairs(tf_util.storage_table("need-sealed")) do
    if entity.valid and i % chunk_amt == chunk_tick_idx then
      local success = false

      if sealinfo.need_o2 then
        local diffuser = find_diffuser_for_entity(entity)
        local fail = diffuser == nil
        if diffuser then
          fail = not o2lib.sip_o2(diffuser, 20)
        end

        if fail then
          -- Cosmetic effect
          for _=1,10 do
            entity.surface.create_particle{
              name = "hairyclubnub-mining-particle",
              position = entity.position,
              movement = {(math.random()-0.5)*0.2, -math.random()*0.1},
              height = 1,
              vertical_speed = 0,
              frame_speed = 1
            }
          end
        else
          success = true
        end
      else
        -- else this is non-o2
        local has_em = check_em_seal_for_entity(entity)
        if has_em then
          success = true
        else
          entity.surface.create_entity{
            name = "flying-robot-damaged-explosion",
            position = entity.position,
          }
          entity.surface.play_sound{
            -- this is the only thing that uses electric-small-open
            path = "entity-open/small-lamp",
            position = entity.position,
            volume = 0.6
          }
        end
      end

      if not success then
        script.raise_event("pk-seal-failure", {
          entity = entity,
          sealinfo = sealinfo
        })
        if entity.valid then
          local dmg = settings.global[
            sealinfo.need_o2 and "pk-no-o2-damage-per-second" or "pk-no-shielding-damage-per-second"
          ].value
          local time_scale = (check_per_x_ticks / 60) * chunk_amt
          entity.damage(dmg * time_scale, "enemy")
        end
      end
    end
    -- next loop
    i = i + 1
  end
end

local function check_players(tick)
  for _,player in pairs(game.players) do
    if player.character and player.character.name == "character" then
      -- The player can smash themselves into the tile space of walls.
      -- Check in a plus shape around the player
      local found_diffuser = nil
      for _,offset in ipairs{
        {0, 0},
        {-0.5, 0},
        {0.5, 0},
        {0, -0.5},
        {0, 0.5}
      } do
        local ff = tf_util.floodfill_o2(
          tf_util.add_pos(player.character.position, offset),
          player.surface,
          nil
        )
        if ff.ok then
          found_diffuser = ff.pois[1]
          break
        end
      end

      local can_breathe = found_diffuser ~= nil
      if found_diffuser then
        local player_chug_per_second = 1
        can_breathe = o2lib.sip_o2(found_diffuser, player_chug_per_second)
      end

      if not can_breathe then
        -- todo: check spacesuit
        local dmg = settings.global["pk-no-o2-player-damage-per-second"].value
        player.character.damage(dmg, "enemy")
      end
    end
  end
end

veh.on_nth_tick[check_per_x_ticks] = function(tick)
  check_normal_entities(tick)
end
veh.on_nth_tick[60] = function(tick)
  check_players(tick)
end

veh.events[defines.events.on_object_destroyed] = function(evt)
  if evt.type ~= defines.target_type.entity then return end
  local sealinfo_table = tf_util.storage_table("need-sealed")
  local sealinfo = sealinfo_table[evt.useful_id]
  if not sealinfo then return end

  sealinfo_table[evt.useful_id] = nil
end

return veh

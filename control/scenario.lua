local veh = {
  events={}
}

local function respawn_player(player)
  local fulgora = game.surfaces["fulgora"]
  local spawn_pos = player.force.get_spawn_position(fulgora)
  player.teleport(
    fulgora.find_non_colliding_position("character", spawn_pos, 0, 1),
    fulgora
  )
end

local function create_ending_info()
  game.set_win_ending_info{
    title = "Your did it",
    message = "yay"
  }
  game.set_lose_ending_info{
    title = "You suck",
    message = "Don't die next time idiot"
  }
end

veh.events[defines.events.on_player_created] = function()
  local fulgora = game.planets["fulgora"].create_surface()
  fulgora.request_to_generate_chunks({0, 0}, 3)
  fulgora.force_generate_chunk_requests()

  local force = game.forces["player"]
  for _,player in ipairs(force.players) do
    respawn_player(player)
  end
end

veh.on_init = function()
  if remote.interfaces["freeplay"] then
    remote.call("freeplay", "set_disable_crashsite", true)
    remote.call("freeplay", "set_skip_intro", true)
  end

  create_ending_info()

end
veh.on_configuration_changed = function()
  create_ending_info()
end

return veh

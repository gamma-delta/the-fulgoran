local tfgui = require("control/tfgui")
local tf_util = require("tf_util")

local veh = {events = {}}

local function update_o2bar(bar, diffuser, ff)
  local assoc = tf_util.storage_table("oxygen-diffusers")[diffuser.unit_number]
  local limit_cb = assoc.limiter.get_or_create_control_behavior()

  if ff.error then
    bar.value = 0
    bar.caption = {
      "pk-gui.o2-diffuser-tank-amt", 0, "infinity"
    }
  elseif assoc.tank.fluidbox[1] then
    -- TODO pull this out to a setting
    local o2_per_square = settings.startup["pk-oxygen-volume-per-tile"].value
    local max_oxygen = limit_cb.circuit_condition.constant
    local oxygen_amount = assoc.tank.fluidbox[1].amount

    bar.value = oxygen_amount / max_oxygen
    bar.caption = {
      "pk-gui.o2-diffuser-tank-amt",
      util.format_number(oxygen_amount, true),
      util.format_number(max_oxygen, true),
    }
    bar.tooltip = ("%d"):format(oxygen_amount)
  else
    bar.value = 0
    bar.caption = "Please hold"
  end
end

local function update_info(infobox, diffuser, ff)
  if ff.ok then
    infobox.add{type="label", caption={"pk-gui.o2-diffuser-area-key"}}
    infobox.add{type="empty-widget", style="pk-filler-horz"}
    infobox.add{type="label", caption={"pk-gui.o2-diffuser-area-val", #ff.ok}}
  else
    if ff.catastrophe then
      infobox.add{
        type="label", caption={"pk-gui.o2-diffuser-error-catastrophe"},
      }
    else
      infobox.add{type="label", caption={"pk-gui.o2-diffuser-error"}}
    end
    infobox.add{type="empty-widget", style="pk-filler-horz"}
    infobox.add{type="label", caption = ff.reason}
  end
end

local function redraw_gui(content)
  content.clear()

  local diffuser = game.get_entity_by_unit_number(
    tfgui.find_main_frame(content).tags.diffuser_id
  )
  local ff = tf_util.floodfill_o2(diffuser)

  tfgui.make_entity_frame(content, diffuser)

  content.add{type="line"}

  local o2bar_zone = content.add{
    type="flow", direction="horizontal",
    style="player_input_horizontal_flow"
  }
  o2bar_zone.style.vertical_align = "center"
  o2bar_zone.add{
    type = "sprite", sprite = "fluid/pk-oxygen",
    elem_tooltip = {type="fluid", name="pk-oxygen"}
  }
  local o2bar = o2bar_zone.add{
      type = "progressbar",
      name = "o2_bar",
      value = 0.69,
      style = "production_progressbar",
      caption = "Wow much oxygen"
    }
  o2bar.style.horizontally_stretchable = true
  update_o2bar(o2bar, diffuser, ff)

  content.add{type="line"}

  local info_zone = content.add{type="flow", direction="horizontal"}
  update_info(info_zone, diffuser, ff)
end

veh.events[defines.events.on_gui_opened] = function(evt)
  if evt.gui_type ~= defines.gui_type.entity
    or not evt.entity
    or evt.entity.name ~= "pk-oxygen-diffuser"
  then return end
  local player = game.get_player(evt.player_index)
  if not player then return end

  local diffuser = evt.entity
  local main_frame = tfgui.new_main_frame(
    player, "pk-oxygen-diffuser",
    diffuser.prototype.localised_name,
    {diffuser_id = diffuser.unit_number}
  )
  local content = main_frame.add{
    type="frame", direction="vertical",
    name="content",
    style="entity_frame"
  }

  redraw_gui(content)
end

veh.events["pk-redraw-guis"] = function(_)
  for _,player in pairs(game.players) do
    if player.gui.screen
      and player.gui.screen["pk-oxygen-diffuser"]
    then
      redraw_gui(player.gui.screen["pk-oxygen-diffuser"]["content"])
    end
  end
end

return veh

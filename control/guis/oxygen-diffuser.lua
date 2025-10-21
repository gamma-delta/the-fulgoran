local tfgui = require("control/tfgui")
local tf_util = require("tf_util")

local veh = {events = {}}

local function update_o2bar(bar, diffuser)
  local assoc = tf_util.storage_table("oxygen-diffusers")[diffuser.unit_number]

  -- TODO pull this out to a setting
  local o2_per_square = 100
  local tank_size = assoc.tank.fluidbox.get_capacity(1)
  local max_oxygen = assoc.valve.valve_threshold_override * tank_size
  local oxygen_amount = assoc.tank.fluidbox[1].amount

  bar.value = oxygen_amount / max_oxygen
  bar.caption = {"pk-gui.o2-diffuser-tank-amt",
    ("%d"):format(oxygen_amount),
    ("%d"):format(max_oxygen)}
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
    style="entity_frame"
  }
  tfgui.make_entity_frame(content, diffuser)

  content.add{type="line"}

  local o2bar = content.add{
      type = "flow", direction="horizontal"
    }.add{
      type = "progressbar",
      name = "o2_bar",
      value = 0.2,
      style = "production_progressbar",
      caption = "Wow much oxygen"
    }
  o2bar.style.horizontally_stretchable = true
  update_o2bar(o2bar, diffuser)
end

return veh

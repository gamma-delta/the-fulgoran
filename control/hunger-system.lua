local veh = {events={}}

local function update_gui(player, frame)
  frame.clear()

  local content = frame.add{
    type="frame", direction="horizontal",
    style="entity_frame"
  }
  content.style.horizontally_stretchable = false
  local vitals_table = content.add{
    type="table", column_count=3
  }

  vitals_table.add{type="label", caption="Hunger"}
  vitals_table.add{type="empty-widget"}
  vitals_table.add{type="progressbar", value=0.4}

  vitals_table.add{type="label", caption="Thirst"}
  vitals_table.add{type="empty-widget"}
  vitals_table.add{type="progressbar", value=0.5}

  vitals_table.add{type="label", caption="Oxygen"}
  vitals_table.add{type="empty-widget"}
  vitals_table.add{type="progressbar", value=0.4}
end

veh.events[defines.events.on_gui_opened] = function(evt)
  local player = game.players[evt.player_index]
  if evt.gui_type == defines.gui_type.controller then
    local gui = player.gui.relative["pk-hunger-system-gui"]
    if not gui then
      gui = player.gui.relative.add{
        type="frame", direction="vertical",
        name="pk-hunger-system-gui",
        anchor={gui=defines.relative_gui_type.controller_gui, position=defines.relative_gui_position.bottom}
      }
      gui.style.horizontally_squashable=true
    end

    update_gui(player, gui)
  end
end

return veh

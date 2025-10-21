local api = {
  make_entity_frame = require("control/tfgui/make-entity-frame.lua")
}

-- this is going to become frustrating if/when i start having multiple pk-mods
api.new_main_frame = function(player, name, title_caption, tags)
  local main_frame = player.gui.screen.add{
    type = "frame",
    name = name,
    tags = util.merge{{pktf_main_frame = true}, tags},
    direction = "vertical",
  }
  player.opened = main_frame
  main_frame.style.vertically_stretchable = true
  main_frame.style.horizontally_stretchable = true
  main_frame.auto_center = true

  local titlebar = main_frame.add{type = "flow"}
  titlebar.drag_target = main_frame
  titlebar.add{
    type = "label",
    style = "frame_title",
    caption = title_caption,
    ignored_by_interaction = true
  }
  local filler = titlebar.add {
    type = "empty-widget",
    style = "draggable_space",
    ignored_by_interaction = true,
  }
  filler.style.height = 24
  filler.style.horizontally_stretchable = true
  titlebar.add {
    type = "sprite-button",
    name = "pktf_x_button",
    style = "frame_action_button",
    sprite = "utility/close",
    tooltip = { "gui.close-instruction" },
  }

  return main_frame
end

api.find_main_frame = function(child)
  local it = child
  while it do
    if it.tags["pktf_main_frame"] then return it end
    it = it.parent
  end
  return nil
end

api.vanilla_handler_lib = {
  events = {
    [defines.events.on_gui_click] = function(evt)
      if evt.element and evt.element.name == "pktf_x_button" then
        api.find_main_frame(evt.element).destroy()
      end
    end,
    [defines.events.on_gui_closed] = function(evt)
      if evt.element and evt.element.tags["pktf_main_frame"] then
        evt.element.destroy()
      end
    end,
  }
}

return api

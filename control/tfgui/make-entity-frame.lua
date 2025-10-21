local api = {}

local status_lookup = {}
for stat, number in pairs(defines.entity_status) do
  status_lookup[number] = stat:gsub("_", "-")
end
local diode2sprite = {
  [defines.entity_status_diode.green] = "status_working",
  [defines.entity_status_diode.yellow] = "status_yellow",
  [defines.entity_status_diode.red] = "status_not_working",
}

local function status2color(status)
  if status == defines.entity_status.working
    or status == defines.entity_status.normal
  then
    return defines.entity_status_diode.green
  else
    return defines.entity_status_diode.red
  end
end

return function(parent, entity)
  local wrapper = parent.add{
    type = "flow", direction="vertical",
    style = "two_module_spacing_vertical_flow"
  }

  local status_bar = wrapper.add{type="flow", direction="horizontal"}
  -- https://forums.factorio.com/viewtopic.php?p=538298
  local diode_color, status_name
  if entity.custom_status then
    status_name = entity.custom_status.label
    diode_color = entity.custom_status.diode
  else
    status_name = {"entity-status." ..  status_lookup[entity.status] }
    diode_color = status2color(entity.status)
  end
  status_bar.add{
    type="sprite", style="status_image",
    -- https://lua-api.factorio.com/latest/concepts/SpritePath.html
    sprite="utility/" .. diode2sprite[diode_color],
  }
  status_bar.add{
    type="label",
    caption=status_name
  }

  local preview = wrapper.add{
      type="frame", direction="vertical",
      style="deep_frame_in_shallow_frame"
    }.add{type="entity-preview", style="wide_entity_button"}
  preview.visible = true
  preview.style.horizontally_stretchable = true
  local zoom_min = 2
  local sb = entity.prototype.selection_box
  local sb_w = sb.right_bottom.x - sb.left_top.x
  local sb_h = (sb.right_bottom.y - sb.left_top.y + entity.prototype.drawing_box_vertical_extension)
  -- it seems that most entities have 4.5 tiles of padding in their vis?
  preview.style.minimal_width = (sb_w + 4.5) * 32 * zoom_min
  preview.style.minimal_height = sb_h * 32 * zoom_min

  preview.entity = entity

  return wrapper
end

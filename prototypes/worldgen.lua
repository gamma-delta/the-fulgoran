data:extend{
  {
    type = "autoplace-control",
    name = "pk_fulgora_start_1",
    category = "terrain",
  },
  {
    type = "autoplace-control",
    name = "pk_fulgora_start_2",
    category = "terrain",
  }
}

local fulgora_apc = data.raw["planet"]["fulgora"].map_gen_settings.autoplace_controls
fulgora_apc["pk_fulgora_start_1"] = {}
fulgora_apc["pk_fulgora_start_2"] = {}

-- by default these are 1.8 and 4
-- they look better both about doubled
-- BUT Because factorio is LAME, the sliders are BACKWARDS
local start_sz1 = "(control:pk_fulgora_start_1:frequency * 0.9)"
local start_sz2 = "(control:pk_fulgora_start_2:frequency * 2)"

data.raw["noise-expression"]["fulgora_starting_cone"].expression = [[
  max(0,
    starting_spot_at_angle{
      angle = map_seed / 360,
      distance = fulgora_grid / 30,
      radius = fulgora_grid / ]] .. start_sz1 .. [[,
      x_distortion = 1 * fulgora_wobble_x,
      y_distortion = 1 * fulgora_wobble_y
    },
    starting_spot_at_angle{
      angle = map_seed / 360,
      distance = 1,
      radius = fulgora_grid / ]] .. start_sz2 .. [[,
      x_distortion = 0.25 * fulgora_wobble_x,
      y_distortion = 0.25 * fulgora_wobble_y
    }
  )
]]
data.raw["noise-expression"]["fulgora_starting_vault_cone"].expression = [[
  max(
    0,
    starting_spot_at_angle{
      angle = map_seed / 360 + 180,
      distance = fulgora_grid / ]] .. start_sz1 .. [[,
      radius = fulgora_grid / ]] .. start_sz1 .. [[,
      x_distortion = 1 * fulgora_wobble_x,
      y_distortion = 1 * fulgora_wobble_y
    }
  )
]]

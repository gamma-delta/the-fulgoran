local tf_util = require("tf_util")

data:extend{
  -- Oxygen goes into pk-oxygen-diffuser, which puts Work into
  -- the internal entity. Withdraw work from the internal entity as
  -- necessary. If it reaches 0, then you start having problems!
  {
    type = "assembling-machine",
    name = "pk-oxygen-diffuser",
    icon = "__base__/graphics/icons/pump.png",
    flags = {"placeable-neutral", "player-creation", "get-by-unit-number"},
    minable = {mining_time=0.5, result="pk-oxygen-diffuser"},
    collision_box = {{-0.8, -0.8}, {0.8, 0.8}},
    selection_box = {{-1, -1}, {1, 1}},
    crafting_categories = {"pk-internal"},
    fixed_recipe = "pk-oxygen-diffuser",
    crafting_speed = 1,
    created_effect = tf_util.script_created_effect("pk-oxygen-diffuser"),
    energy_source = {
      type = "electric",
      usage_priority = "primary-input",
      buffer_capacity = "30kW",
    },
    energy_usage = "10kJ",

    fluid_boxes = {
      {
        production_type = "input",
        volume = 100,
        filter = "pk-oxygen",
        pipe_covers = pipecoverspictures(),
        pipe_connections = {{
          position = {-0.5, -0.5},
          direction = defines.direction.north,
          flow_direction = "input",
        }}
      },
      {
        production_type = "output",
        volume = 100,
        filter = "pk-work",
        pipe_connections = {{
          flow_direction = "output",
          connection_type = "linked",
          linked_connection_id = 1,
        }}
      },
    },

    graphics_set = {
      animation = {
        north = {
          layers = {
            {
              filename = "__pk-the-fulgoran__/graphics/entities/oxygen-diffuser/shadow.png",
              scale = 0.5,
              width = 164,
              height = 102,
              shift = {0.22, 0.25},
              draw_as_shadow = true,
              repeat_count = 16,
              animation_speed = 0.5,
            },
            {
              filename = "__pk-the-fulgoran__/graphics/entities/oxygen-diffuser/main.png",
              scale = 0.5,
              width = 150,
              height = 150,
              shift = {0, -0.1},
              animation_speed = 0.5,
              frame_count = 16,
              line_length = 4,
            },
          }
        }
      },
    }
  },
  {
    type = "valve",
    name = "pk-oxygen-diffuser-valve",
    icon = "__base__/graphics/icons/signal/signal-question-mark.png",
    flags = {"not-deconstructable", "not-blueprintable", "not-on-map"},
    collision_mask = {layers={}},
    selectable_in_game = false,
    -- so it appears in editor
    selection_priority = 200,
    collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
    selection_box = {{-0.3, -0.3}, {0.3, 0.3}},

    flow_rate = 100000,
    mode = "top-up",
    -- changed at runtime depending on room size
    threshold = 0.1,

    fluid_box = {
      -- i think the flow rate is locked on this
      volume = 1000,
      filter = "pk-oxygen",
      pipe_connections = {
        {
          flow_direction = "input-output",
          connection_type = "linked",
          linked_connection_id = 1,
        },
        {
          flow_direction = "output",
          connection_type = "linked",
          linked_connection_id = 2,
        }
      }
    }
  },
  {
    -- it can't be a normal pipeline entity because they don't allow
    -- linked connections.
    -- using a valve because it has little "extra behavior"
    -- the fluidbox lives on the input side, so i can't fold this
    -- together with the real valve
    type = "valve",
    name = "pk-oxygen-diffuser-storage",
    icon = "__base__/graphics/icons/signal/signal-question-mark.png",
    flags = {"not-deconstructable", "not-blueprintable", "not-on-map"},
    collision_mask = {layers={}},
    selectable_in_game = false,
    -- so it appears in editor
    selection_priority = 201,
    collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
    selection_box = {{-0.2, -0.2}, {0.2, 0.2}},
    mode = "one-way",
    flow_rate = 1,

    -- In all my math calculations, I'm assuming that 1 droplet of oxygen
    -- is 1 CC/1 mL. so 1000 == 1mL.
    -- I'm also assuming it's compressed to 1 mol/L, like in the Martian ...
    -- Air is like 20% oxygen. Assuming each tile of the Hab is 1m*1m*2m,
    -- that means i have 0.4 m^3 = 400mL oxygen per tile.
    -- Of course I'm going to summarily ignore all this for game balance,
    -- but it's fun to do math.
    -- Anyways, a million droplets of storage equals like 2500 tiles,
    -- which is a lot, that'll be fine
    fluid_box = {
      volume = 1e6,
      filter = "pk-oxygen",
      pipe_connections = {
        {
          flow_direction = "input-output",
          connection_type = "linked",
          linked_connection_id = 1,
        },
        {
          -- Unused
          flow_direction = "output",
          connection_type = "linked",
          linked_connection_id = 2,
        },
      }
    }
  }
}

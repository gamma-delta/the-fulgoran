data:extend{
  -- Crafting stuff
  util.merge{data.raw["item"]["low-density-structure"], {
    name = "pk-filter",
    icon = "__pk-the-fulgoran__/graphics/icons/filter.png",
  }},
  util.merge{data.raw["item"]["low-density-structure"], {
    name = "pk-dirty-filter",
    icon = "__pk-the-fulgoran__/graphics/icons/dirty-filter.png",
  }},

  util.merge{data.raw["item"]["refined-concrete"], {
    name = "pk-hab-floor",
    place_as_tile = {
      result = "pk-hab-floor",
    }
  }},

  util.merge{data.raw["item"]["pump"], {
    name = "pk-oxygen-diffuser",
    place_result = "pk-oxygen-diffuser",
  }},
  util.merge{data.raw["item"]["lightning-rod"], {
    name = "pk-lightning-rod",
    place_result = "pk-lightning-rod",
  }},
  util.merge{data.raw["item-with-entity-data"]["car"], {
    name = "pk-buggy",
    place_result = "pk-buggy",
  }},
}

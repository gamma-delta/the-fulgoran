data:extend{
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
}

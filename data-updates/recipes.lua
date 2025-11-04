-- Recycle accumulators to get lithium, for catalysis
data.raw["recipe"]["accumulator"].ingredients = {
  {type="item", name="battery", count=5},
  {type="item", name="iron-plate", count=2},
  -- 4 so that you're "guaranteed" one
  {type="item", name="lithium-plate", count=4},
}

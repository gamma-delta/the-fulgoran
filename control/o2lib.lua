local tf_util = require("tf_util")

local api = {}

api.assoc = function(id)
  if type(id) ~= "number" then
    id = id.unit_number
  end
  return tf_util.storage_table("oxygen-diffusers")[id]
end

api.get_max_o2 = function(diffuser)
  local assoc = api.assoc(diffuser)
  local limit_cc = assoc.limiter.get_or_create_control_behavior().circuit_condition
  return limit_cc.constant
end

api.set_max_o2 = function(diffuser, limit)
  local assoc = api.assoc(diffuser)
  local limit_cb = assoc.limiter.get_or_create_control_behavior()
  -- this is a table we need to write *back*
  local limit_cc = limit_cb.circuit_condition
  local old = limit_cc.constant
  limit_cc.constant = limit
  limit_cb.circuit_condition = limit_cc
  return old
end

-- Returns if it succeeded
api.sip_o2 = function(diffuser, sip_amt)
  local assoc = api.assoc(diffuser)
  local removed_amt = assoc.tank.remove_fluid{
    name="pk-work", amount=sip_amt
  }
  return (removed_amt + 1) >= sip_amt
end

return api

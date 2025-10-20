require("__core__/lualib/util.lua")

local handler = require("event_handler")
handler.add_libraries{
  require("control/scenario"),
  require("control/sealed-area"),
}

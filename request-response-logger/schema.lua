local typedefs = require "kong.db.schema.typedefs"

return {
  name = "request-response-log",
  fields = {
    {
      route = typedefs.no_route,
    },
    {
      service = typedefs.no_service,
    },
    {
      consumer = typedefs.no_consumer,
    },
    {
      protocols = typedefs.protocols_http,
    },
    {
      config = {
        type = "record",
        fields = {
            {  strip_claims = { type     = "string", required = true, default  = "false" }, },
        },
      },
    },
  },
}

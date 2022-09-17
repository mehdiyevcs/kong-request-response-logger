local kong = kong
local ngx = ngx

local http = require "resty.http"
local cjson = require "cjson"
local string = require "string"

local cjson2 = cjson.new()
local cjson_safe = require "cjson.safe"

local RequestResponseLogger = {
  VERSION = "1.0"
}

function RequestResponseLogger:access(conf)
  local httpc = http:new()

	ngx.req.read_body()
	local body_data = ngx.req.get_body_data()
	print("Request body is ", body_data)
	
	local res, err = httpc:request_uri("http://ms-request-verify:8080/api/v1/request-log", {
		method = "POST",
		ssl_verify = false,
		body = body_data,
		headers = {
			["Content-Type"] = "application/json",
			["X-Request-ID"] = ngx.req.get_headers()["X-Request-ID"]
		}
	})

	--Buffering should be enabled in order to get the response out of buffer
	kong.service.request.enable_buffering()
end

function RequestResponseLogger:response(conf)
	local httpc = http:new()
	print("Request body is ", kong.service.response.get_raw_body())
	local res, err = httpc:request_uri("http://ms-request-verify:8080/api/v1/response-log", {
			method = "POST",
			ssl_verify = false,
			body = cjson.encode(kong.service.response.get_raw_body()),
      headers = {
			  ["Content-Type"] = "application/json",
			  ["X-Request-ID"] = ngx.req.get_headers()["X-Request-ID"]
			}
		})
end

return RequestResponseLogger

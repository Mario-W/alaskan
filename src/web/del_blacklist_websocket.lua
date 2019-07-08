local utils = require('common.utils')
local alaskan_web_config = require('web.config')
local redis_handler = require('common.redis_handler')
local server = require "resty.websocket.server"

local wb, err = server:new{
    timeout = 12*30*60*60*24*1000,  -- in milliseconds
    max_payload_len = 65535,
}
if not wb then
    ngx.log(ngx.ERR, "failed to new websocket: ", err)
    return ngx.exit(444)
end


while true do
    local data, typ, err = wb:recv_frame()

    if not data then
        ngx.log(ngx.ERR, "failed to receive a frame: ", err)
        return ngx.exit(444)
    end

    if typ == "close" then
        -- send a close frame back:

        local bytes, err = wb:send_close(1000, "enough, enough!")
        if not bytes then
            ngx.log(ngx.ERR, "failed to send the close frame: ", err)
            return
        end
        local code = err
        ngx.log(ngx.INFO, "closing with status code ", code, " and message ", data)
        return
    end

    if typ == "ping" then
        -- send a pong frame back:

        local bytes, err = wb:send_pong(data)
        if not bytes then
            ngx.log(ngx.ERR, "failed to send frame: ", err)
            return
        end
    elseif typ == "pong" then
        -- just discard the incoming pong frame

    else
        local res, packed_data = pcall(utils.json_loads, data)
        if ngx.shared and ngx.shared.cache and alaskan_web_config.STORE_MODE == 'NGXCACHE_MYSQL' and res and packed_data.cache_key then
            ngx.shared.cache:delete(packed_data.cache_key)
            ngx.log(ngx.ERR, 'delete success!', ngx.shared.cache:get(packed_data.cache_key))
        end
    end
end

--wb:set_timeout(1000)  -- change the network timeout to 1 second
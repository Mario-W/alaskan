local server = require "resty.websocket.server"

local wb, err = server:new{
    timeout = 5000,  -- in milliseconds
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
        local cache_data, msg = ngx.shared.cache:get('ip=2.2.2.2')
        ngx.log(ngx.ERR, data, cache_data, msg)
    end
end

--wb:set_timeout(1000)  -- change the network timeout to 1 second

--bytes, err = wb:send_text("Hello world")
--if not bytes then
--    ngx.log(ngx.ERR, "failed to send a text frame: ", err)
--    return ngx.exit(444)
--end
--
--bytes, err = wb:send_binary("blah blah blah...")
--if not bytes then
--    ngx.log(ngx.ERR, "failed to send a binary frame: ", err)
--    return ngx.exit(444)
--end
--
--local bytes, err = wb:send_close(1000, "enough, enough!")
--if not bytes then
--    ngx.log(ngx.ERR, "failed to send the close frame: ", err)
--    return
--end
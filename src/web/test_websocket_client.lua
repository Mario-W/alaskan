local client = require "resty.websocket.client"
local wb, err = client:new()
local uri = "ws://127.0.0.1:8088/alaskan/test_websocket_server"
local ok, err = wb:connect(uri)
if not ok then
    ngx.say("failed to connect: " .. err)
    return
end

--local data, typ, err = wb:recv_frame()
--if not data then
--    ngx.say("failed to receive the frame: ", err)
--    return
--end

--ngx.say("received: ", data, " (", typ, "): ", err)

local count = 0
while true do
    local send_data = '{"cache_key":"ip=2.2.2.2","expire":1508068372.53,"cache_notice":"{\"timestamp\":1506756663.604,\"state\":\"notice\",\"decision\":\"reject\",\"expire\":1508068372.53,\"test\":0}","load_cache":"true"}'
    local bytes, err = wb:send_text(send_data)
    if not bytes then
        ngx.say("failed to send frame: ", err)
        return
    end
    print('success '..count)
    os.execute('sleep 1')
    count = count + 1
    if count == 10 then
        break
    end
end

--local bytes, err = wb:send_close()
--if not bytes then
--    ngx.say("failed to send frame: ", err)
--    return
--end
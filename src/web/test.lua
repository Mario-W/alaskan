local redis_handler = require('common.redis_handler')
local cmsgpack = require('cmsgpack')


local redis_common = redis_handler.init()
--local res, msg = redis_common.redis_obj:subscribe('notice_notify')
--
--print(res, msg)


--while true do
--    local res, msg = redis_common.redis_obj:read_reply()
--    if res then
--        for i=1, #res do
--            print(res[i])
--        end
--    end
--end


local packed_data = cmsgpack.pack({xxx=1, yyy=2})
print(packed_data)
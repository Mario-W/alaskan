local memcache_handler = require('common.memcache_handler')
local utils = require('common.utils')

local memcache_common, msg = memcache_handler:init()
local ok, msg = memcache_common:bpop('test_push_memcache_queue')
if ok ~= nil then
    local data = utils.json_loads(ok)
    print(type(data))
    for k, v in pairs(data) do
        print(k, v)
    end
else
    print(ok)
    print(msg)
end


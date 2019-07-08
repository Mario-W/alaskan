local memcache_handler = require('common.memcache_handler')

local memcache_common, msg = memcache_handler:init()
local ok, msg = memcache_common:push('test_push_memcache_queue', '{"xxx": "yyy", "yyy": "zzz"}')
print(ok)
print(msg)


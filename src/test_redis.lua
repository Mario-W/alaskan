--local cjson = require('cjson')
--package.path = package.path..';/Users/mario/code/alaskan/src/lua-cmsgpack/?.so;/Users/mario/code/alaskan/src/lua-cmsgpack/?.lua'
local redis = require('resty.redis')
local cmsgpack = require('cmsgpack')
local r = redis:new()
local ok, err = r:connect('127.0.0.1', 6379, {pool='lua_redis_pool'})
if not ok then
    ngx.say(err)
end
--r:auth('630131222')
--ngx.say(cjson.encode({res='ok'}))
--ngx.say(cjson.encode({res=tostring(r)}))
--ngx.say(cjson.encode({res=r:lpush('stalker_data', 1)}))

local cached_redis_obj = ngx.shared.cache:get('redis_obj')
ngx.say(cmsgpack.unpack(cached_redis_obj))
if cached_redis_obj then
    ngx.say('cached redis obj')
    ngx.say(type(cached_redis_obj))
    ngx.say(type(cmsgpack.unpack(cached_redis_obj)))
else
    local ok, err = ngx.shared.cache:set('redis_obj', cmsgpack.pack(r))
    if not ok then
        ngx.say(err)
    else
        ngx.say('cache redis obj success')
        ngx.say(cmsgpack.pack(r))
    end
end


local ok, err = r:set_keepalive(10000, 100)
if not ok then
    ngx.say('fail to set keepalive !', err)
    return
end

--r:lpush('stalker_data', 'test_lua_redis')
--res = r:get('test_lua_redis')
--ngx.say(res)
--return


local alaskan_web_config = require('web.config')
local utils = require('common.utils')
local mysql_handler = require('common.mysql_handler')
local redis_handler = require('common.redis_handler')
local memcache_handler = require('common.memcache_handler')
local ngxcache_handler = require('common.ngxcache_handler')


function sync_del_mysql(notice_loads_result)
    local mysql_common, msg = mysql_handler:init('alaskan_del_blacklist_pool')
    if not mysql_common then
        ngx.log(ngx.ERR, msg)
        ngx.say(msg)
    end

    local res, msg = mysql_common:update_to_accept(notice_loads_result)
    if not res then
        ngx.log(ngx.ERR, msg)
        ngx.say(msg)
    end
end


function del_redis_cache(redis_common, notice_loads_result)

    redis_common:del_redis_cache(notice_loads_result)

    redis_common.redis_obj:publish('alaskan_sync_cache', utils.json_dumps({action='del', body=notice_loads_result}))

    -- sync to db
    sync_del_mysql(notice_loads_result)

    local ok, msg = redis_common.redis_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.say('fail to set keepalive !', msg)
        ngx.exit(200)
    end
end


function del_memcache_cache(memcache_handler, notice_loads_result)

    memcache_handler:del_memcache_cache(notice_loads_result)

    -- sync to db
    sync_del_mysql(notice_loads_result)

    local ok, msg = memcache_handler.memcache_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.say('fail to set keepalive !', msg)
        ngx.exit(200)
    end
end

function del_ngxcache_cache(redis_common, notice_loads_result)

    local query_strategy = notice_loads_result['check_type']

    if query_strategy == nil then
        return
    end

    local query_strategy_list = utils.split(query_strategy, ',')

    for index, strategy in pairs(query_strategy_list) do
        -- 每个查询key
        local cache_key = utils.generate_cache_key(notice_loads_result, strategy)
        ngxcache_handler.delete(cache_key)
    end

    redis_common.redis_obj:publish('alaskan_sync_cache', utils.json_dumps({action='del', body=notice_loads_result}))

    -- sync to db
    sync_del_mysql(notice_loads_result)

    local ok, msg = redis_common.redis_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.say('fail to set keepalive !', msg)
        ngx.exit(200)
    end

end


-- request entry
local notice = ngx.var.arg_notice
if notice == nil then
    ngx.say(utils.json_dumps({res='error', msg='No notice arguments!'}))
    ngx.exit(200)
end

notice = ngx.unescape_uri(notice)

local res, notice_loads_result = utils.verify_token(notice)
if not res then
    ngx.say(notice_loads_result)
    ngx.exit(200)
end

if alaskan_web_config.STORE_MODE == 'REDIS_MYSQL' then

    local redis_common, msg = redis_handler:init('alaskan_del_blacklist_pool')
    if not redis_common or redis_common.redis_obj:get('alaskan_enable_cache') == 'false' then
        sync_del_mysql(notice_loads_result)
    else
        del_redis_cache(redis_common, notice_loads_result)
    end

    ngx.say(utils.json_dumps({res='ok', msg='del blacklist success!'}))
    ngx.exit(200)

elseif alaskan_web_config.STORE_MODE == 'MEMCACHE_MYSQL' then

    local memcache_common, msg = memcache_handler:init()
    if not memcache_common or memcache_common.memcache_obj:get('alaskan_enable_cache') == 'false' then
        sync_del_mysql(notice, notice_loads_result)
    else
        del_memcache_cache(memcache_common, notice_loads_result)
    end

    ngx.say(utils.json_dumps({res='ok', msg='del blacklist success!'}))
    ngx.exit(200)

elseif alaskan_web_config.STORE_MODE == 'NGXCACHE_MYSQL' then
    if not ngx.shared or not ngx.shared.cache or ngx.shared.cache:get('alaskan_enable_cache') == 'false' then
        sync_del_mysql(notice_loads_result)
    else
        local redis_common, msg = redis_handler:init('alaskan_del_blacklist_pool')
        if not redis_common then
            ngx.log(ngx.ERR, msg)
        else
            del_ngxcache_cache(redis_common, notice_loads_result)
        end
    end

    ngx.say(utils.json_dumps({res='ok', msg='del blacklist success!'}))
    ngx.exit(200)

elseif alaskan_web_config.STORE_MODE == 'MYSQL' then
    sync_del_mysql(notice_loads_result)

    ngx.say(utils.json_dumps({res='ok', msg='del blacklist success!'}))
    ngx.exit(200)
else
    ngx.say(utils.json_dumps({res='error', msg='there has no store mode to set!'}))
end

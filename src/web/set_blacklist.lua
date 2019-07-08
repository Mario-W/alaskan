local alaskan_web_config = require('web.config')
local utils = require('common.utils')
local mysql_handler = require('common.mysql_handler')
local redis_handler = require('common.redis_handler')
local memcache_handler = require('common.memcache_handler')
local ngxcache_handler = require('common.ngxcache_handler')


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

local save_db = true

if alaskan_web_config.STORE_MODE == 'REDIS_MYSQL' then

    local redis_common, msg = redis_handler:init('alaskan_set_blacklist_pool')
    if not redis_common or redis_common.redis_obj:get('alaskan_enable_cache') == 'false' then
        local mysql_common, msg = mysql_handler:init('alaskan_set_blacklist_pool')
        if not mysql_common then
            ngx.say(msg)
            ngx.exit(200)
        end
        mysql_common:sync_set_mysql(notice_loads_result)
    else
        redis_common.redis_obj:publish('alaskan_sync_cache', utils.json_dumps({action='set', body=notice_loads_result}))
        redis_common:set_redis_cache(notice_loads_result, save_db)
    end

    ngx.say(utils.json_dumps({res='ok', msg='set blacklist success!'}))
    ngx.exit(200)

elseif alaskan_web_config.STORE_MODE == 'MEMCACHE_MYSQL' then

    local memcache_common, msg = memcache_handler:init()
    if not memcache_common or memcache_common.memcache_obj:get('alaskan_enable_cache') == 'false' then
        local mysql_common, msg = mysql_handler:init('alaskan_set_blacklist_pool')
        if not mysql_common then
            ngx.say(msg)
            ngx.exit(200)
        end
        mysql_common:sync_set_mysql(notice_loads_result)
    else
        memcache_common:set_memcache_cache(notice_loads_result, save_db)
    end

    ngx.say(utils.json_dumps({res='ok', msg='set blacklist success!'}))
    ngx.exit(200)

elseif alaskan_web_config.STORE_MODE == 'NGXCACHE_MYSQL' then
    local redis_common, msg = redis_handler:init('alaskan_set_blacklist_pool')
    if not redis_common or not ngx.shared or not ngx.shared.cache or ngx.shared.cache:get('alaskan_enable_cache') == 'false' then
        local mysql_common, msg = mysql_handler:init('alaskan_set_blacklist_pool')
        if not mysql_common then
            ngx.say(msg)
            ngx.exit(200)
        end
        mysql_common:sync_set_mysql(notice_loads_result)
    else
        redis_common.redis_obj:publish('alaskan_sync_cache', utils.json_dumps({action='set', body=notice_loads_result}))
        ngxcache_handler.set_ngxcache_cache(redis_common.redis_obj, notice_loads_result, save_db)
    end

    ngx.say(utils.json_dumps({res='ok', msg='set blacklist success!'}))
    ngx.exit(200)

elseif alaskan_web_config.STORE_MODE == 'MYSQL' then

    local mysql_common, msg = mysql_handler:init('alaskan_set_blacklist_pool')
    if not mysql_common then
        ngx.say(msg)
        ngx.exit(200)
    end

    mysql_common:sync_set_mysql(notice_loads_result)

    ngx.say(utils.json_dumps({res='ok', msg='set blacklist success!'}))
    ngx.exit(200)
else
    ngx.say(utils.json_dumps({res='error', msg='there has no store mode to set!'}))
end
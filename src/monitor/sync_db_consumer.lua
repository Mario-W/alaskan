local utils = require('common.utils')
local redis_handler = require('common.redis_handler')
local memcache_handler = require('common.memcache_handler')
local ngxcache_handler = require('common.ngxcache_handler')
local mysql_handler = require('common.mysql_handler')
local alaskan_web_config = require('web.config')


function sync_from_redis(redis_common, mysql_common)

    redis_common.redis_obj:add_commands('brpop')
    while true do
        local notice_data = redis_common.redis_obj:brpop('set_blacklist_queue', 60*60*24*30)

        local res, notice_load_data = pcall(utils.json_loads, notice_data[2])
        if not res then
            print(notice_load_data)
        else
            local res, msg = mysql_common:sync_set_mysql(notice_load_data)
            if not res then
                print(msg)
            else
                print('sync from redis success!')
            end
        end
    end

end

function sync_from_memcache(memcache_common, mysql_common)

    while true do
        local notice_data = memcache_common:bpop('set_blacklist_queue', 10000)
        local notice_load_data, msg = pcall(utils.json_loads(notice_data))
        if not notice_load_data then
            print(msg)
        else
            local res, msg = mysql_common:sync_set_mysql(notice_load_data)
            if not res then
                print(msg)
            else
                print('sync from memcache success!')
            end
        end
    end
end


function sync_from_ngxcache(mysql_common)
    while true do
        local notice_data = ngxcache_handler.bpop('set_blacklist_queue', 10000)
        local notice_load_data, msg = pcall(utils.json_loads(notice_data))
        if not notice_load_data then
            print(msg)
        else
            local res, msg = mysql_common:sync_set_mysql(notice_load_data)
            if not res then
                print(msg)
            else
                print('sync from memcache success!')
            end
        end
    end
end


if alaskan_web_config.STORE_MODE == 'REDIS_MYSQL' then

    local redis_common, msg = redis_handler:init('alaskan_set_blacklist_pool')
    if not redis_common then
        print(msg)
        return
    end
    local mysql_common, msg = mysql_handler:init('alaskan_set_blacklist_pool')
    if not mysql_common then
        print(msg)
        return
    end
    if redis_common.redis_obj:get('alaskan_enable_cache') == 'false' then
        print('Disabled redis cache')
        return
    end

    sync_from_redis(redis_common, mysql_common)

elseif alaskan_web_config.STORE_MODE == 'MEMCACHE_MYSQL' then

    local memcache_common, msg = memcache_handler:init('alaskan_set_blacklist_pool')
    if not memcache_common then
        print(msg)
        return
    end
    local mysql_common, msg = mysql_handler:init('alaskan_set_blacklist_pool')
    if not mysql_common then
        print(msg)
        return
    end
    local res, msg = memcache_common.memcache_obj:get('alaskan_enable_cache')
    if res == 'false' then
        print('Disabled memcache cache')
        return
    end

    sync_from_memcache(memcache_common, mysql_common)

elseif alaskan_web_config.STORE_MODE == 'NGXCACHE_MYSQL' then

--    local mysql_common, msg = mysql_handler:init('alaskan_set_blacklist_pool')
--    if not mysql_common then
--        print(msg)
--        return
--    end
--    local res, msg = ngxcache_handler.get('alaskan_enable_cache')
--    if res == 'false' then
--        print('Disabled memcache cache')
--        return
--    end
--
--    sync_from_ngxcache(mysql_common)

    -- external process can not share ngx shared cache. then use redis queue
    -- TODO try to use websocket do sync db.
    local redis_common, msg = redis_handler:init('alaskan_set_blacklist_pool')
    if not redis_common then
        print(msg)
        return
    end
    local mysql_common, msg = mysql_handler:init('alaskan_set_blacklist_pool')
    if not mysql_common then
        print(msg)
        return
    end
    if redis_common.redis_obj:get('alaskan_enable_cache') == 'false' then
        print('Disabled redis cache')
        return
    end

    sync_from_redis(redis_common, mysql_common)
end
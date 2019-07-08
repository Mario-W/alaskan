-- 考虑到数据量逐渐增大的情况，在定时同步、以及缓存停机或变动机器后，需要高性能快速同步数据到缓存，用lua脚本实现

local alaskan_web_config = require('web.config')
local redis_handler = require('common.redis_handler')
local mysql_handler = require('common.mysql_handler')
local memcache_handler = require('common.memcache_handler')
local utils = require('common.utils')
local offset = 50000  -- 查询mysql 每次offset
local interval = 60*60*24  -- update cache interval


function update_redis_cache()
    local mysql_common, msg = mysql_handler:init()
    if not mysql_common then
        print(msg)
        return
    end
    local redis_common, msg = redis_handler:init()
    if not redis_common then
        print(msg)
        return
    end

    local redis_pipeline, msg = redis_handler:init()
    if not redis_pipeline then
        print(msg)
        return
    end

    if redis_common.redis_obj:get('alaskan_enable_cache') == 'false' then
        print('Not enable cache. would not update cache!')
        return
    end

    local pos = 0
    while true do
        print('select * from notice offset '..pos..' limit '..offset)
        local data = mysql_common.mysql_obj:query('select * from notice limit '..offset..' offset '..pos)
        if #data == 0 then
            break
        end

        redis_pipeline.redis_obj:init_pipeline()
        for i=1, #data do
            if data[i]['check_type'] then
                -- 需要cache 打包cache数据
                local cache_notice = {}
                cache_notice['decision'] = data[i]['decision']
                cache_notice['test'] = data[i]['test']
                cache_notice['state'] = 'notice'
                cache_notice['timestamp'] = ngx.now()
                cache_notice['expire'] = data[i]['expire']
                -- 拼接cache key：ip=xxx&did=xxx 格式
                local cache_key_fields = utils.split(data[i]['notice_keys'], ',')
                for cache_key_index=1, #cache_key_fields do
                    local cache_key = cache_key_fields[cache_key_index]
                    local cached_data = redis_common.redis_obj:get(cache_key)
                    local res, cached_data = pcall(utils.json_loads, cached_data)
                    if res then
                        -- 如果db数据比cache数据新，且两者不同，则update
                        if cached_data['timestamp'] < data[i]['timestamp'] and cached_data ~= cache_notice then
                            redis_pipeline.redis_obj:set(cache_key, cache_notice)
                            if data[i]['expire'] then
                                redis_pipeline.redis_obj:expire(cache_key, (data[i]['expire']-ngx.now()*1000)/1000)
                            end
                        end
                    end
                end
            end
        end
        redis_pipeline.redis_obj:commit_pipeline()
        pos = pos + offset
    end
end


function update_memcache_cache()
    local mysql_common, msg = mysql_handler:init()
    if not mysql_common then
        print(msg)
        return
    end

    local memcache_common, msg = memcache_handler:init()
    if not memcache_common then
        print(msg)
        return
    end

    local enable_cache, msg = memcache_common.memcache_obj:get('alaskan_enable_cache')
    if enable_cache == 'false' then
        print('Disable cache. would not update cache!')
        return
    end

    local pos = 0
    while true do
        local data = mysql_common.mysql_obj:query('select * from notice limit '..offset..' offset '..pos)
        if #data == 0 then
            break
        end

        for i=1, #data do
            if data[i]['check_type'] then
                -- 需要cache 打包cache数据
                local cache_notice = {}
                cache_notice['decision'] = data[i]['decision']
                cache_notice['test'] = data[i]['test']
                cache_notice['state'] = 'notice'
                cache_notice['timestamp'] = ngx.now()
                cache_notice['expire'] = data[i]['expire']
                -- 拼接cache key：ip=xxx&did=xxx 格式
                local cache_key_fields = utils.split(data[i]['notice_keys'], ',')
                for cache_key_index=1, #cache_key_fields do
                    local cache_key = cache_key_fields[cache_key_index]
                    local cached_data = memcache_common.memcache_obj:get(cache_key)
                    local res, cached_data = pcall(utils.json_loads, cached_data)
                    if res then
                        -- 如果db数据比cache数据新，且两者不同，则update
                        if cached_data['timestamp'] < data[i]['timestamp'] and cached_data ~= cache_notice then
                            if data[i]['expire'] then
                                memcache_common.memcache_obj:set(
                                    cache_key, cache_notice, (data[i]['expire']-ngx.now()*1000)/1000)
                            else
                                memcache_common.memcache_obj:set(cache_key, cache_notice)
                            end
                        end
                    end
                end
            end
        end
        pos = pos + offset
    end
end


function load_ngxcache_cache(wb)

    local mysql_common, msg = mysql_handler:init()
    if not mysql_common then
        print(msg)
        return
    end

    local pos = 0
    while true do
        local data = mysql_common.mysql_obj:query('select * from notice limit '..offset..' offset '..pos)
        if #data == 0 then
            break
        end

        for i=1, #data do
            if data[i]['check_type'] then
                -- 需要cache 打包cache数据
                local cache_notice = {}
                cache_notice['decision'] = data[i]['decision']
                cache_notice['test'] = data[i]['test']
                cache_notice['state'] = 'notice'
                cache_notice['timestamp'] = ngx.now()
                cache_notice['expire'] = data[i]['expire']
                -- 拼接cache key：ip=xxx&did=xxx 格式
                local cache_key_fields = utils.split(data[i]['notice_keys'], ',')
                for cache_key_index=1, #cache_key_fields do
                    local cache_key = cache_key_fields[cache_key_index]

                    if data[i]['expire'] then
                        local bytes, err = wb:send_text(utils.json_dumps({
                            cache_key=cache_key,
                            cache_notice=cache_notice,
                            load_cache='true',
                            expire=(data[i]['expire']-ngx.now()*1000)/1000
                        }))
                        if not bytes then
                            print(err)
                            return
                        end
                    else
                        local bytes, err = wb:send_text(utils.json_dumps({
                            cache_key=cache_key,
                            cache_notice=cache_notice,
                            load_cache='true'
                        }))
                        if not bytes then
                            print(err)
                            return
                        end
                    end
                end
            end
        end
        pos = pos + offset
    end
end


while true do
    if alaskan_web_config.STORE_MODE == 'REDIS_MYSQL' then
        update_redis_cache()
    elseif alaskan_web_config.STORE_MODE == 'MEMCACHE_MYSQL' then
        update_memcache_cache()
    elseif alaskan_web_config.STORE_MODE == 'NGXCACHE_MYSQL' then
        local client = require "resty.websocket.client"
        local wb, err = client:new()
        local uri = alaskan_web_config.WEBSOCKET_URI
        local ok, err = wb:connect(uri)
        if not ok then
            print(err)
            return
        end
        load_ngxcache_cache(wb)
    end
    os.execute('sleep '..interval)
end
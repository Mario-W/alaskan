local utils = require('common.utils')


local ngxcache_handler = {}


function ngxcache_handler.get(...)
    return ngx.shared.cache:get(...)
end


function ngxcache_handler.get_stale(...)
    -- get all keys include expired keys
    return ngx.shared.cache:get_stale(...)
end


function ngxcache_handler.safe_set(...)
    -- return error when set exist keys
    return ngx.shared.cache:safe_set(...)
end


function ngxcache_handler.set(...)
    return ngx.shared.cache:set(...)
end


function ngxcache_handler.add(...)
    return ngx.shared.cache:add(...)
end


function ngxcache_handler.incr(...)
    return ngx.shared.cache:incr(...)
end


function ngxcache_handler.replace(...)
    -- return error when key is not exist
    return ngx.shared.cache:replace(...)
end


function ngxcache_handler.delete(...)
    return ngx.shared.cache:delete(...)
end


function ngxcache_handler.push(queue_name, data)
    if not queue_name and type(queue_name) ~= 'string' then
        return nil, 'queue name is invalid.'
    end
    if not data then
        return nil, 'push data should not be none.'
    end

    local product_counter_name = 'alaskan_'..queue_name..'_product_counter'
    local cache_data, msg = ngx.shared.cache:get(product_counter_name)
    if cache_data == nil then
        local ok, msg = ngx.shared.cache:set(product_counter_name, 0)
        if not ok then
            return nil, msg
        end
    end

    local current_num, msg = ngx.shared.cache:incr(product_counter_name, 1)
    if current_num == nil then
        return nil, msg
    end
    local notice_data_key = 'alaskan_'..queue_name..'_data_'..current_num
    local ok, msg = ngx.shared.cache:set(notice_data_key, data)
    if ok == nil then
        return nil, msg
    end

    return true, 'push success!'
end


function pop_data(queue_name)
    local product_counter_name = 'alaskan_'..queue_name..'_product_counter'
    local consumer_counter_name = 'alaskan_'..queue_name..'_consumer_counter'

    local consumer_count, msg = ngx.shared.cache:get(consumer_counter_name)
    if consumer_count == nil then
        local ok, msg = ngx.shared.cache:set(consumer_counter_name, 0)
        if not ok then
            return nil, msg
        end
        consumer_count = 0
    end

    local product_count, msg = ngx.shared.cache:get(product_counter_name)
    if product_count == nil then
        product_count = 0
    end
    consumer_count = tonumber(consumer_count)
    product_count = tonumber(product_count)
    if not consumer_count or not product_count then
        return nil, 'can not convert consumer count or product count to number!'
    end
    if consumer_count < product_count then
        local current_num, msg = ngx.shared.cache:incr(consumer_counter_name, 1)
        if current_num == nil then
            return nil, msg
        end
        local data, msg = ngx.shared.cache:get('alaskan_'..queue_name..'_data_'..current_num)
        if not data then
            return nil, msg
        else
            local ok, msg = ngx.shared.cache:set('alaskan_'..queue_name..'_data_'..current_num, data, 0)
            if not ok then
                return nil, msg
            end
            return data, nil
        end
    end
end


function ngxcache_handler.pop(queue_name)
    if not queue_name and type(queue_name) ~= 'string' then
        return nil, 'queue name is invalid.'
    end

    return pop_data(queue_name)
end


function ngxcache_handler.bpop(queue_name)
    if not queue_name and type(queue_name) ~= 'string' then
        return nil, 'queue name is invalid.'
    end

    while true do
        local data, msg = pop_data(queue_name)
        if not data then
            utils.sleep(0.01)
        else
            return data, msg
        end
    end
end


function ngxcache_handler.set_ngxcache_cache(redis_obj, notice_loads_result, save_db)
    local expire_time = notice_loads_result['expire']
    local query_strategy = notice_loads_result['check_type']
    local decision = notice_loads_result['decision']

    if query_strategy == nil then
        return
    end

    local notice_keys = {}
    if decision == 'reject' then
        local query_strategy_list = utils.split(query_strategy, ',')

        for index, strategy in pairs(query_strategy_list) do
            -- 每个查询key
            local cache_key = utils.generate_cache_key(notice_loads_result, strategy)
            table.insert(notice_keys, cache_key)
            local cache_data = {
                    decision=notice_loads_result['decision'],
                    test=notice_loads_result['test'],
                    state='notice',
                    timestamp=ngx.now(),
                    expire=(expire_time or 0)/1000
                }
            if expire_time then
                ngxcache_handler.set(cache_key, cache_data, (expire_time-ngx.now()*1000)/1000)
            else
                ngxcache_handler.set(cache_key, cache_data)
            end
        end
    end

    if save_db then
        notice_loads_result['notice_keys'] = table.concat(notice_keys, ',')
            -- sync to db
        --    local ok, msg = ngxcache_handler.push('set_blacklist_queue', notice)
        --    if not ok then
        --        ngx.say('fail to sync db!', msg)
        --        nax.exit(200)
        --    end
        -- external process can not share ngx shared cache. then use redis queue
        -- TODO try to use websocket do sync db.
        redis_obj:lpush('set_blacklist_queue', utils.json_dumps(notice_loads_result))
    end
    local ok, msg = redis_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.say('fail to set keepalive !', msg)
        ngx.exit(200)
    end
end


function ngxcache_handler.set_ngxcache_cache_from_script(wb, redis_obj, notice_loads_result, save_db)
    local expire_time = notice_loads_result['expire']
    local query_strategy = notice_loads_result['check_type']
    local decision = notice_loads_result['decision']

    if query_strategy == nil then
        return
    end

    local notice_keys = {}
    if decision == 'reject' then
        local query_strategy_list = utils.split(query_strategy, ',')

        for index, strategy in pairs(query_strategy_list) do
            -- 每个查询key
            local cache_key = utils.generate_cache_key(notice_loads_result, strategy)
            table.insert(notice_keys, cache_key)
            local cache_data = {
                    decision=notice_loads_result['decision'],
                    test=notice_loads_result['test'],
                    state='notice',
                    timestamp=ngx.now(),
                    expire=(expire_time or 0)/1000
                }

            local send_data = utils.json_dumps({
                cache_key=cache_key,
                cache_notice=cache_data,
                load_cache='true',
                expire=(expire_time-ngx.now() or 0)/1000
            })

            local bytes, err = wb:send_text(send_data)
            if not bytes then
                ngx.log(ngx.ERR, err)
                return
            else
                print('success')
            end
        end
    end

    if save_db then
        notice_loads_result['notice_keys'] = table.concat(notice_keys, ',')
        -- sync_set_mysql(notice_loads_result)
        redis_obj:lpush('set_blacklist_queue', utils.json_dumps(notice_loads_result))
    end
end


function ngxcache_handler.del_ngxcache_cache_nodes(wb, notice_loads_result)
    local query_strategy = notice_loads_result['check_type']

    if query_strategy == nil then
        return
    end

    local query_strategy_list = utils.split(query_strategy, ',')

    for index, strategy in pairs(query_strategy_list) do
        -- 每个查询key
        local cache_key = utils.generate_cache_key(notice_loads_result, strategy)
        local send_data = utils.json_dumps({
            cache_key=cache_key,
        })

        local bytes, err = wb:send_text(send_data)
        if not bytes then
            ngx.log(ngx.ERR, err)
            return
        else
            print('success')
        end
    end
end


return ngxcache_handler
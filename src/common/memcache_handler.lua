local memcache = require('resty.memcached')
local alaskan_web_config = require('web.config')
local utils = require('common.utils')


local memcache_handler = {}
local mt = {__index = memcache_handler}


function memcache_handler.init(self)
    local memcache_obj = memcache:new()

    memcache_obj:set_timeout(10000)

    local ok, err = memcache_obj:connect(
        alaskan_web_config.MEMCACHE_HOST,
        alaskan_web_config.MEMCACHE_PORT
    )
    if not ok then
        return ok, err
    end

    return setmetatable({memcache_obj = memcache_obj}, mt)
end


function memcache_handler.push(self, queue_name, data)
    if not queue_name and type(queue_name) ~= 'string' then
        return nil, 'queue name is invalid.'
    end
    if not data then
        return nil, 'push data should not be none.'
    end

    local product_counter_name = 'alaskan_'..queue_name..'_product_counter'
    local cache_data, msg = self.memcache_obj:get(product_counter_name)
    if cache_data == nil then
        local ok, msg = self.memcache_obj:set(product_counter_name, 0)
        if not ok then
            return nil, msg
        end
    end

    local current_num, msg = self.memcache_obj:incr(product_counter_name, 1)
    if current_num == nil then
        return nil, msg
    end
    local notice_data_key = 'alaskan_'..queue_name..'_data_'..current_num
    local ok, msg = self.memcache_obj:set(notice_data_key, data)
    if ok == nil then
        return nil, msg
    end

    return true, 'push success!'

end


function pop_data(memcache_obj, queue_name)
    local product_counter_name = 'alaskan_'..queue_name..'_product_counter'
    local consumer_counter_name = 'alaskan_'..queue_name..'_consumer_counter'

    local consumer_count, msg = memcache_obj:get(consumer_counter_name)
    if consumer_count == nil then
        local ok, msg = memcache_obj:set(consumer_counter_name, 0)
        if not ok then
            return nil, msg
        end
        consumer_count = 0
    end

    local product_count, msg = memcache_obj:get(product_counter_name)
    if product_count == nil then
        product_count = 0
    end
    consumer_count = tonumber(consumer_count)
    product_count = tonumber(product_count)
    if not consumer_count or not product_count then
        return nil, 'can not convert consumer count or product count to number!'
    end
    if consumer_count < product_count then
        local current_num, msg = memcache_obj:incr(consumer_counter_name, 1)
        if current_num == nil then
            return nil, msg
        end
        local data, msg = memcache_obj:get('alaskan_'..queue_name..'_data_'..current_num)
        if not data then
            return nil, msg
        else
            local ok, msg = memcache_obj:set('alaskan_'..queue_name..'_data_'..current_num, data, 0)
            if not ok then
                return nil, msg
            end
            return data, nil
        end
    end
end


function memcache_handler.pop(self, queue_name)
    if not queue_name and type(queue_name) ~= 'string' then
        return nil, 'queue name is invalid.'
    end

    return pop_data(self.memcache_obj, queue_name)
end


function memcache_handler.bpop(self, queue_name)
    if not queue_name and type(queue_name) ~= 'string' then
        return nil, 'queue name is invalid.'
    end

    while true do
        local data, msg = pop_data(self.memcache_obj, queue_name)
        if not data then
            utils.sleep(0.01)
        else
            return data, msg
        end
    end
end


function memcache_handler.set_memcache_cache(self, notice_loads_result, save_db)
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
            local cache_data = utils.json_dumps({
                    decision=notice_loads_result['decision'],
                    test=notice_loads_result['test'],
                    state='notice',
                    timestamp=ngx.now(),
                    expire=(expire_time or 0)/1000
                })
            if expire_time then
                self.memcache_obj:set(cache_key, cache_data, (expire_time-ngx.now()*1000)/1000)
            else
                self.memcache_obj:set(cache_key, cache_data)
            end
        end
    end

    notice_loads_result['notice_keys'] = table.concat(notice_keys, ',')

    if save_db then
        -- sync to db
        local ok, msg = self.memcache_obj:push('set_blacklist_queue', utils.json_dumps(notice_loads_result))
        if not ok then
            ngx.say('fail to sync db!', msg)
            nax.exit(200)
        end
    end

    local ok, msg = self.memcache_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.say('fail to set keepalive !', msg)
        ngx.exit(200)
    end
end


function memcache_handler.del_memcache_cache(self, notice_loads_result)
    local query_strategy = notice_loads_result['check_type']

    if query_strategy == nil then
        return
    end

    local query_strategy_list = utils.split(query_strategy, ',')

    for index, strategy in pairs(query_strategy_list) do
        -- 每个查询key
        local cache_key = utils.generate_cache_key(notice_loads_result, strategy)
        local ok, msg = self.memcache_obj:delete(cache_key)
        if not ok then
            ngx.log(ngx.ERR, msg)
            ngx.say(msg)
        end
    end
end


return memcache_handler
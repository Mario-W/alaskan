local redis = require('resty.redis')
local alaskan_web_config = require('web.config')
local utils = require('common.utils')
local rsa = require('resty.rsa')


local redis_handler = {}
local mt = {__index = redis_handler}


function redis_handler.init(self, pool)
    local redis_obj = redis:new()

    redis_obj:set_timeout(60*60*24*30)

    if pool ~= nil then
        local ok, err = redis_obj:connect(
            alaskan_web_config.REDIS_HOST,
            alaskan_web_config.REDIS_PORT,
            {pool=pool}
        )
        if not ok then
            return ok, err
        end
    else
        local ok, err = redis_obj:connect(
            alaskan_web_config.REDIS_HOST,
            alaskan_web_config.REDIS_PORT
        )
        if not ok then
            return ok, err
        end
    end

    if alaskan_web_config.REDIS_PASSWORD then

        local rsa_obj, err = rsa:new({ private_key = alaskan_web_config.RSA_PRIVATE_KEY })
        if not rsa_obj then
            return nil, err
        end

        local redis_password = rsa_obj:decrypt(ngx.decode_base64(alaskan_web_config.REDIS_PASSWORD))

        local ok, msg = redis_obj:auth(redis_password)
        if not ok then
            return ok, msg
        end
    end

    return setmetatable({redis_obj = redis_obj}, mt)
end


function redis_handler.set_redis_cache(self, notice_loads_result, save_db)
    local expire_time = notice_loads_result['expire']
    local query_strategy = notice_loads_result['check_type']
    local decision = notice_loads_result['decision']

    if query_strategy == nil then
        return
    end

    local query_strategy_list = utils.split(query_strategy, ',')
    local notice_keys = {}
    self.redis_obj:init_pipeline()

    if decision == 'reject' then
        for index, strategy in pairs(query_strategy_list) do
            -- 每个查询key
            local cache_key = utils.generate_cache_key(notice_loads_result, strategy)
            table.insert(notice_keys, cache_key)
            self.redis_obj:set(cache_key, utils.json_dumps({
                decision=notice_loads_result['decision'],
                test=notice_loads_result['test'],
                state='notice',
                timestamp=ngx.now(),
                expire=(expire_time or 0)/1000
            }))
            if expire_time then
                self.redis_obj:expire(cache_key, (expire_time-ngx.now()*1000)/1000)
            end
        end
    end

    notice_loads_result['notice_keys'] = table.concat(notice_keys, ',')

    if save_db then
        -- sync to db
        self.redis_obj:lpush('set_blacklist_queue', utils.json_dumps(notice_loads_result))
    end

    local ok, msg = self.redis_obj:commit_pipeline()
    if not ok then
        ngx.say('fail to set redis !', msg)
        ngx.exit(200)
    end

    local ok, msg = self.redis_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.say('fail to set keepalive !', msg)
        ngx.exit(200)
    end
end


function redis_handler.del_redis_cache(self, notice_loads_result)
    local query_strategy = notice_loads_result['check_type']

    if query_strategy == nil then
        return
    end

    local query_strategy_list = utils.split(query_strategy, ',')
    self.redis_obj:init_pipeline()

    for index, strategy in pairs(query_strategy_list) do
        -- 每个查询key
        local cache_key = utils.generate_cache_key(notice_loads_result, strategy)
        self.redis_obj:del(cache_key)
    end

    local ok, msg = self.redis_obj:commit_pipeline()
    if not ok then
        ngx.say('fail to set redis !', msg)
        ngx.exit(200)
    end

end


return redis_handler
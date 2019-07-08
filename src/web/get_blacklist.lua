local alaskan_web_config = require('web.config')
local utils = require('common.utils')
local redis_handler = require('common.redis_handler')
local mysql_handler = require('common.mysql_handler')
local memcache_handler = require('common.memcache_handler')
local ngxcache_handler = require('common.ngxcache_handler')


function get_notice_from_redis(redis_obj, query_args)
    local args_string = {}
    for k, v in pairs(query_args) do
        table.insert(args_string, k..'='..v)
    end
    args_string = table.concat(args_string, '&')

    local result = redis_obj:get(args_string)

    local ok, msg = redis_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.say('fail to set keepalive !', msg)
        return
    end

    if type(result) ~= 'userdata' and utils.json_loads(result)['state'] == 'notice' and tonumber(utils.json_loads(result)['expire']) > ngx.now() then
        ngx.say(true)
    else
        ngx.say(false)
    end
    return
end


function get_notice_from_memcache(memcache_obj, query_args)
    local args_string = {}
    for k, v in pairs(query_args) do
        table.insert(args_string, k..'='..v)
    end
    args_string = table.concat(args_string, '&')

    local result = memcache_obj:get(args_string)

    local ok, msg = memcache_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.say('fail to set keepalive !', msg)
        return
    end

    if type(result) ~= 'userdata' and utils.json_loads(result)['state'] == 'notice' and tonumber(utils.json_loads(result)['expire']) > ngx.now() then
        ngx.say(true)
    else
        ngx.say(false)
    end
    return
end


function get_notice_from_ngxcache(query_args)
    local args_string = {}
    for k, v in pairs(query_args) do
        table.insert(args_string, k..'='..v)
    end
    args_string = table.concat(args_string, '&')

    local result = ngxcache_handler.get(args_string)

    if result and type(result) ~= 'userdata' and utils.json_loads(result)['state'] == 'notice' and tonumber(utils.json_loads(result)['expire']) > ngx.now() then
        ngx.say(true)
    else
        ngx.say(false)
    end
    return
end


function get_notice_from_mysql(mysql_obj, query_args)
    local args_string = {}
    for k, v in pairs(query_args) do
        table.insert(args_string, k..'='..v)
    end
    args_string = table.concat(args_string, '&')
    local data, err = mysql_obj:query('select * from notice where notice_keys like "%'..args_string.. '%"')

    local ok, msg = mysql_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.say('fail to set keepalive !', msg)
        return
    end

    if not data then
        ngx.say(err)
    elseif #data == 0 then
        ngx.say(false)
    else
        local is_notice = false
        for i=1, #data do
            local notice_keys = data[i]['notice_keys']
            notice_keys = utils.split(notice_keys, ',')
            for j=1, #notice_keys do
                if notice_keys[j] == args_string and data[i]['decision'] == 'reject' and data[i]['expire'] > ngx.now() then
                    ngx.say(true)
                    is_notice = true
                    break
                end
            end
            if is_notice then
                break
            end
        end
        if not is_notice then
            ngx.say(false)
        end
    end
    return
end


-- request entry
local query_args = ngx.req.get_uri_args()
table.sort(query_args)

if alaskan_web_config.STORE_MODE == 'REDIS_MYSQL' then

    local redis_common, msg = redis_handler:init('alaskan_get_blacklist_pool')
    if not redis_common or redis_common.redis_obj:get('alaskan_enable_cache') == 'false' then
        local mysql_common, msg = mysql_handler:init('alaskan_get_blacklist_pool')
        if not mysql_common then
            ngx.say(msg)
            ngx.exit(200)
        end
        get_notice_from_mysql(mysql_common.mysql_obj, query_args)
        ngx.exit(200)
    else
        get_notice_from_redis(redis_common.redis_obj, query_args)
        ngx.exit(200)
    end

elseif alaskan_web_config.STORE_MODE == 'MEMCACHE_MYSQL' then
    local memcache_common, msg = memcache_handler:init()
    if not memcache_common or memcache_common.memcache_obj:get('alaskan_enable_cache') == 'false' then
        local mysql_common, msg = mysql_handler:init('alaskan_get_blacklist_pool')
        if not mysql_common then
            ngx.say(msg)
            ngx.exit(200)
        end
        get_notice_from_mysql(mysql_common.mysql_obj, query_args)
        ngx.exit(200)
    else
        get_notice_from_memcache(memcache_common.memcache_obj, query_args)
        ngx.exit(200)
    end

elseif alaskan_web_config.STORE_MODE == 'NGXCACHE_MYSQL' then
    if not ngxcache_handler or ngxcache_handler.get('alaskan_enable_cache') == 'false' then
        local mysql_common, msg = mysql_handler:init('alaskan_get_blacklist_pool')
        if not mysql_common then
            ngx.say(msg)
            ngx.exit(200)
        end
        get_notice_from_mysql(mysql_common.mysql_obj, query_args)
        ngx.exit(200)
    else
        get_notice_from_ngxcache(query_args)
        ngx.exit(200)
    end

elseif alaskan_web_config.STORE_MODE == 'MYSQL' then
    local mysql_common, msg = mysql_handler:init('alaskan_get_blacklist_pool')
    if not mysql_common then
        ngx.say(msg)
        ngx.exit(200)
    end
    get_notice_from_mysql(mysql_common.mysql_obj, query_args)
    ngx.exit(200)
else
    ngx.say('Have no STORE_MODE to set.')
    ngx.exit(200)
end
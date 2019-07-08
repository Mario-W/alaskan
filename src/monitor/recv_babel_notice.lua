-- babel为前期主要黑名单写入渠道，为了提供高性能写入，并且操作只需要订阅notice进行简单的format，用lua脚本实现

local utils = require('common.utils')
local redis_handler = require('common.redis_handler')
local memcache_handler = require('common.memcache_handler')
local ngxcache_handler = require('common.ngxcache_handler')
local mysql_handler = require('common.mysql_handler')
local alaskan_web_config = require('web.config')


local redis_common, msg = redis_handler:init()
if not redis_common then
    ngx.log(ngx.ERR, 'recv babel error: ', msg)
    return
end


local res, msg = redis_common.redis_obj:subscribe('notice_notify')
if not res then
    ngx.log(ngx.ERR, msg)
    return
end


local redis_pipeline, msg = redis_handler:init()
local memcache_common, msg = memcache_handler:init()


if alaskan_web_config.STORE_MODE == 'NGXCACHE_MYSQL' then
    local client = require "resty.websocket.client"
    local wb, err = client:new()
    local uri = alaskan_web_config.WEBSOCKET_URI
    local ok, err = wb:connect(uri)
    if not ok then
        ngx.log(ngx.ERR, err)
        return
    end
end


while true do
    local res, msg = redis_common.redis_obj:read_reply()
    if not res or not #res==3 or not type(res[3]) == 'string' then
        ngx.log(ngx.ERR, 'load notice error:', res)
        goto continue
    end

    local notice = res[3]
    local res, load_data = pcall(utils.json_loads, notice)
    if not res or not load_data.body then
        ngx.log(ngx.ERR, 'json loads error: ', res)
        goto continue
    end

    local babel_body_data = string.gsub(load_data.body, '\n', '')
    local b64decode_data = ngx.decode_base64(babel_body_data)
    local res, load_notice = pcall(utils.json_loads, b64decode_data)
    if not res then
        ngx.log(ngx.ERR, 'base64 decode error: ', res)
        goto continue
    end
    load_notice = load_notice.propertyValues

    local save_db = true
    if alaskan_web_config.STORE_MODE == 'REDIS_MYSQL' then
        if not redis_pipeline or redis_pipeline.redis_obj:get('alaskan_enable_cache') == 'false' then
            local mysql_common, msg = mysql_handler:init('alaskan_set_blacklist_pool')
            if not mysql_common then
                ngx.log(ngx.ERR, msg)
                goto continue
            else
                mysql_common:sync_set_mysql(load_notice)
            end
        else
            redis_pipeline.redis_obj:publish('alaskan_sync_cache', utils.json_dumps({action='set', body=load_notice}))
            redis_pipeline:set_redis_cache(load_notice, save_db)
        end
    elseif alaskan_web_config.STORE_MODE == 'MEMCACHE_MYSQL' then
        if not memcache_common or memcache_common.memcache_obj:get('alaskan_enable_cache') == 'false' then
            local mysql_common, msg = mysql_handler:init('alaskan_set_blacklist_pool')
            if not mysql_common then
                ngx.log(ngx.ERR, msg)
                goto continue
            else
                mysql_common:sync_set_mysql(load_notice)
            end
        else
            memcache_common:set_memcache_cache(load_notice, save_db)
        end

    elseif alaskan_web_config.STORE_MODE == 'NGXCACHE_MYSQL' then
        local redis_queue, msg = redis_handler:init()
        if not redis_queue then
            ngx.log(ngx.ERR, 'recv babel error: ', msg)
            goto continue
        end
        ngxcache_handler.set_ngxcache_cache_from_script(wb, redis_queue.redis_obj, load_notice, save_db)
        redis_queue.redis_obj:publish('alaskan_sync_cache', utils.json_dumps({action='set', body=load_notice}))

    elseif alaskan_web_config.STORE_MODE == 'MYSQL' then
        local mysql_common, msg = mysql_handler:init('alaskan_set_blacklist_pool')
        if not mysql_common then
            ngx.log(ngx.ERR, msg)
            goto continue
        else
            mysql_common:sync_set_mysql(load_notice)
        end
    else
        ngx.log(ngx.ERR, 'load notice error:', res)
    end

    ::continue::
end
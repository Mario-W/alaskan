-- 这里用作多节点部署下缓存同步脚本，接收节点publish，所有节点subscribe，订阅到notice若本地缓存没有或不一致则刷新缓存

local utils = require('common.utils')
local redis_handler = require('common.redis_handler')
local memcache_handler = require('common.memcache_handler')
local ngxcache_handler = require('common.ngxcache_handler')
local alaskan_web_config = require('web.config')


local redis_common, msg = redis_handler:init()
if not redis_common then
    ngx.log(ngx.ERR, 'recv babel error: ', msg)
    return
end

local res, msg = redis_common.redis_obj:subscribe('alaskan_sync_cache')
if not res then
    ngx.log(ngx.ERR, msg)
    return
end

local redis_pipeline, msg = redis_handler:init()
local memcache_common, msg = memcache_handler:init()

local client = require "resty.websocket.client"
local wb, err = client:new()
local uri = alaskan_web_config.WEBSOCKET_URI
local ok, err = wb:connect(uri)
if not ok then
    ngx.log(ngx.ERR, err)
    return
end

local client = require "resty.websocket.client"
local del_wb, err = client:new()
local uri = alaskan_web_config.DEL_WEBSOCKET_URI
local ok, err = del_wb:connect(uri)
if not ok then
    ngx.log(ngx.ERR, err)
    return
end


while true do

    local res, msg = redis_common.redis_obj:read_reply()
    if not res or not #res==3 or not type(res[3]) == 'string' then
        ngx.log(ngx.ERR, 'load notice error:', res)
        goto continue
    end

    local notice = res[3]
    local res, load_data = pcall(utils.json_loads, notice)
    if not res or not load_data then
        ngx.log(ngx.ERR, 'json loads error: ', res)
        goto continue
    end

    local load_notice = load_data.body
    local action = load_data.action

    if alaskan_web_config.STORE_MODE == 'REDIS_MYSQL' then

        if not redis_pipeline then
            ngx.log(ngx.ERR, 'have no redis pipeline to set cache')
            goto continue
        else
            if action == 'set' then
                redis_pipeline:set_redis_cache(load_notice)
            elseif action == 'del' then
                redis_pipeline:del_redis_cache(load_notice)
            end
        end
    elseif alaskan_web_config.STORE_MODE == 'MEMCACHE_MYSQL' then

        if not memcache_common then
            ngx.log(ngx.ERR, 'have no memcache obj to set cache!')
            goto continue
        else
            memcache_common:set_memcache_cache(load_notice)
        end

    elseif alaskan_web_config.STORE_MODE == 'NGXCACHE_MYSQL' then
        local redis_queue, msg = redis_handler:init()
        if not redis_queue then
            ngx.log(ngx.ERR, 'recv babel error: ', msg)
            goto continue
        end
        if action == 'set' then
            ngxcache_handler.set_ngxcache_cache_from_script(wb, redis_queue.redis_obj, load_notice)
        elseif action == 'del' then
            ngxcache_handler.del_ngxcache_cache_nodes(del_wb, load_notice)
        end
    end
    ::continue::
end
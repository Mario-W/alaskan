local utils = require('common.utils')
local redis_handler = require('common.redis_handler')
local mysql_handler = require('common.mysql_handler')


local PufaAPI = {}
local mt = {__index = PufaAPI }

function PufaAPI.new(self)
    return setmetatable({}, mt)
end

function PufaAPI.handle_request(self, url)
    if string.gmatch(url, '/cisvr/services/getActivityDeviceRisk')() then
        -- 活动风险查询接口
        self:get_activity_device_risk()
    elseif string.gmatch(url, '/cisvr/services/getDeviceRiskWithSessionId')() then
        -- 营销APP风险查询接口
        self:get_mmkt_device_risk()
    elseif string.gmatch(url, '/cisvr/services/getDidRiskTags')() then
        -- 极速办卡风险查询接口
        self:get_jsbk_device_risk()
    else
        ngx.say(utils.json_dumps({res = 'error', msg = 'could not find this url!'}))
    end
end

function PufaAPI.get_activity_device_risk(self)
    local session_id = ngx.var.arg_session_id
    local did_version = ngx.var.arg_did_version or '2.1.0'
    local channel = ngx.var.arg_channel
    local action = ngx.var.arg_action

    local error_response = utils.json_dumps({rspCode='111111', rspBody={}})

    local redis_common, msg = redis_handler:init('alaskan_pf_api_pool')
    if not redis_common then
        ngx.log(ngx.ERR, msg)
        ngx.say(error_response)
        ngx.exit(ngx.OK)
    end

    local msg_key = string.format('%s.%s.%s', session_id, channel, action)
    local msg_cache = redis_common.redis_obj:get(msg_key)
    if msg_cache and not msg_cache == 'null' and not msg_cache == 'userdata' then
        ngx.say(msg_cache)
        ngx.exit(ngx.OK)
    end

    local version_number_table = {}
    did_version = string.gmatch(did_version, '%d+')
    for number in did_version do
        table.insert(version_number_table, number)
    end
    local stalker_version = table.concat(version_number_table, '')

    local device_id = string.format('did_2%s%s', stalker_version, session_id)

    local cached_device_id = redis_common.redis_obj:get(string.format('sessionid_did_map_%s', device_id))
    if cached_device_id and not msg_cache == 'null' and not msg_cache == 'userdata' then
        device_id = cached_device_id
    end

    local cached_map_did = redis_common.redis_obj:get(string.format('did_map_%s', device_id))
    if cached_map_did and not msg_cache == 'null' and not msg_cache == 'userdata' then
        device_id = cached_map_did
    end

    local rsp_body = {}
    if action == 'ACTIVITY' then
        local cached_warning = redis_common.redis_obj:get(
            string.format('%s_%s_did_risk_info', device_id, channel))
        if not cached_warning or type(cached_warning) == 'userdata' or cached_warning == 'null' then
            cached_warning = '{}'
        end
        local did_risk_info = utils.json_loads(cached_warning)
        if did_risk_info.is_risk and did_risk_info.is_risk ~= 0 then
            rsp_body = {session_id=session_id, is_risk='1', risk_tags=did_risk_info.risk_list}
        else
            rsp_body = {session_id=session_id, is_risk='0'}
        end
    else
        ngx.say(error_response)
        ngx.exit(ngx.OK)
    end

    local response = utils.json_dumps({rspCode='000000', rspBody=rsp_body})
    if rsp_body.is_risk == '1' then
        redis_common.redis_obj:set(msg_key, response, 15552000)
    end

    -- TODO push api data
--    redis_common.redis_obj:lpush('api', 'xxx')

    local ok, msg = redis_common.redis_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.log(ngx.ERR, msg)
        ngx.say(error_response)
        ngx.exit(200)
    end

    ngx.say(response)
    ngx.exit(ngx.OK)
end


function PufaAPI.get_mmkt_device_risk(self)

    local sessionid = ngx.var.arg_sessionId
    local user_id = ngx.var.arg_userId
    local detect_type = ngx.var.arg_type
    local channel = ngx.var.arg_channel
    local action = ngx.var.arg_action

    local error_response = utils.json_dumps({rspCode='111111', rspBody={}})

    local source = '1'  -- app:'1'  pc:'2'
    if not string.upper(detect_type) == 'SDK' then
        source = '2'
    end
    local stalker_version = '210'
    local device_id = string.format('did_%s%s%s', source, stalker_version, sessionid)

    local redis_common, msg = redis_handler:init('alaskan_pf_api_pool')
    if not redis_common then
        ngx.log(ngx.ERR, msg)
        ngx.say(error_response)
        ngx.exit(ngx.OK)
    end

    local cached_device_id = redis_common.redis_obj:get(string.format('sessionid_did_map_%s', device_id))
    if cached_device_id and not type(cached_device_id) == 'userdata' and not cached_device_id == 'null' then
        device_id = cached_device_id
    end

    local cached_map_did = redis_common.redis_obj:get(string.format('did_map_%s', device_id))
    if cached_map_did and not type(cached_map_did) == 'userdata' and not cached_map_did == 'null' then
        device_id = cached_map_did
    end

    local did_risk_flag = 0
    local uid_risk_flag = 0
    local user_id = string.format('uid_%s', user_id)

    local cached_data = redis_common.redis_obj:get('cache_warning_list')
    if not cached_data or type(cached_data) == 'userdata' or cached_data == 'null' then
        cached_data = '{}'
    end
    local cache_warning_list = utils.json_loads(cached_data).data
    local cached_rule_id_list = {}
    if cache_warning_list then
        for i=1, #cache_warning_list do
            table.insert(cached_rule_id_list, cache_warning_list[i].rule_id)
        end
    end

    if channel == 'MMKT' and action == 'MMKTClient' then
        local did_risk_list = {}
        local uid_risk_list = {}
        local has_cached_multi_uid = false
        local has_cached_multi_did = false
        for i=1, #cached_rule_id_list do
            if cached_rule_id_list[i] == 'mmkt_mmktclient_multi_uid' then
                local cache_key = string.format('cache_warning_by_did_%s_%s', 'mmkt_mmktclient_multi_uid', device_id)
                did_risk_list = redis_common.redis_obj:get(cache_key)
                if not did_risk_list or type(did_risk_list) == 'userdata' or did_risk_list == 'null' then
                    did_risk_list = '{}'
                end
                did_risk_list = utils.json_loads(did_risk_list)
                has_cached_multi_uid = true
            elseif cached_rule_id_list[i] == 'mmkt_mmktclient_multi_did' then
                local cache_key = string.format('cache_warning_by_did_%s_%s', 'mmkt_mmktclient_multi_did', user_id)
                uid_risk_list = redis_common.redis_obj:get(cache_key)
                if not uid_risk_list or type(uid_risk_list) == 'userdata' or uid_risk_list == 'null' then
                    uid_risk_list = '{}'
                end
                uid_risk_list = utils.json_loads(uid_risk_list)
                has_cached_multi_did = true
            end
        end

        local mysql_common, msg = mysql_handler:init('alaskan_pf_api_pool')
        if not mysql_common then
            ngx.log(ngx.ERR, msg)
            ngx.say(error_response)
            ngx.exit(200)
        end
        if not has_cached_multi_uid then
            did_risk_list = mysql_common.mysql_pufa_obj:query(string.format(
                'select * from warning where device_id="%s" and rule_id="%s";', device_id, 'mmkt_mmktclient_multi_uid'))
        end

        if not has_cached_multi_did then
            uid_risk_list = mysql_common.mysql_pufa_obj:query(string.format(
                'select * from warning where device_id="%s" and rule_id="%s";', device_id, 'mmkt_mmktclient_multi_did'))
        end

        local ok, msg = mysql_common.mysql_pufa_obj:set_keepalive(10000, 100)
        if not ok then
            ngx.log(ngx.ERR, msg)
            ngx.say(error_response)
            ngx.exit(200)
        end

        if #did_risk_list > 0 then
            did_risk_flag = 1
        end
        if #uid_risk_list > 0 then
            uid_risk_flag = 1
        end
    end

    local response = utils.json_dumps({
        rspCode= '000000',
        rspBody= {
            sessionId= device_id,
            userId= user_id,
            didRiskStatus= did_risk_flag,
            uidRiskStatus= uid_risk_flag,
        }
    })

    local ok, msg = redis_common.redis_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.log(ngx.ERR, msg)
        ngx.say(error_response)
        ngx.exit(200)
    end

    ngx.say(response)
    ngx.exit(ngx.OK)
end


function PufaAPI.get_jsbk_device_risk(self)

    local origin_did = ngx.var.arg_did
    local did_version = ngx.var.arg_version or '2.1.0'
    local query_tags = ngx.var.arg_queryTags

    local error_response = utils.json_dumps({rspCode='111111', rspBody={}})
    local redis_common, msg = redis_handler:init('alaskan_pf_api_pool')
    if not redis_common then
        ngx.log(ngx.ERR, msg)
        ngx.say(error_response)
        ngx.exit(ngx.OK)
    end

    local mysql_common, msg = mysql_handler:init('alaskan_pf_api_pool')
    if not mysql_common then
        ngx.log(ngx.ERR, msg)
        ngx.say(error_response)
        ngx.exit(200)
    end

    local version_number_table = {}
    local did_version = string.gmatch(did_version, '%d+')
    for number in did_version do
        table.insert(version_number_table, number)
    end
    local stalker_version = table.concat(version_number_table, '')

    local device_id = string.format('did_2%s%s', stalker_version, origin_did)

    local cached_device_id = redis_common.redis_obj:get(string.format('sessionid_did_map_%s', device_id))
    if cached_device_id and not type(cached_device_id) == 'userdata' and not cached_device_id == 'null' then
        device_id = cached_device_id
    end

    local cached_map_did = redis_common.redis_obj:get(string.format('did_map_%s', device_id))
    if cached_map_did and not type(cached_map_did) == 'userdata' and not cached_map_did == 'null' then
        device_id = cached_map_did
    end

    local query_tags_list = utils.split(query_tags, ';')

    local cached_data = redis_common.redis_obj:get('cache_warning_list')
    if not cached_data or type(cached_data) == 'userdata' or cached_data == 'null' then
        cached_data = '{}'
    end
    local cache_warning_list = utils.json_loads(cached_data).data
    local cached_rule_id_list = {}
    if cache_warning_list then
        for i=1, #cache_warning_list do
            table.insert(cached_rule_id_list, cache_warning_list[i].rule_id)
        end
    end

    local results = {}
    local hited_count = 0

    for i=1, #query_tags_list do
        local has_cached_warning = false
        local risk_list = {}
        for j=1, #cached_rule_id_list do
            if cached_rule_id_list[j] == query_tags_list[i] then
                local cache_key = string.format('cache_warning_by_did_%s_%s', query_tags_list[i], device_id)
                risk_list = redis_common.redis_obj:get(cache_key)
                if not risk_list or type(risk_list) == 'userdata' or risk_list == 'null' then
                    risk_list = '{}'
                end
                risk_list = utils.json_loads(risk_list)
                has_cached_warning = true
            end
        end
        if not has_cached_warning then
            risk_list = mysql_common.mysql_pufa_obj:query(string.format(
                'select * from warning where device_id="%s" and rule_id="%s";', device_id, query_tags_list[i]))
        end
        if #risk_list > 0 then
            table.insert(results, {riskName=query_tags_list[i], count=#risk_list})
        end
        hited_count = hited_count + #risk_list
    end

    local response = utils.json_dumps({
        rspCode='000000',
        rspBody=results,
        hitedCount=hited_count
    })

    local ok, msg = mysql_common.mysql_pufa_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.log(ngx.ERR, msg)
        ngx.say(error_response)
        ngx.exit(200)
    end

    local ok, msg = redis_common.redis_obj:set_keepalive(10000, 100)
    if not ok then
        ngx.log(ngx.ERR, msg)
        ngx.say(error_response)
        ngx.exit(200)
    end

    ngx.say(response)
    ngx.exit(ngx.OK)
end


-- request entry
local url = ngx.var.request_uri
local api_obj = PufaAPI:new()
api_obj:handle_request(url)

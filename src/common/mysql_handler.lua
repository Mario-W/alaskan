local mysql = require('resty.mysql')
local alaskan_web_config = require('web.config')
local utils = require('common.utils')
local rsa = require('resty.rsa')


local mysql_handler = {}
local mt = {__index = mysql_handler}


function mysql_handler.init(self, pool)

    -- to resolve mysql dns
    local resolver = require('resty.dns.resolver')
    local resolver_obj, err = resolver:new{nameservers={alaskan_web_config.UAT_NAME_SERVER}, retrans=5, timeout=2000}
    if not resolver_obj then
        return nil, err
    end

    local mysql_host_addr = alaskan_web_config.MYSQL_HOST
    local mysql_pufa_host_addr = alaskan_web_config.MYSQL_PUFA_HOST

    local answers, err, tries = resolver_obj:query(alaskan_web_config.MYSQL_HOST, nil, {})
    if not answers then
        return nil, err
    end
--    if answers.errcode then
--        return nil, answers.errstr
--    end

    for i, ans in ipairs(answers) do
        if ans.address or ans.cname then
            mysql_host_addr = ans.address or ans.cname
            break
        end
    end

    local answers, err, tries = resolver_obj:query(alaskan_web_config.MYSQL_PUFA_HOST, nil, {})
    if not answers then
        return nil, err
    end
--    if answers.errcode then
--        return nil, answers.errstr
--    end

    for i, ans in ipairs(answers) do
        if ans.address or ans.cname then
            mysql_pufa_host_addr = ans.address or ans.cname
            break
        end
    end

    local mysql_obj, err = mysql:new()
    if not mysql_obj then
        return nil, err
    end
    mysql_obj:set_timeout(10000)

    local mysql_pufa_obj, err = mysql:new()
    if not mysql_pufa_obj then
        return nil, err
    end
    mysql_pufa_obj:set_timeout(10000)

    local rsa_obj, err = rsa:new({ private_key = alaskan_web_config.RSA_PRIVATE_KEY })
    if not rsa_obj then
        return nil, err
    end

    local mysql_password = rsa_obj:decrypt(ngx.decode_base64(alaskan_web_config.MYSQL_PASSWORD))
    local mysql_pufa_password = rsa_obj:decrypt(ngx.decode_base64(alaskan_web_config.MYSQL_PUFA_PASSWORD))

    if pool ~= nil then
        local ok, err, errcode, sqlstate = mysql_obj:connect{
            host=mysql_host_addr,
            port=alaskan_web_config.MYSQL_PORT,
            database=alaskan_web_config.MYSQL_DB,
            user=alaskan_web_config.MYSQL_USER,
            password=mysql_password,
            charset='utf8',
            max_packet_size=1024*1024,
            pool=pool
        }
        if not ok then
            return nil, err
        end

        local ok, err, errcode, sqlstate = mysql_pufa_obj:connect{
            host=mysql_pufa_host_addr,
            port=alaskan_web_config.MYSQL_PUFA_PORT,
            database=alaskan_web_config.MYSQL_PUFA_DB,
            user=alaskan_web_config.MYSQL_PUFA_USER,
            password=mysql_pufa_password,
            charset='utf8',
            max_packet_size=1024*1024,
            pool=pool
        }
        if not ok then
            return nil, err
        end
    else
        local ok, err, errcode, sqlstate = mysql_obj:connect{
            host=mysql_host_addr,
            port=alaskan_web_config.MYSQL_PORT,
            database=alaskan_web_config.MYSQL_DB,
            user=alaskan_web_config.MYSQL_USER,
            password=mysql_password,
            charset='utf8',
            max_packet_size=1024*1024
        }
        if not ok then
            return nil, err
        end

        local ok, err, errcode, sqlstate = mysql_pufa_obj:connect{
            host=mysql_pufa_host_addr,
            port=alaskan_web_config.MYSQL_PUFA_PORT,
            database=alaskan_web_config.MYSQL_PUFA_DB,
            user=alaskan_web_config.MYSQL_PUFA_USER,
            password=mysql_pufa_password,
            charset='utf8',
            max_packet_size=1024*1024,
        }
        if not ok then
            return nil, err
        end
    end

    return setmetatable({mysql_obj = mysql_obj, mysql_pufa_obj = mysql_pufa_obj}, mt)
end


function mysql_handler.get_columns(self, table_name, pufa_db)

    local obj = self.mysql_obj
    if pufa_db then
        obj = self.mysql_pufa_obj
    end

    local res, err = obj:query('show columns from '..table_name)
    if not res then
        print(err)
        return
    end

    local columns = {}

    for i=1, #res do
        for k, v in pairs(res[i]) do
            if k == 'Field' and v ~= 'id' and v ~= 'insert_time' and v ~= 'update_time' then
                table.insert(columns, v)
            end
        end
    end

    return columns

end


function mysql_handler.insert_notice_data(self, notice_loads_result)
    if not self.mysql_obj then
        return nil, 'no mysql obj'
    end

    local res, msg = self.mysql_obj:query('select * from notice where timestamp = '..notice_loads_result.triggerValues['timestamp'])
    if res and #res >=1 then
        return res, msg
    end

    local all_fields = self:get_columns('notice')
    local fields_name = {}
    local fields_value = {}
    for i=1, #all_fields do
        local target_value = nil
        if notice_loads_result[all_fields[i]] ~= nil then
            target_value = notice_loads_result[all_fields[i]]
        elseif notice_loads_result.triggerValues[all_fields[i]] ~= nil then
            target_value = notice_loads_result.triggerValues[all_fields[i]]
        else
            target_value = notice_loads_result.triggerValues.propertyValues[all_fields[i]]
        end
        if target_value ~= nil then
            table.insert(fields_name, 'notice.'..all_fields[i])
            if type(target_value) == 'string' then
                local relpace_string = string.gsub(target_value, '"', '\\"')
                table.insert(fields_value, relpace_string)
            else
                table.insert(fields_value, tostring(target_value))
            end
        end
    end
    if fields_name ~= {} and fields_value ~= {} then
        local res, msg = self.mysql_obj:query(
            'insert into notice ('..table.concat(fields_name, ',')..') values("'..table.concat(fields_value, '","')..'");')
        if not res then
            return nil, msg
        end

        return res, msg
    end
end


function mysql_handler.insert_warning_data(self, notice_loads_result)
    if not self.mysql_pufa_obj then
        return nil, 'no mysql pufa obj'
    end

    local notice_timestamp = notice_loads_result.triggerValues['timestamp']
    local res, msg = self.mysql_pufa_obj:query('select * from warning where create_time = '..notice_timestamp)
    if res and #res >=1 then
        return res, msg
    end

    notice_loads_result['create_time'] = notice_timestamp
    notice_loads_result['rule_id'] = notice_loads_result.strategyName
    notice_loads_result['rule_level'] = notice_loads_result.decision
    local all_fields = self:get_columns('warning', true)
    local fields_name = {}
    local fields_value = {}

    for i=1, #all_fields do
        local target_value = nil
        if notice_loads_result[all_fields[i]] ~= nil then
            target_value = notice_loads_result[all_fields[i]]
        elseif notice_loads_result.triggerValues[all_fields[i]] ~= nil then
            target_value = notice_loads_result.triggerValues[all_fields[i]]
        else
            target_value = notice_loads_result.triggerValues.propertyValues[all_fields[i]]
        end
        if target_value ~= nil then
            table.insert(fields_name, 'warning.'..all_fields[i])
            if type(target_value) == 'string' then
                local relpace_string = string.gsub(target_value, '"', '\\"')
                table.insert(fields_value, relpace_string)
            else
                table.insert(fields_value, tostring(target_value))
            end
        end
    end
    if fields_name ~= {} and fields_value ~= {} then
        local res, msg = self.mysql_pufa_obj:query(
            'insert into warning ('..table.concat(fields_name, ',')..') values("'..table.concat(fields_value, '","')..'");')
        if not res then
            return nil, msg
        end

        return res, msg
    end
end


function mysql_handler.sync_set_mysql(self, notice_loads_result)

--    local query_strategy = notice_loads_result['checkType']
--    if query_strategy == nil then
--        return
--    end
--    local query_strategy_list = utils.split(query_strategy, ',')
--    local notice_keys = {}
--    for index, strategy in pairs(query_strategy_list) do
--        -- 每个查询key
--        local cache_key = utils.generate_cache_key(notice_loads_result, strategy)
--        table.insert(notice_keys, cache_key)
--    end
--
--    notice_loads_result['notice_keys'] = table.concat(notice_keys, ',')
--
--    local res, msg = self:insert_notice_data(notice_loads_result)
--    if not res then
--        ngx.say(msg)
--        ngx.log(ngx.ERR, msg)
--        ngx.exit(200)
--    end

    -- 插入浦发黑名单warning表
    local res, msg = self:insert_warning_data(notice_loads_result)
    if not res then
        ngx.say(msg)
        ngx.log(ngx.ERR, msg)
        ngx.exit(200)
    end

end


function mysql_handler.update_to_accept(self, notice_loads_result)
    if not self.mysql_obj then
        return nil, 'no mysql obj'
    end

    local data_id = notice_loads_result['id']
    if not data_id then
        return nil, 'no data id'
    end

    local res, msg = self.mysql_obj:query('update notice set decision = "normal" where id='..data_id)
    if not res then
        return nil, msg
    end

    return res, msg
end


return mysql_handler
local cjson = require('cjson')
local utils = {}


function utils.split(input, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    local i = 1
    for str in string.gmatch(input, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end


function utils.json_dumps(input)
    local result = cjson.encode(input)
    return result
end

function utils.json_loads(input)
    local result = cjson.decode(input)
    return result
end


function utils.sleep(seconds)
    os.execute("sleep "..seconds)
end


function utils.generate_cache_key(source_data, strategy)
    local cache_key_fields_list = {}
    local all_fields = utils.split(strategy, '&')
    for i, field in pairs(all_fields) do
        if source_data[field] then
            table.insert(cache_key_fields_list,
                field..'='..source_data[field])
        else
            table.insert(cache_key_fields_list, field..'=')
        end
    end
    table.sort(cache_key_fields_list)
    local cache_key = table.concat(cache_key_fields_list, '&')
    return cache_key
end


function utils.verify_token(encode_data)
    local res, decode_data = pcall(ngx.decode_base64, encode_data)
    if not res then
        return nil, 'base64 decode error'
    end

    local ok, data = pcall(utils.json_loads, decode_data)
    if not ok then
        return nil, 'json load error!'
    end

    local keys_table = {}
    for k, v in pairs(data) do
        if k ~= 'token' then
            table.insert(keys_table, k)
        end
    end

    table.sort(keys_table)
    local result_table = {}
    for index, key in pairs(keys_table) do
        table.insert(result_table, key..'='..data[key])
    end
--    table.insert(result_table, 'time_key='..(os.data('%H') + os.date('%M')))
    table.insert(result_table, 'bigsec')
    local combine_str = table.concat(result_table, '&')

    if data['token'] == ngx.md5(combine_str) then
        return true, data
    end

    return nil, 'error'
end


return utils
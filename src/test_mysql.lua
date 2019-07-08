local cjson = require('cjson')
local mysql = require('resty.mysql')
local db, err = mysql:new()
if not db then
    ngx.say("failed to instantiate mysql: ", err)
    return
end
db:set_timeout(1000)
local ok, err, errcode, sqlstate = db:connect{
    host='127.0.0.1',
    port=3306,
    database='tiap',
    user='root',
    password='630131222',
    charset='utf8',
    max_packet_size=1024*1024
}

if not ok then
    ngx.say('fail to connect to mysql!')
    ngx.say(err)
    ngx.say(errcode)
    ngx.say(sqlstate)
    return
end

local res, err, errcode, sqlstate = db:query('select count(*) from ccoa_access')
if not res then
    ngx.say(err)
    ngx.say(errcode)
    return
end
ngx.say(cjson.encode(res))
return

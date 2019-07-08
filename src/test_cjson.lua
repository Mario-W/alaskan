local cjson =  require('cjson')
local data = cjson.encode({
    key1 = 'value1',
    key2 = 'value2'
})
ngx.say(data)
return


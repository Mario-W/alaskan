local amqp = require('rabbitmq.amqp')
local cjson = require('cjson')
amqp.connect('amqp://guest:guest@127.0.0.1:5672/')
amqp.send("test","test","this is a test")
amqp.disconnect()
ngx.say()

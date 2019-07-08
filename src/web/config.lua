module("alaskan_web_config",package.seeall)

local alaskan_web_config = {

    -- STORE_MODE is to specify DB and Cache store mode.
    -- There are :
    -- -- MYSQL (直连)
    -- -- REDIS_MYSQL (单点redis缓存+mysql)
    -- -- MEMCACHE_MYSQL (单点memcache缓存+mysql)
    -- -- NGXCACHE_MYSQL (nginx本地内存缓存+mysql)
    -- -- REDIS_CLUSTER_MYSQL (redis集群+mysql)
    -- -- MEMCACHE_CLUSTER_MYSQL (memcache集群+mysql)
    -- -- REDIS_CLUSTER (redis集群（建议配置持久化策略)
    -- -- MEMCACHE_CLUSTER (memcache集群（建议配置持久化策略)
    STORE_MODE = 'MYSQL',


    REDIS_HOST = '127.0.0.1',
    REDIS_PORT = 6379,
--    REDIS_PASSWORD = '',

    MEMCACHE_HOST = '127.0.0.1',
    MEMCACHE_PORT = 11211,


    MYSQL_HOST = '127.0.0.1',
    MYSQL_PORT = 3306,
    MYSQL_USER = 'root',
    MYSQL_PASSWORD = '630131222',
    MYSQL_DB = 'warden_data',

    MYSQL_PUFA_HOST = '127.0.0.1',
    MYSQL_PUFA_PORT = 3306,
    MYSQL_PUFA_USER = 'root',
    MYSQL_PUFA_PASSWORD = '630131222',
    MYSQL_PUFA_DB = 'tiap',

    RSA_PRIVATE_KEY = '-----BEGIN RSA PRIVATE KEY-----\nMIIEqwIBAAKCAQEAp0O6TgzLnUj3LBsucucTEk7B57EF1Ok9Ik2gCLXORPfnxKTB\nfB2dQuyve4TPyFWulWQ5XxJ29kdvuStlxlczuvBAPTWCOjpd8jMHlrCE1xJwjVa8\neVjuc365+3fRyP4woj370qu3XSoptrYYqN+5T/x4+XqZRTWlu0PmiQ05Yus1rTgo\n+yCcKdb+03uZ9nVB6Vx/k+1Tshob/6rDCb8nt9+sipbZnJDuYpdFuueeskTyopDV\n210P9kRdYcZeU5YjcKr7yPuZ61LP6A+EME8WBhFt+8AOk3nT6Ei9sHUisdnuvC8Q\nAIMoypnObkqG49uaB3qvudnaKP6HK9X6XatBTQIDAQABAoIBAQCZWjkXkhekbt9f\nKtSdOEp+AIM7H0wPdoA8URsmoTkqdneiDMPwPV6Pm10QTCYMsLHN+gO3rMAw8DH4\nfVdkT1L4U4kyFTr+k8DKbArLF6/TV+6lRx6pyuVkMo3lhmdqddK1DUsyTYlh+2Qf\nRji5q9TFBt8LLGIV2CcT8yFoMClrfd6To0uL2k8DHFn/WfHyubwh2wbQUw7rV8UL\nnBaIY9TjfY3+mpfXFv/qrtmSTM46RDZTsqSF8SR3RIjkxriNeCohDPW7Kag676H0\nwRIiggkmaGFCHvs+9rLt1J+RZvt6v2Scy6tSjeIX9I25nwV/g+Iio5omzggwe5yT\n1lEbrrWBAoGJAMVNXsefw3bPY08wej3zW/KLeZAQ8rQGUTvovJDfbcbNyQ3sMTcz\nnrpVPnBe+ZHtLZzkxwQ/pq8BtQr5vuiWrp7quHkPQb/vF5CjDQMHxdP46m0BixEE\nGp2RznPaDwQ8/rsBgjavQGtdtPodx317eoLE3XedTfwf1tlR7RZy404wmwps7jru\nXp0CeQDZBqzDckflkUkNKiVTp70i5IWSjrOg/o8l0su6TCravEqfmkHjvgFCIVyw\nJjlmPkQ7qFzvvMGG9SK2bvKJnYT517Ed4Na+TMHndFXNP0N+Xn4RoxV38isaahbM\n4jtcvGAN+XeHo65a2D4G02ol5IyU04ynQY36FnECgYhjh1gck3di49NRCz9fKPhl\nLf6wshv8vIMWGZ2l50/VTdHyeAeLtTqI/J92yDJVbrPnxXCvr/xBpDbTxpCLfBey\niu1sBEpCrDXS/K1/rdgZyiNXwcOJXeyfOAJRZtrUZICLjYNGWrnAb5Dv6z3LCxMO\nDIk74dqJKPaUwkM7Y9FOjC5p3/F9QOnxAnkApDo51/iN0XmclxqyflhrdpEJRvs3\nkPew6UVXp1VmBHoB2j7H54frudg3JJD4VJd/2Mkx8rSamf68UuMoI90QOGPxApQW\nzJCXFwfgud1KvMDSk5QeddLKrUVklYwIscdWxJxnyDujf9ktLssjAyOtAh4HzLV9\ns6bxAoGJAKYcZ0Xd3fowlmjEjIqh2O7DsROCdVA9S7+3E0R3faXJnOerAO1Lu7dR\n9B7fRw25H6anxJICUMeqYbwA65+XvIqIWmx8t99bSb1TyJ9EA5JJna/hrfJQFUNx\n+KqzoD9awdnlflKZNVxiO7QLDHZX2XHcggmDoVBioMSQi1cQFG07kriHSMWR5hE=\n-----END RSA PRIVATE KEY-----\n',

    WEBSOCKET_URI = 'ws://127.0.0.1:8088/alaskan/set_blacklist_websocket',
    DEL_WEBSOCKET_URI = 'ws://127.0.0.1:8088/alaskan/del_blacklist_websocket',

    UAT_NAME_SERVER = "172.30.97.16",
}

return alaskan_web_config
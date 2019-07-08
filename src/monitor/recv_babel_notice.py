# coding=utf8

import lupa
import traceback
from babel_python.serviceserver_async import ServiceServer
from babel_python.servicemeta import ServiceMeta
from bigsec_common.redis.redisctx import RedisCtx


lua = lupa.LuaRuntime()
STORE_MODE = lua.eval('require("web.config").STORE_MODE')



def recv_notice_from_babel():
    """
    订阅warning[channel=warninglog_notify],并格式化发送接口
    :param conf: [dict]
    :return:
    """
    RedisCtx.get_instance().host = app.config.get('WARDEN_REDIS_HOST')
    RedisCtx.get_instance().port = app.config.get('WARDEN_REDIS_PORT')
    RedisCtx.get_instance().password = app.config.get('WARDEN_REDIS_PASS')

    babel_conf = """
    {
        "name": "notice_notify",
        "callmode": "notify",
        "delivermode": "topic",
        "serverimpl": "redis",
        "coder": "mail",
        "options": {
            "serversubname": "web",
            "sdc":"warden",
            "cdc":"warden"
        }
    }
    """
    try:
        meta = ServiceMeta.from_json(babel_conf)
        server = ServiceServer(meta)
        server.start(func=unpack_events)
    except:
        print(traceback.format_exc())


def unpack_events(event):

    # 从warden发送的报警信息解包
    # 同一个报警babel server端可能接受多次
    if not event:
        return
    try:
        notice = event.property_values
    except:
        print(traceback.format_exc())
        return

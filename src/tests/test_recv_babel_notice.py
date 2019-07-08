# coding=utf8

import time
import requests
from bigsec_common.event import Event
from bigsec_common.util import millis_now
from bigsec_common.redis.redisctx import RedisCtx
from babel_python.servicemeta import ServiceMeta
from babel_python.serviceclient_async import ServiceClient
from bigsec_common.metrics.metricsrecorder import MetricsRecorder, Tags


exp_notice = {
    'timestamp': 1506064372530,
    'key': 'key',
    'strategy_name': 'strategy_name',
    'scene_name': 'scene_name',
    'check_type': 'ip',
    'ip': '2.2.2.2',
    'decision': 'reject',
    'risk_score': 111111,
    'expire': 1528068372530,
    'last_modified': 0,
    'variable_values': '{"xxx":"xxx", "yyy":"yyyy"}',
    'geo_province': 'ä¸Šæµ·',
    'geo_city': 'ä¸Šæµ·',
    'test': 0,

}


Babel_Conf = """
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


class LongNumber(object):
    def __init__(self, value):
        self.value = value


class MyMetricsRecorder(MetricsRecorder):

    def record(self, value, tags={}):
        key = Tags(tags)
        v = self.store.setdefault(key, [LongNumber(0), LongNumber(0)])

        if self.type == "sum":
            v[0].value += value


def test():
    try:
        from bigsec_common.metrics.metricsagent import MetricsAgent, set_async_mode
        set_async_mode()
    except:
        pass

    metrics_url = {
        "server": "redis",
        "app": "alaskan",
        "redis": {
            "host": "127.0.0.1",
            "port": 6379,
            # 'password': '630131222',
            "type": "redis"
        }
    }
    MetricsAgent.get_instance().initialize_by_dict(metrics_url)
    post_stalker_recorder = MyMetricsRecorder(metrics_name='stalker_post_data', db='default')
    post_api_recorder = MyMetricsRecorder(metrics_name='api_request', db='default')

    RedisCtx.get_instance().host = '127.0.0.1'
    RedisCtx.get_instance().port = 6379
    # RedisCtx.get_instance().password = '630131222'
    try:
        meta = ServiceMeta.from_json(Babel_Conf)
        babel_client = ServiceClient(meta)
        babel_client.start()

        now = millis_now()
        event = Event("warden", "stalker_data", "key", now, exp_notice)
        babel_client.notify(event, event.key, timeout=5)
	print('notice notify publish [ok]')

	time.sleep(1)
        check_result = requests.get('http://localhost:8088/alaskan/get_blacklist?ip={}'.format(exp_notice.get('ip'))).content
        if 'true' in check_result:
            print('check recv babel [ok]')
        else:
            print('check recv babel [error]')


    except:
	import traceback
	print('notice notify publish [error][{}]'.format(traceback.format_exc()))


if __name__ == '__main__':

    test()
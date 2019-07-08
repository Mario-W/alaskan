# coding=utf8

import requests
import json
import time
from test_token import add_token

exp_notice = {
    'timestamp': 1506066372530,
    'key': 'key',
    'strategy_name': 'strategy_name',
    'scene_name': 'scene_name',
    'check_type': 'ip',
    'ip': '2.2.3.5',
    'decision': 'reject',
    'risk_score': 111111,
    'expire': 1528068372530,
    'last_modified': 0,
    'variable_values': '{"xxx":"xxx", "yyy":"yyyy"}',
    'geo_province': 'ä¸Šæµ·',
    'geo_city': 'ä¸Šæµ·',
    'test': 0,

}


def test():
    data = add_token(exp_notice)
    url = 'http://localhost:8088/alaskan/set_blacklist?notice={}'.format(data)
    # print url
    result = requests.get(url)
    # print result
    try:
        result_data = result.json()
        if result_data.get('res') == 'ok':
            print('set blacklist [ok]')
        else:
            print('set blacklist [error][{}]'.format(result_data.get('msg')))

        time.sleep(1)
        check_result = requests.get(
            'http://localhost:8088/alaskan/get_blacklist?ip={}'.format(exp_notice.get('ip'))).content
        if 'true' in check_result:
            print('check set blacklist [ok]')
        else:
            print('check set blacklist [error]')

    except:
        import traceback
        print('set blacklist [error][{}]'.format(traceback.format_exc()))


if __name__ == '__main__':
    test()
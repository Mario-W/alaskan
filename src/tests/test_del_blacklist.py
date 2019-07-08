# coding=utf8

import requests
import json
import base64

from test_token import add_token


exp_notice = {
    'timestamp': 1506064372530,
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
    'id': 43553,
}

def test():

    data = add_token(exp_notice)
    url = 'http://localhost:8088/alaskan/del_blacklist?notice={}'.format(data)
    #print url
    result = requests.get(url)
    try:
        result_data = result.json()
        if result_data.get('res') == 'ok':
	    res = requests.get('http://localhost:8088/alaskan/get_blacklist?ip={}'.format(exp_notice.get('ip'))).content
	    if 'false' in res:
            	print('del blacklist [ok]')
	    else:
	 	print('del blacklist [error][del blacklist failure!]')
        else:
            print('del blacklist [error][{}]'.format(result_data.get('msg')))
    except:
        import traceback
        print('del blacklist [error][{}]'.format(traceback.format_exc()))


if __name__ == '__main__':

    test()
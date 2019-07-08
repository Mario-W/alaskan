# coding=utf8

import json
import base64
import datetime
import copy
from hashlib import md5


def test():

    normal_data = {
        'arg1': 'xxx',
        'arg2': 'yyy',
        'arg3': 'zzz',
        'arg4': 'sss',
    }

    data = add_token(normal_data)
    print data


def add_token(data):

    data = copy.deepcopy(data)
    ordered_keys = sorted(data.keys())
    args = []
    for key in ordered_keys:
        value = data.get(key, '').encode('utf8') if type(data.get(key, '')) == unicode else data.get(key, '')
        args.append('{}={}'.format(key, value))

    # args.append('time_key={}'.format(datetime.datetime.now().hour + datetime.datetime.now().minute))
    args.append('bigsec')

    combine_str = '&'.join(args)
    token = md5(combine_str).hexdigest()
    data.update({'token': token})

    result = base64.b64encode(json.dumps(data))

    return result


if __name__ == '__main__':

    test()

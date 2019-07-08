# coding=utf8

import flask
from flask.views import MethodView
import time
import json
import functools
import os
import sys
import requests

sys.path.append(os.path.abspath(os.path.dirname(__file__) + '/' + '..'))
from common.models import db, Notice
from flask_cors import CORS
from tests.test_token import add_token

app = flask.Flask(__name__, static_url_path='/static/')
CORS(app, resources={r"/*": {"origins": "*"}})

from itsdangerous import TimedJSONWebSignatureSerializer as Serializer, SignatureExpired, BadSignature
SECRET_KEY = 'fdsafdsafdasfdsafdas'

api_host = 'http://116.196.108.195:8088'
del_api = '/alaskan/del_blacklist?notice={}'



def login_required():
    """
    token验证功能
    :param mode:  admin  or  panel
    :return:
    """
    token = flask.request.args.get('Zeus-Token') or flask.request.headers.get('Zeus-Token') or ""
    s = Serializer(SECRET_KEY)
    try:
        data = s.loads(token)
        username = data['user_id']
        if username == 'admin@bigsec.com':
            return True
    except SignatureExpired:
        return False  # valid token, but expired
    except BadSignature:
        return False  # invalid token
    except Exception:
        return False
    return False


def adminresp(func):
    @functools.wraps(func)
    def _wrap(*args, **kw):
        if login_required():
            try:
                rsp_body = func(*args, **kw)
                return rsp_body
            except Exception, e:
                import traceback
                traceback.print_exc()
                return flask.Response(e, 500)
        else:
            data = {'msg': '权限不足,请登录'}
            return flask.Response(json.dumps(data), mimetype='application/json', status=400)
    return _wrap


@app.route('/account/login', methods=['POST'])
@app.route(r'/account/login/<path:token>', methods=['OPTIONS', 'GET'])
def login(token=''):
    if flask.request.method == 'POST':
        username = flask.request.json.get('username')
        password = flask.request.json.get('password')
        if username == 'admin@bigsec.com' and password == 'bigsec':

            expired_time = int(time.time() * 1000) + 900000
            s = Serializer(SECRET_KEY, expires_in=expired_time)
            token = s.dumps({'user_id': username})
            data = {
                'username': username,
                'token': token,
                'expired': expired_time
            }
            resp = flask.jsonify(data)
            return resp
        else:
            data = {'msg':'账号密码错误'}
            return flask.Response(json.dumps(data), mimetype='application/json', status=400)
    if flask.request.method == 'OPTIONS' or flask.request.method == 'GET':
        return flask.Response(status=204, )


@app.route('/<path:path>')
def index(path):
    if path:
        return flask.send_from_directory('static/', path)
    else:
        return app.send_static_file('index.html')


@app.route('/vendors/<path:path>')
def return_static(path):
    return flask.send_from_directory('static/vendors/', path)


class BlackListItemAPI(MethodView):
    def get(self):
        query = db.session.query(Notice).filter_by(decision='reject').all()
        records = []
        for obj in query:
            record = {
                'id': obj.id,
                'timestamp': obj.timestamp,
                'strategy_name': obj.strategy_name,
                'check_type': obj.check_type,
                'risk_score': obj.risk_score,
                'expire': obj.expire,
                'geo_province': obj.geo_province,
                'geo_city': obj.geo_city,
                'test': obj.test,
                'decision':obj.decision,
                'notice_keys':obj.notice_keys,
            }
            records.append(record)

            db.session.close()

        return flask.jsonify({'data': records})

    def post(self):
        req_body = flask.request.get_json().get('0')
        key = req_body.get('key')
        strategy_name = req_body.get('strategy_name')
        scene_name = req_body.get('scene_name')
        check_type = req_body.get('check_type')
        warning_item = req_body.get('warning_item')
        decision = req_body.get('decision')
        risk_score = int(req_body.get('risk_score', 0))
        expire = int(req_body.get('expire', 0))
        variable_values = req_body.get('variable_values')
        geo_province = req_body.get('geo_province')
        geo_city = req_body.get('geo_city')
        test = int(req_body.get('test', 1))

        timestamp = int(time.time() * 1000)

        if check_type not in ['ip','uid','did']:
            data = {'msg': 'key类型有误,检查后重新输入'}
            return flask.Response(json.dumps(data), mimetype='application/json', status=400)

        notice = {
                'key': key,
                'timestamp': timestamp,
                'strategy_name': strategy_name,
                'scene_name': scene_name,
                'check_type': check_type,
                'decision': decision,
                'risk_score': risk_score,
                'expire': expire,
                'variable_values': variable_values,
                'geo_province': geo_province,
                'geo_city': geo_city,
                'test': test,
                'last_modified': timestamp,
                check_type: warning_item,
            }
        notice = add_token(notice)
        db.session.close()

        req = requests.get('%s/alaskan/set_blacklist?notice=%s' % (api_host, notice))
        print req.url
        print req.content
        try:
            req_content = json.loads(req.content)
            if req_content.get('res') == 'ok':
                return flask.jsonify({"ret_code": 1})
            else:
                data = {'msg':'创建失败,请重试'}
                return flask.Response(json.dumps(data), mimetype='application/json', status=400)
        except Exception as e:
            return flask.Response(e, 500)

    def delete(self, item_id):
        notice = db.session.query(Notice).filter_by(id=item_id).first()

        try:
            notice_keys_list = notice.notice_keys.splite('=')
            if notice_keys_list[0] not in ['ip', 'uid', 'did']:
                data = {'msg': '删除失败'}
                return flask.Response(json.dumps(data), mimetype='application/json', status=400)
        except:
            data = {'msg': '删除失败'}
            return flask.Response(json.dumps(data), mimetype='application/json', status=400)
        notice = {
                'key': notice.key,
                'timestamp': notice.timestamp,
                'strategy_name': notice.strategy_name,
                'scene_name': notice.scene_name,
                'check_type': notice.check_type,
                'decision': notice.decision,
                'risk_score': notice.risk_score,
                'expire': notice.expire,
                'variable_values': notice.variable_values,
                'geo_province': notice.geo_province,
                'geo_city': notice.geo_city,
                'test': notice.test,
                'last_modified': notice.last_modified,
                'id': notice.id,
                notice_keys_list[0]: notice_keys_list[1],
        }
        notice = add_token(notice)

        db.session.close()
        print '%s/alaskan/del_blacklist?notice=%s' % (api_host, notice)
        req = requests.get('%s/alaskan/del_blacklist?notice=%s' % (api_host, notice))
        try:
            req_content = json.loads(req.content)
            if req_content.get('res') == 'ok':
                return flask.jsonify({"ret_code": 1})
            else:
                data = {'msg': '删除失败,请重试'}
                return flask.Response(json.dumps(data), mimetype='application/json', status=400)
        except Exception as e:
            return flask.Response(e, 500)

blacklist_route_view = adminresp(BlackListItemAPI.as_view('blacklist'))
app.add_url_rule('/blacklist_item/', view_func=blacklist_route_view, methods=['GET', ])
app.add_url_rule('/blacklist_item/', view_func=blacklist_route_view, methods=['POST', ])
app.add_url_rule('/blacklist_item/<int:item_id>', view_func=blacklist_route_view, methods=['DELETE', ])

# @app.route(r'/item/cache_rebuild')
# @login_required
# def blacklist_cache_rebuild():
#     start_index = 0
#     count = 500
#     redis_db = redis.ConnectionPool(host='127.0.0.1', port=6379, password='630131222', db=1)
#     redis_pool = redis.StrictRedis(connection_pool=redis_db)
#     query = db.session.query(Notice).all
#     while True:
#         records = query[start_index:start_index+count]
#         if len(records) < 1:
#             return
#
#         item_dict = {}
#         for record in records:
#             cache_key = utils.creat_cache_key(record.key, record.strategy)
#             item_dict[cache_key] = record
#         redis_pool.mset(item_dict)
#
#         start_index = start_index + count

if __name__ == '__main__':
    app.run()

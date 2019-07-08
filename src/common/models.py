# coding=utf8

import lupa
from flask import Flask
from flask_script import Manager
from flask_migrate import Migrate, MigrateCommand
from flask_sqlalchemy import SQLAlchemy, declarative_base
from sqlalchemy import (Column, Integer, SMALLINT, BigInteger, BLOB, VARCHAR, CHAR, Index)


app = Flask(__name__)
lua = lupa.LuaRuntime()
MYSQL_HOST = lua.eval('require("web.config").MYSQL_HOST')
MYSQL_PORT = lua.eval('require("web.config").MYSQL_PORT')
MYSQL_USER = lua.eval('require("web.config").MYSQL_USER')
MYSQL_PASSWORD = lua.eval('require("web.config").MYSQL_PASSWORD')
MYSQL_DB = lua.eval('require("web.config").MYSQL_DB')

mysql_url = 'mysql://{}:{}@{}:{}/{}?charset=utf8'.format(MYSQL_USER, MYSQL_PASSWORD, MYSQL_HOST, MYSQL_PORT, MYSQL_DB)
app.config['SQLALCHEMY_DATABASE_URI'] = mysql_url
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
db = SQLAlchemy(app)

migrate = Migrate(app, db)
manager = Manager(app)
manager.add_command('db', MigrateCommand)

BaseModel = declarative_base()


class Notice(db.Model, BaseModel):

    id = Column(Integer, primary_key=True, autoincrement=True)
    timestamp = Column(BigInteger, default=0)  # 插入时间戳 (13)
    key = Column(VARCHAR(1000), nullable=False)  # 报警关联key
    strategy_name = Column(CHAR(100), nullable=False)  # 报警策略名
    scene_name = Column(CHAR(100), nullable=False) # 策略所属场景
    check_type = Column(CHAR(100), nullable=False)  # key类型，ip，uid or did
    decision = Column(CHAR(100), nullable=False)  # 决策类型，review reject etc.
    risk_score = Column(Integer, default=0)  # 风险值
    expire = Column(BigInteger, nullable=False)  # 过期13位时间戳，如果为0则为永久不过期
    last_modified = Column(BigInteger, nullable=True)  # 修改
    variable_values = Column(BLOB, nullable=False)  # 原始触发事件内容
    notice_keys = Column(BLOB, nullable=False)  # 用于报警查询的key，（缓存模式下所有的缓存key， db模式下查询key）以逗号分隔
    geo_province = Column(CHAR(100), nullable=True)  # 省份
    geo_city = Column(CHAR(100), nullable=True)  # 城市
    test = Column(SMALLINT, default=1)  # 是否是测试

    Index('ix_timestamp', timestamp)


if __name__ == '__main__':

    manager.run()

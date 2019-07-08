CREATE TABLE notice (
    id INTEGER NOT NULL AUTO_INCREMENT,
    timestamp BIGINT,
    `key` VARCHAR(1000) NOT NULL,
    strategy_name CHAR(100) NOT NULL,
    scene_name CHAR(100) NOT NULL,
    check_type CHAR(100) NOT NULL,
    decision CHAR(100) NOT NULL,
    risk_score INTEGER,
    expire BIGINT NOT NULL,
    last_modified BIGINT,
    variable_values BLOB NOT NULL,
    geo_province CHAR(100),
    geo_city CHAR(100),
    test SMALLINT,
    PRIMARY KEY (id)
);

INSERT INTO alembic_version (version_num) VALUES ('353712a8d51d');

ALTER TABLE notice ADD COLUMN notice_keys BLOB NOT NULL;

UPDATE alembic_version SET version_num='e80bd4824994' WHERE alembic_version.version_num = '353712a8d51d';

CREATE INDEX ix_timestamp ON notice (timestamp);
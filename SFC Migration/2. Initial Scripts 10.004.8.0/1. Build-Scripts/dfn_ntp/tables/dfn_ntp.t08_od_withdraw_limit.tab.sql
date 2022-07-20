CREATE TABLE dfn_ntp.t08_od_withdraw_limit
(
    t08_id                          NUMBER (10, 0) NOT NULL,
    t08_cash_account_id_u06         NUMBER (10, 0),
    t08_primary_od_limit            NUMBER (18, 5),
    t08_primary_start               DATE,
    t08_primary_expiry              DATE,
    t08_secondary_od_limit          NUMBER (18, 5),
    t08_secondary_start             DATE,
    t08_secondary_expiry            DATE,
    t08_daily_withdraw_limit        NUMBER (18, 5),
    t08_daily_withdr_limit_reason   VARCHAR2 (2000 BYTE),
    t08_no_of_approval              NUMBER (2, 0),
    t08_is_approval_completed       NUMBER (1, 0),
    t08_current_approval_level      NUMBER (2, 0),
    t08_next_status                 NUMBER (3, 0),
    t08_created_date                DATE,
    t08_last_updated_date           DATE,
    t08_status_id_v01               NUMBER (5, 0),
    t08_comment                     VARCHAR2 (2000 BYTE),
    t08_created_by_id_u17           NUMBER (10, 0),
    t08_last_updated_by_id_u17      NUMBER (10, 0),
    t08_custom_type                 VARCHAR2 (50 BYTE) DEFAULT 1,
    t08_institute_id_m02            NUMBER (3, 0) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.t08_od_withdraw_limit
ADD CONSTRAINT t08_od_withdraw_limit_pk PRIMARY KEY (t08_id)
USING INDEX
/

ALTER TABLE dfn_ntp.t08_od_withdraw_limit
    DROP COLUMN t08_daily_withdraw_limit
/

ALTER TABLE dfn_ntp.t08_od_withdraw_limit
    DROP COLUMN t08_daily_withdr_limit_reason
/
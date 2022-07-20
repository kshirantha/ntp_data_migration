CREATE TABLE dfn_ntp.t34_post_trade_requests
    (t34_id                         NUMBER(10,0) NOT NULL,
    t34_narration                  VARCHAR2(500 BYTE),
    t34_created_date               DATE,
    t34_created_by_u17             NUMBER(5,0),
    t34_status_id_v01              NUMBER(5,0),
    t34_no_of_approvals            NUMBER(5,0),
    t34_current_approval_level     NUMBER(5,0),
    t34_final_approval             NUMBER(5,0),
    t34_action                     NUMBER(5,0),
    t34_rollback                   NUMBER(5,0),
    t34_inst_id_m02                NUMBER(5,0),
    t34_symbol                     VARCHAR2(50 BYTE),
    t34_exchange                   VARCHAR2(50 BYTE),
    t34_custom_type                NUMBER(1,0),
    t34_last_updated_by            NUMBER(5,0),
    t34_last_updated_date          DATE)
/


ALTER TABLE dfn_ntp.t34_post_trade_requests
ADD CONSTRAINT t34_pk PRIMARY KEY (t34_id)
/

COMMENT ON COLUMN dfn_ntp.t34_post_trade_requests.t34_action IS '1=Merge & Allocate 2=Split/Allocate 3=Merge'
/
COMMENT ON COLUMN dfn_ntp.t34_post_trade_requests.t34_rollback IS '1=Rollback 0=Post Trade Activity'
/

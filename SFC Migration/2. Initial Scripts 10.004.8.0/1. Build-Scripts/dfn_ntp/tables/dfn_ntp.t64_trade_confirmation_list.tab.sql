CREATE TABLE dfn_ntp.t64_trade_confirmation_list
(
  t64_id                    NUMBER (5, 0) NOT NULL,
  t64_tc_request_id_t63     NUMBER(5),
  t64_trade_confirm_no      NUMBER(20),
  t64_type                  NUMBER(1),
  t64_status                NUMBER(1)
)
/

------ constraints for m151_trade_confirm_config

ALTER TABLE dfn_ntp.t64_trade_confirmation_list
ADD CONSTRAINT pk_t64 PRIMARY KEY (t64_id)
USING INDEX ENABLE
/

----- Creat Index
CREATE INDEX dfn_ntp.idx_t64_trade_confirm_no
    ON dfn_ntp.t64_trade_confirmation_list (t64_trade_confirm_no ASC)
/

ALTER TABLE dfn_ntp.t64_trade_confirmation_list
Modify t64_id NUMBER (18, 0)
/

ALTER TABLE dfn_ntp.t64_trade_confirmation_list
Modify t64_tc_request_id_t63 NUMBER (18)
/

ALTER TABLE dfn_ntp.t64_trade_confirmation_list
Rename Column t64_status to t64_status_id_v01
/

ALTER TABLE dfn_ntp.t64_trade_confirmation_list
Modify t64_status_id_v01 NUMBER (5,0)
/

ALTER TABLE dfn_ntp.t64_trade_confirmation_list
ADD t64_status_changed_by_id_u17    NUMBER (10, 0)
/

ALTER TABLE dfn_ntp.t64_trade_confirmation_list
ADD t64_status_changed_date        DATE
/

ALTER TABLE dfn_ntp.t64_trade_confirmation_list
ADD T64_Custom_Type                VARCHAR2(50) default 1
/
    

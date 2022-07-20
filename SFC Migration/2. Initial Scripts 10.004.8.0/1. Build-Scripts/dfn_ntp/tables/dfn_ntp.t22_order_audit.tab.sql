-- Table DFN_NTP.T22_ORDER_AUDIT

CREATE TABLE dfn_ntp.t22_order_audit
(
    t22_id                    NUMBER (20, 0),
    t22_cl_ord_id_t01         NUMBER (18, 0),
    t22_ord_no_t01            NUMBER (18, 0),
    t22_date_time             DATE,
    t22_status_id_v30         CHAR (1),
    t22_exchange_message_id   VARCHAR2 (50),
    t22_performed_by_id_u17   VARCHAR2 (10),
    t22_tenant_code           VARCHAR2 (50)
)
/

-- Constraints for  DFN_NTP.T22_ORDER_AUDIT


  ALTER TABLE dfn_ntp.t22_order_audit MODIFY (t22_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t22_order_audit MODIFY (t22_cl_ord_id_t01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t22_order_audit MODIFY (t22_ord_no_t01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t22_order_audit MODIFY (t22_status_id_v30 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t22_order_audit ADD CONSTRAINT t22_pk PRIMARY KEY (t22_id)
  USING INDEX  ENABLE
/

-- Indexes for  DFN_NTP.T22_ORDER_AUDIT


CREATE INDEX dfn_ntp.idx_t22_cl_ord_id_t01
    ON dfn_ntp.t22_order_audit (t22_cl_ord_id_t01)
/

CREATE INDEX dfn_ntp.idx_t22_ord_no_t01
    ON dfn_ntp.t22_order_audit (t22_ord_no_t01)
/

CREATE INDEX dfn_ntp.idx_t22_date_time
    ON dfn_ntp.t22_order_audit (t22_date_time)
/

CREATE INDEX dfn_ntp.idx_t22_performed_by
    ON dfn_ntp.t22_order_audit (t22_performed_by_id_u17)
/

-- Comments for  DFN_NTP.T22_ORDER_AUDIT

COMMENT ON COLUMN dfn_ntp.t22_order_audit.t22_performed_by_id_u17 IS
    'Dealer ID T01
'
/
-- End of DDL Script for Table DFN_NTP.T22_ORDER_AUDIT
ALTER TABLE DFN_NTP.T22_ORDER_AUDIT 
 ADD (
  T22_INSTITUTION_ID_M02 NUMBER (3)
 )
/

ALTER TABLE dfn_ntp.t22_order_audit
    MODIFY (t22_institution_id_m02 DEFAULT 1)
/

ALTER TABLE DFN_NTP.T22_ORDER_AUDIT 
 ADD (
  T22_NARATION VARCHAR2 (500)
 )
/

ALTER TABLE DFN_NTP.T22_ORDER_AUDIT 
 ADD (
  T22_SEQUENCE_ID_T02 NUMBER (20)
 )
/
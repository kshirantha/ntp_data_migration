-- Table DFN_NTP.A06_AUDIT

CREATE TABLE dfn_ntp.a06_audit
(
    a06_id                  NUMBER (38, 0),
    a06_date                DATE DEFAULT SYSDATE,
    a06_user_id_u17         NUMBER (10, 0),
    a06_activity_id_m82     NUMBER (7, 0),
    a06_description         VARCHAR2 (2000),
    a06_reference_no        VARCHAR2 (400),
    a06_channel_v29         NUMBER (3, 0),
    a06_customer_id_u01     NUMBER (18, 0),
    a06_login_id_u09        NUMBER (20, 0),
    a06_user_login_id_u17   NUMBER (20, 0),
    a06_ip                  VARCHAR2 (100),
    a06_connected_machine   VARCHAR2 (100)
)
/

-- Constraints for  DFN_NTP.A06_AUDIT


  ALTER TABLE dfn_ntp.a06_audit MODIFY (a06_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a06_audit MODIFY (a06_activity_id_m82 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a06_audit MODIFY (a06_login_id_u09 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a06_audit MODIFY (a06_user_id_u17 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.A06_AUDIT

COMMENT ON COLUMN dfn_ntp.a06_audit.a06_date IS 'Date'
/
COMMENT ON COLUMN dfn_ntp.a06_audit.a06_user_id_u17 IS 'User ID'
/
COMMENT ON COLUMN dfn_ntp.a06_audit.a06_activity_id_m82 IS
    '(Table ID) + 0 + (Audit Activity ID)'
/
COMMENT ON COLUMN dfn_ntp.a06_audit.a06_description IS 'Description'
/
COMMENT ON COLUMN dfn_ntp.a06_audit.a06_reference_no IS 'Reference No'
/
COMMENT ON COLUMN dfn_ntp.a06_audit.a06_channel_v29 IS 'Channel ID (FK m21)'
/
COMMENT ON COLUMN dfn_ntp.a06_audit.a06_customer_id_u01 IS
    'Customer ID ( u01)'
/
COMMENT ON COLUMN dfn_ntp.a06_audit.a06_login_id_u09 IS 'Login ID (FK u09)'
/
COMMENT ON TABLE dfn_ntp.a06_audit IS 'Audit Trail'
/
-- End of DDL Script for Table DFN_NTP.A06_AUDIT

alter table dfn_ntp.A06_AUDIT
	add A06_Custom_Type varchar2(50) default 1
/

ALTER TABLE dfn_ntp.a06_audit
 ADD (
  a06_institute_id_m02 NUMBER (3, 0)
 )
/
COMMENT ON COLUMN dfn_ntp.a06_audit.a06_institute_id_m02 IS 'Institute ID (m02)'
/

ALTER TABLE dfn_ntp.a06_audit
    MODIFY (a06_institute_id_m02 DEFAULT 1)
/


ALTER TABLE dfn_ntp.a06_audit
 MODIFY (
  a06_login_id_u09 NULL

 )
/
COMMENT ON COLUMN dfn_ntp.a06_audit.a06_login_id_u09 IS ''
/

CREATE INDEX dfn_ntp.idx_a06_user_id_u17
    ON dfn_ntp.a06_audit (a06_user_id_u17)
/

CREATE INDEX DFN_NTP.IDX_A06_REFERENCE_NO ON DFN_NTP.A06_AUDIT
   (  A06_REFERENCE_NO DESC  ) 
/
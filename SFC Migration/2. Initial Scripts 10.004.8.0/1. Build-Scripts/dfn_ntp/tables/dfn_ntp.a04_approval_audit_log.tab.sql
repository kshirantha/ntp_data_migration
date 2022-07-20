-- Table DFN_NTP.A04_APPROVAL_AUDIT_LOG

CREATE TABLE dfn_ntp.a04_approval_audit_log
(
    a04_id                       NUMBER,
    a04_table_row_id             NUMBER,
    a04_status_id_v01            NUMBER,
    a04_action_by_id_u17         NUMBER,
    a04_approval_master_id_a03   NUMBER,
    a04_table_id_m53             NUMBER (5, 0),
    a04_created_by_id_u17        NUMBER (5, 0),
    a04_created_date             DATE,
    a04_action_date              DATE
)
/



-- End of DDL Script for Table DFN_NTP.A04_APPROVAL_AUDIT_LOG

ALTER TABLE dfn_ntp.a04_approval_audit_log
 MODIFY (
  a04_id NUMBER (18),
  a04_table_row_id NUMBER (10),
  a04_status_id_v01 NUMBER (5),
  a04_action_by_id_u17 NUMBER (5),
  a04_approval_master_id_a03 NUMBER (18)

 )
/

alter table dfn_ntp.A04_APPROVAL_AUDIT_LOG
	add A04_Custom_Type varchar2(50) default 1
/

ALTER TABLE dfn_ntp.a04_approval_audit_log
    ADD a04_institute_id_m02 NUMBER(5)
/

ALTER TABLE dfn_ntp.a04_approval_audit_log ADD CONSTRAINT pk_a04
  PRIMARY KEY (
  a04_id
)
/

CREATE INDEX dfn_ntp.idx_a04_approval_master_id_a03
    ON dfn_ntp.a04_approval_audit_log (a04_approval_master_id_a03)
/

CREATE INDEX dfn_ntp.idx_a04_status_id_v01
    ON dfn_ntp.a04_approval_audit_log (a04_status_id_v01)
/

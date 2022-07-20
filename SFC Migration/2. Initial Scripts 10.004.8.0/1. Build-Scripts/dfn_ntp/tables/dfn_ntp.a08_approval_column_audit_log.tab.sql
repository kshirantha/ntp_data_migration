-- Table DFN_NTP.A08_APPROVAL_COLUMN_AUDIT_LOG

CREATE TABLE dfn_ntp.a08_approval_column_audit_log
(
    a08_id                      NUMBER,
    a08_approval_audit_id_a07   NUMBER,
    a08_table_id_m53            NUMBER (5, 0),
    a08_table_row_id            NUMBER,
    a08_status_id_v01           NUMBER,
    a08_action_by_id_u17        NUMBER,
    a08_action_date             DATE,
    a08_created_by_id_u17       NUMBER (5, 0),
    a08_created_date            DATE
)
/



-- End of DDL Script for Table DFN_NTP.A08_APPROVAL_COLUMN_AUDIT_LOG
ALTER TABLE dfn_ntp.a08_approval_column_audit_log
 MODIFY (
  a08_id NUMBER (18),
  a08_approval_audit_id_a07 NUMBER (18),
  a08_table_row_id NUMBER (10),
  a08_status_id_v01 NUMBER (5),
  a08_action_by_id_u17 NUMBER (7)

 )
/

alter table dfn_ntp.A08_APPROVAL_COLUMN_AUDIT_LOG
	add A08_Custom_Type varchar2(50) default 1
/

ALTER TABLE dfn_ntp.a08_approval_column_audit_log
    ADD a08_institute_id_m02 NUMBER(5)
/

CREATE INDEX dfn_ntp.idx_a08_approval_audit_id_a07
    ON dfn_ntp.a08_approval_column_audit_log (a08_approval_audit_id_a07)
/

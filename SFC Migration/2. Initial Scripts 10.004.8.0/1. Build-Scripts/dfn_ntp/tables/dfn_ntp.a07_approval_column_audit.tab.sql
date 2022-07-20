-- Table DFN_NTP.A07_APPROVAL_COLUMN_AUDIT

CREATE TABLE dfn_ntp.a07_approval_column_audit
(
    a07_id                       NUMBER,
    a07_table                    VARCHAR2 (50),
    a07_table_row_id             NUMBER (10, 0),
    a07_status_id_v01            NUMBER (5, 0),
    a07_next_status_id_v01       NUMBER (5, 0),
    a07_current_approval_level   NUMBER,
    a07_no_of_approval           NUMBER,
    a07_is_approval_completed    NUMBER,
    a07_table_id_m53             NUMBER,
    a07_table_description        VARCHAR2 (50),
    a07_column_description_m83   VARCHAR2 (100),
    a07_column_name_m83          VARCHAR2 (50),
    a07_current_value            VARCHAR2 (2000),
    a07_new_value                VARCHAR2 (2000),
    a07_last_updated_date        DATE,
    a07_last_update_by_id_u17    NUMBER (5, 0),
    a07_class                    VARCHAR2 (100),
    a07_line_id_a03              NUMBER,
    a07_created_date             DATE,
    a07_created_by_id_u17        NUMBER (5, 0),
    a07_comment                  VARCHAR2 (100),
    a07_action_on_approval       NUMBER (1, 0),
    a07_use_a03_ready_to_save    NUMBER (1, 0) DEFAULT 1,
    a07_ready_to_save_value      CLOB
)
/



-- End of DDL Script for Table DFN_NTP.A07_APPROVAL_COLUMN_AUDIT
ALTER TABLE dfn_ntp.a07_approval_column_audit
 MODIFY (
  a07_id NUMBER (18),
  a07_current_approval_level NUMBER (2),
  a07_no_of_approval NUMBER (2),
  a07_is_approval_completed NUMBER (1),
  a07_table_id_m53 NUMBER (10),
  a07_line_id_a03 NUMBER (18)

 )
/

alter table dfn_ntp.A07_APPROVAL_COLUMN_AUDIT
	add A07_Custom_Type varchar2(50) default 1
/


ALTER TABLE dfn_ntp.a07_approval_column_audit
    ADD a07_institute_id_m02 NUMBER(5)
/

ALTER TABLE dfn_ntp.a07_approval_column_audit
 ADD (
  a07_dependant_no NUMBER (2, 0)
 )
/


ALTER TABLE dfn_ntp.a07_approval_column_audit
 ADD (
  a07_is_sensitive_data NUMBER (1) DEFAULT 0,
  a07_entitlement_id_v04 NUMBER (10)
 )
/

ALTER TABLE dfn_ntp.a07_approval_column_audit ADD CONSTRAINT pk_a07
  PRIMARY KEY (
  a07_id
)
/

CREATE INDEX dfn_ntp.idx_a07_line_id_a03
    ON dfn_ntp.a07_approval_column_audit (a07_line_id_a03)
/

CREATE INDEX dfn_ntp.idx_a07_dependant_no
    ON dfn_ntp.a07_approval_column_audit (a07_dependant_no)
/

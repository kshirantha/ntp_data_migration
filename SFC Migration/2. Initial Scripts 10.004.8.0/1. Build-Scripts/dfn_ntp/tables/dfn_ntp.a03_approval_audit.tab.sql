-- Table DFN_NTP.A03_APPROVAL_AUDIT

CREATE TABLE dfn_ntp.a03_approval_audit
(
    a03_id                       NUMBER,
    a03_table                    VARCHAR2 (50),
    a03_table_row_id             NUMBER,
    a03_status_id_v01            NUMBER,
    a03_where_clause             VARCHAR2 (200),
    a03_created_date             DATE,
    a03_last_updated_date        DATE,
    a03_class                    VARCHAR2 (1000),
    a03_current_approval_level   NUMBER,
    a03_no_of_approval           NUMBER,
    a03_new_value                CLOB,
    a03_current_value            CLOB,
    a03_ready_to_save_value      CLOB,
    a03_description              VARCHAR2 (250),
    a03_is_approval_completed    NUMBER (1, 0) DEFAULT 0,
    a03_table_id_m53             NUMBER (5, 0),
    a03_table_description        VARCHAR2 (100),
    a03_display_code             VARCHAR2 (50),
    a03_next_status_id_v01       NUMBER,
    a03_approval_type            NUMBER (*, 0),
    a03_created_by_id_u17        NUMBER (5, 0),
    a03_last_updated_by_id_u17   NUMBER (5, 0),
    a03_comment                  VARCHAR2 (100)
)
/



-- Comments for  DFN_NTP.A03_APPROVAL_AUDIT

COMMENT ON COLUMN dfn_ntp.a03_approval_audit.a03_is_approval_completed IS
    '0 - Not Completed 1- Complete'
/
COMMENT ON COLUMN dfn_ntp.a03_approval_audit.a03_approval_type IS
    '0 - row wise, 1 column wise'
/
-- End of DDL Script for Table DFN_NTP.A03_APPROVAL_AUDIT

ALTER TABLE dfn_ntp.a03_approval_audit
 MODIFY (
  a03_id NUMBER (18),
  a03_table_row_id NUMBER (10),
  a03_status_id_v01 NUMBER (5),
  a03_current_approval_level NUMBER (2),
  a03_no_of_approval NUMBER (2),
  a03_next_status_id_v01 NUMBER (3),
  a03_approval_type NUMBER (1, 0)

 )
/

alter table dfn_ntp.A03_APPROVAL_AUDIT
	add A03_Custom_Type varchar2(50) default 1
/

ALTER TABLE dfn_ntp.a03_approval_audit
    ADD a03_institute_id_m02 NUMBER(5)
/

COMMENT ON COLUMN dfn_ntp.a03_approval_audit.a03_approval_type IS
    '1 - Row Wise | 2 - Column Wise'
/

CREATE INDEX dfn_ntp.idx_a03_table
    ON dfn_ntp.a03_approval_audit (a03_table)
/

CREATE INDEX dfn_ntp.idx_a03_status_id_v01
    ON dfn_ntp.a03_approval_audit (a03_status_id_v01)
/

CREATE INDEX dfn_ntp.idx_a03_institute_id_m02
    ON dfn_ntp.a03_approval_audit (a03_institute_id_m02)
/

ALTER TABLE dfn_ntp.a03_approval_audit ADD CONSTRAINT pk_a03
  PRIMARY KEY (
  a03_id
)
/

CREATE INDEX dfn_ntp.idx_a03_table_id_m53
    ON dfn_ntp.a03_approval_audit (a03_table_id_m53)
/

ALTER TABLE dfn_ntp.a03_approval_audit
 ADD (
  a03_customer_id_u01 NUMBER (18, 0),
  a03_login_id_u09 NUMBER (20, 0)
 )
/
COMMENT ON COLUMN dfn_ntp.a03_approval_audit.a03_customer_id_u01 IS
    'Customer Id'
/
COMMENT ON COLUMN dfn_ntp.a03_approval_audit.a03_login_id_u09 IS
    'Customer Login Id'
/

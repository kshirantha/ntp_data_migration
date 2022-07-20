-- Table DFN_NTP.M135_GL_ACCOUNTS

CREATE TABLE dfn_ntp.m135_gl_accounts
(
    m135_id                         NUMBER (10, 0),
    m135_code                       VARCHAR2 (50),
    m135_currency_code_m03          CHAR (3),
    m135_currency_id_m03            NUMBER (5, 0),
    m135_acc_cat_id_m134            NUMBER (5, 0),
    m135_external_ref               VARCHAR2 (50),
    m135_created_by_id_u17          NUMBER (10, 0),
    m135_created_date               DATE,
    m135_modified_by_id_u17         NUMBER (10, 0),
    m135_modified_date              DATE,
    m135_status_id_v01              NUMBER (5, 0),
    m135_status_changed_by_id_u17   NUMBER (10, 0),
    m135_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.M135_GL_ACCOUNTS


  ALTER TABLE dfn_ntp.m135_gl_accounts ADD CONSTRAINT pk_m135 PRIMARY KEY (m135_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m135_gl_accounts MODIFY (m135_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m135_gl_accounts MODIFY (m135_code NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m135_gl_accounts MODIFY (m135_currency_code_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m135_gl_accounts MODIFY (m135_currency_id_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m135_gl_accounts MODIFY (m135_acc_cat_id_m134 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m135_gl_accounts MODIFY (m135_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m135_gl_accounts MODIFY (m135_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m135_gl_accounts MODIFY (m135_status_id_v01 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M135_GL_ACCOUNTS

alter table dfn_ntp.M135_GL_ACCOUNTS
	add M135_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m135_gl_accounts
 ADD (
  m135_institute_id_m02 NUMBER (3, 0)
 )
/


ALTER TABLE dfn_ntp.m135_gl_accounts
    MODIFY (m135_institute_id_m02 DEFAULT 1)
/

ALTER TABLE dfn_ntp.m135_gl_accounts ADD CONSTRAINT uk_m135_currency_acc_cat_id
  UNIQUE (
  m135_currency_code_m03,
  m135_acc_cat_id_m134
)
/

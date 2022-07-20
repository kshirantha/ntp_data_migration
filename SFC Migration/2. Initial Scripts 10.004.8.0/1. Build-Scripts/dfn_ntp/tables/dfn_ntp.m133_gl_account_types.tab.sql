-- Table DFN_NTP.M133_GL_ACCOUNT_TYPES

CREATE TABLE dfn_ntp.m133_gl_account_types
(
    m133_id                         NUMBER (3, 0),
    m133_description                VARCHAR2 (50),
    m133_description_lang           VARCHAR2 (50),
    m133_created_by_id_u17          NUMBER (10, 0),
    m133_created_date               DATE,
    m133_modified_by_id_u17         NUMBER (10, 0),
    m133_modified_date              DATE,
    m133_status_id_v01              NUMBER (5, 0),
    m133_status_changed_by_id_u17   NUMBER (10, 0),
    m133_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.M133_GL_ACCOUNT_TYPES


  ALTER TABLE dfn_ntp.m133_gl_account_types ADD CONSTRAINT pk_m133 PRIMARY KEY (m133_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m133_gl_account_types MODIFY (m133_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m133_gl_account_types MODIFY (m133_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m133_gl_account_types MODIFY (m133_description_lang NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m133_gl_account_types MODIFY (m133_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m133_gl_account_types MODIFY (m133_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m133_gl_account_types MODIFY (m133_status_id_v01 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M133_GL_ACCOUNT_TYPES

ALTER TABLE dfn_ntp.m133_gl_account_types
 MODIFY (
  m133_description_lang NULL
 )
/

alter table dfn_ntp.M133_GL_ACCOUNT_TYPES
	add M133_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m133_gl_account_types
 ADD (
  m133_institute_id_m02 NUMBER (3, 0) DEFAULT 1
 )
/

COMMENT ON COLUMN dfn_ntp.m133_gl_account_types.m133_institute_id_m02 IS
    'Primary Institution'
/
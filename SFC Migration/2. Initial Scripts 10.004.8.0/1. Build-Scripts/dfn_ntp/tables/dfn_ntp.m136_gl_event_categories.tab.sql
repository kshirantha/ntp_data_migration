-- Table DFN_NTP.M136_GL_EVENT_CATEGORIES

CREATE TABLE dfn_ntp.m136_gl_event_categories
(
    m136_id                   NUMBER (5, 0),
    m136_description          VARCHAR2 (75),
    m136_institute_id_m02     NUMBER (5, 0),
    m136_enabled              NUMBER (1, 0) DEFAULT 0,
    m136_type                 NUMBER (1, 0) DEFAULT 0,
    m136_modified_by_id_u17   NUMBER (10, 0),
    m136_modified_date        DATE
)
/

-- Constraints for  DFN_NTP.M136_GL_EVENT_CATEGORIES


  ALTER TABLE dfn_ntp.m136_gl_event_categories ADD CONSTRAINT pk_m136 PRIMARY KEY (m136_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m136_gl_event_categories MODIFY (m136_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m136_gl_event_categories MODIFY (m136_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m136_gl_event_categories MODIFY (m136_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m136_gl_event_categories MODIFY (m136_enabled NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m136_gl_event_categories MODIFY (m136_type NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M136_GL_EVENT_CATEGORIES

COMMENT ON COLUMN dfn_ntp.m136_gl_event_categories.m136_enabled IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m136_gl_event_categories.m136_type IS
    '0 - Record | 1 - Column'
/
-- End of DDL Script for Table DFN_NTP.M136_GL_EVENT_CATEGORIES


ALTER TABLE dfn_ntp.m136_gl_event_categories
 ADD (
  m136_description_lang VARCHAR2 (75)
 )
/

alter table dfn_ntp.M136_GL_EVENT_CATEGORIES
	add M136_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m136_gl_event_categories
 ADD (
  m136_filter VARCHAR2 (500)
 )
/

ALTER TABLE dfn_ntp.m136_gl_event_categories
RENAME COLUMN m136_filter TO m136_currency_filter
/

ALTER TABLE dfn_ntp.m136_gl_event_categories
 ADD (
  m136_exchange_filter VARCHAR2 (500)
 )
/

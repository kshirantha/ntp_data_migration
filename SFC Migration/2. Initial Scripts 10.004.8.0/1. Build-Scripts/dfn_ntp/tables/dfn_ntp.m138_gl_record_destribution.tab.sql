-- Table DFN_NTP.M138_GL_RECORD_DESTRIBUTION

CREATE TABLE dfn_ntp.m138_gl_record_destribution
(
    m138_id                          NUMBER (3, 0),
    m138_data_source_id_m137         NUMBER (10, 0),
    m138_acc_cat_id_m134             NUMBER (5, 0),
    m138_narration_expression        VARCHAR2 (500),
    m138_narration_expression_lang   VARCHAR2 (500),
    m138_enabled                     NUMBER (1, 0) DEFAULT 0,
    m138_dr_expression               VARCHAR2 (200),
    m138_cr_expression               VARCHAR2 (200),
    m138_external_ref                VARCHAR2 (50),
    m138_modified_by_id_u17          NUMBER (10, 0),
    m138_modified_date               DATE
)
/

-- Constraints for  DFN_NTP.M138_GL_RECORD_DESTRIBUTION


  ALTER TABLE dfn_ntp.m138_gl_record_destribution ADD CONSTRAINT pk_m138 PRIMARY KEY (m138_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m138_gl_record_destribution MODIFY (m138_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m138_gl_record_destribution MODIFY (m138_data_source_id_m137 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m138_gl_record_destribution MODIFY (m138_acc_cat_id_m134 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m138_gl_record_destribution MODIFY (m138_narration_expression NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m138_gl_record_destribution MODIFY (m138_narration_expression_lang NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m138_gl_record_destribution MODIFY (m138_enabled NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m138_gl_record_destribution MODIFY (m138_dr_expression NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m138_gl_record_destribution MODIFY (m138_cr_expression NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M138_GL_RECORD_DESTRIBUTION

COMMENT ON COLUMN dfn_ntp.m138_gl_record_destribution.m138_enabled IS
    '0 - No | 1 - Yes'
/
-- End of DDL Script for Table DFN_NTP.M138_GL_RECORD_DESTRIBUTION

CREATE INDEX dfn_ntp.idx_m138_data_source_id_m137
    ON dfn_ntp.m138_gl_record_destribution (m138_data_source_id_m137)
/

alter table dfn_ntp.M138_GL_RECORD_DESTRIBUTION
	add M138_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m138_gl_record_destribution
 ADD (
  m138_filter VARCHAR2 (1000)
 )
/
COMMENT ON COLUMN dfn_ntp.m138_gl_record_destribution.m138_filter IS
    'This filter will not consider for cut-off'
/

ALTER TABLE dfn_ntp.m138_gl_record_destribution
ADD ( m138_acc_ref VARCHAR2 (50))
/

ALTER TABLE dfn_ntp.m138_gl_record_destribution
 MODIFY (
  m138_acc_ref VARCHAR2 (500 BYTE)
 )
/

ALTER TABLE dfn_ntp.m138_gl_record_destribution
 MODIFY (
  m138_external_ref VARCHAR2 (500 BYTE)
 )
/

ALTER TABLE dfn_ntp.m138_gl_record_destribution
 MODIFY (
  m138_acc_cat_id_m134 NULL
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m138_gl_record_destribution ADD (    m138_event_ref_1                 VARCHAR2 (1000 BYTE) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m138_gl_record_destribution')
           AND column_name = UPPER ('m138_event_ref_1');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m138_gl_record_destribution ADD (    m138_event_ref_2                 VARCHAR2 (1000 BYTE) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m138_gl_record_destribution')
           AND column_name = UPPER ('m138_event_ref_2');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m138_gl_record_destribution ADD (    m138_event_ref_3                 VARCHAR2 (1000 BYTE) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m138_gl_record_destribution')
           AND column_name = UPPER ('m138_event_ref_3');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m138_gl_record_destribution ADD (    m138_event_ref_4                 VARCHAR2 (1000 BYTE) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m138_gl_record_destribution')
           AND column_name = UPPER ('m138_event_ref_4');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m138_gl_record_destribution ADD (    m138_event_ref_5                 VARCHAR2 (1000 BYTE) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m138_gl_record_destribution')
           AND column_name = UPPER ('m138_event_ref_5');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

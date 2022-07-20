-- Table DFN_NTP.M139_GL_COLUMN_DESTRIBUTION

CREATE TABLE dfn_ntp.m139_gl_column_destribution
(
    m139_id                          NUMBER (15, 0),
    m139_data_source_id_m137         NUMBER (10, 0),
    m139_narration_expression        VARCHAR2 (500),
    m139_narration_expression_lang   VARCHAR2 (500),
    m139_enabled                     NUMBER (1, 0) DEFAULT 0,
    m139_dr_1_expression             VARCHAR2 (200),
    m139_dr_1_acc_cat_id_m134        NUMBER (5, 0),
    m139_dr_2_expression             VARCHAR2 (200),
    m139_dr_2_acc_cat_id_m134        NUMBER (5, 0),
    m139_dr_3_expression             VARCHAR2 (200),
    m139_dr_3_acc_cat_id_m134        NUMBER (5, 0),
    m139_dr_4_expression             VARCHAR2 (200),
    m139_dr_4_acc_cat_id_m134        NUMBER (5, 0),
    m139_dr_5_expression             VARCHAR2 (200),
    m139_dr_5_acc_cat_id_m134        NUMBER (5, 0),
    m139_cr_1_expression             VARCHAR2 (200),
    m139_cr_1_acc_cat_id_m134        NUMBER (5, 0),
    m139_cr_2_expression             VARCHAR2 (200),
    m139_cr_2_acc_cat_id_m134        NUMBER (5, 0),
    m139_cr_3_expression             VARCHAR2 (200),
    m139_cr_3_acc_cat_id_m134        NUMBER (5, 0),
    m139_cr_4_expression             VARCHAR2 (200),
    m139_cr_4_acc_cat_id_m134        NUMBER (5, 0),
    m139_cr_5_expression             VARCHAR2 (200),
    m139_cr_5_acc_cat_id_m134        NUMBER (5, 0),
    m139_modified_by_id_u17          NUMBER (10, 0),
    m139_modified_date               DATE
)
/

-- Constraints for  DFN_NTP.M139_GL_COLUMN_DESTRIBUTION


  ALTER TABLE dfn_ntp.m139_gl_column_destribution ADD CONSTRAINT pk_m139 PRIMARY KEY (m139_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m139_gl_column_destribution MODIFY (m139_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m139_gl_column_destribution MODIFY (m139_data_source_id_m137 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m139_gl_column_destribution MODIFY (m139_narration_expression NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m139_gl_column_destribution MODIFY (m139_narration_expression_lang NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m139_gl_column_destribution MODIFY (m139_enabled NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m139_gl_column_destribution MODIFY (m139_dr_1_expression NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m139_gl_column_destribution MODIFY (m139_dr_1_acc_cat_id_m134 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m139_gl_column_destribution MODIFY (m139_cr_1_acc_cat_id_m134 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m139_gl_column_destribution MODIFY (m139_cr_2_expression NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M139_GL_COLUMN_DESTRIBUTION

COMMENT ON COLUMN dfn_ntp.m139_gl_column_destribution.m139_enabled IS
    '0 - No | 1 - Yes'
/
-- End of DDL Script for Table DFN_NTP.M139_GL_COLUMN_DESTRIBUTION


ALTER TABLE dfn_ntp.m139_gl_column_destribution
 ADD (
  m139_external_ref VARCHAR2(50)
 )
/

alter table dfn_ntp.M139_GL_COLUMN_DESTRIBUTION
	add M139_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m139_gl_column_destribution
 ADD (
  m139_dr_1_acc_ref VARCHAR2 (50),
  m139_dr_2_acc_ref VARCHAR2 (50),
  m139_dr_3_acc_ref VARCHAR2 (50),
  m139_dr_4_acc_ref VARCHAR2 (50),
  m139_dr_5_acc_ref VARCHAR2 (50),
  m139_cr_1_acc_ref VARCHAR2 (50),
  m139_cr_2_acc_ref VARCHAR2 (50),
  m139_cr_3_acc_ref VARCHAR2 (50),
  m139_cr_4_acc_ref VARCHAR2 (50),
  m139_cr_5_acc_ref VARCHAR2 (50)
 )
/

ALTER TABLE dfn_ntp.m139_gl_column_destribution
 MODIFY (
  m139_dr_1_acc_ref VARCHAR2 (500),
  m139_dr_2_acc_ref VARCHAR2 (500),
  m139_dr_3_acc_ref VARCHAR2 (500),
  m139_dr_4_acc_ref VARCHAR2 (500),
  m139_dr_5_acc_ref VARCHAR2 (500),
  m139_cr_1_acc_ref VARCHAR2 (500),
  m139_cr_2_acc_ref VARCHAR2 (500),
  m139_cr_3_acc_ref VARCHAR2 (500),
  m139_cr_4_acc_ref VARCHAR2 (500),
  m139_cr_5_acc_ref VARCHAR2 (500)
 )
/

ALTER TABLE dfn_ntp.m139_gl_column_destribution
 MODIFY (
  m139_external_ref VARCHAR2 (500)
 )
/

ALTER TABLE dfn_ntp.m139_gl_column_destribution
 ADD (
  m139_filter VARCHAR2 (1000)
 )
/
COMMENT ON COLUMN dfn_ntp.m139_gl_column_destribution.m139_filter IS
    'This filter will not consider for cut-off'
/

ALTER TABLE dfn_ntp.m139_gl_column_destribution
 MODIFY (
  m139_dr_1_acc_cat_id_m134 NULL,
  m139_cr_1_expression NOT NULL,
  m139_cr_1_acc_cat_id_m134 NULL,
  m139_cr_2_expression NULL
 )
/

ALTER TABLE dfn_ntp.m139_gl_column_destribution
 ADD (
  m139_event_ref_1 VARCHAR2 (50),
  m139_event_ref_2 VARCHAR2 (50),
  m139_event_ref_3 VARCHAR2 (50),
  m139_event_ref_4 VARCHAR2 (50),
  m139_event_ref_5 VARCHAR2 (50)
 )
/

ALTER TABLE dfn_ntp.m139_gl_column_destribution
 MODIFY (
  m139_event_ref_1 VARCHAR2 (500 BYTE),
  m139_event_ref_2 VARCHAR2 (500 BYTE),
  m139_event_ref_3 VARCHAR2 (500 BYTE),
  m139_event_ref_4 VARCHAR2 (500 BYTE),
  m139_event_ref_5 VARCHAR2 (500 BYTE)
 )
/

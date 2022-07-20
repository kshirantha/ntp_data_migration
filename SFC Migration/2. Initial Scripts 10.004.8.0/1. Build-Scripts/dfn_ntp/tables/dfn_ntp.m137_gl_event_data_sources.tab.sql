CREATE TABLE dfn_ntp.m137_gl_event_data_sources
(
    m137_id                   NUMBER (10, 0) NOT NULL,
    m137_view_name            VARCHAR2 (50 BYTE) NOT NULL,
    m137_filter               VARCHAR2 (1000 BYTE) NOT NULL,
    m137_event_cat_id_m136    NUMBER (5, 0) NOT NULL,
    m137_description          VARCHAR2 (75 BYTE) NOT NULL,
    m137_enabled              NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m137_external_ref         VARCHAR2 (500 BYTE),
    m137_modified_by_id_u17   NUMBER (10, 0),
    m137_modified_date        DATE,
    m137_cutoff_enabled       NUMBER (1, 0) DEFAULT 0,
    m137_cutoff_key_column    VARCHAR2 (50 BYTE),
    m137_custom_type          VARCHAR2 (50 BYTE) DEFAULT 1,
    m137_institute_id_m02     NUMBER (3, 0) DEFAULT 1
)
/



CREATE INDEX dfn_ntp.idx_m137_event_cat_id_m136
    ON dfn_ntp.m137_gl_event_data_sources (m137_event_cat_id_m136 ASC)
/


ALTER TABLE dfn_ntp.m137_gl_event_data_sources
    ADD CONSTRAINT pk_m137 PRIMARY KEY (m137_id) USING INDEX
/


COMMENT ON COLUMN dfn_ntp.m137_gl_event_data_sources.m137_cutoff_enabled IS
    '0 - Disabled | 1 - Enabled'
/
COMMENT ON COLUMN dfn_ntp.m137_gl_event_data_sources.m137_enabled IS
    '0 - No | 1 - Yes'
/

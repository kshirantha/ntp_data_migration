CREATE TABLE dfn_ntp.m180_institute_default_values
(
    m180_id                       NUMBER (5, 0) NOT NULL,
    m180_institution_id_m02       NUMBER (3, 0) NOT NULL,
    m180_initial_margin           NUMBER (6, 3) DEFAULT 0,
    m180_mrg_call_notify_lvl      NUMBER (6, 3) DEFAULT 0,
    m180_mrg_call_remind_lvl      NUMBER (6, 3) DEFAULT 0,
    m180_mrg_call_liquid_lvl      NUMBER (6, 3) DEFAULT 0,
    m180_symbol_marginable_pct    NUMBER (6, 3) DEFAULT 0,
    m180_last_updated_date        DATE,
    m180_last_updated_by_id_u17   NUMBER (10, 0),
    m180_custom_type              VARCHAR2 (50 BYTE) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.m180_institute_default_values
    ADD CONSTRAINT m180_pk PRIMARY KEY (m180_id) USING INDEX
/

COMMENT ON TABLE dfn_ntp.m180_institute_default_values IS
    'this table keeps the default values for an institution'
/
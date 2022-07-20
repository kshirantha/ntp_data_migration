CREATE TABLE dfn_ntp.v31_restriction
(
    v31_id            NUMBER (5, 0) NOT NULL,
    v31_name          VARCHAR2 (100 BYTE) NOT NULL,
    v31_name_lang     VARCHAR2 (100 BYTE) NOT NULL,
    v31_type          NUMBER (2, 0) NOT NULL,
    v31_code          NUMBER (5, 0),
    v31_reason_type   NUMBER (2, 0)
)
/



ALTER TABLE dfn_ntp.v31_restriction
ADD CONSTRAINT pk_v31 PRIMARY KEY (v31_id)
USING INDEX
/


COMMENT ON COLUMN dfn_ntp.v31_restriction.v31_code IS 'OMS Related -'
/
COMMENT ON COLUMN dfn_ntp.v31_restriction.v31_reason_type IS 'FK from M127'
/
COMMENT ON COLUMN dfn_ntp.v31_restriction.v31_type IS
    '1 - Trading | 2 - Cash | 3 - Trading Symbol | 4 - Trading InstrumentType | 5 - Trading Channel | 6 - POA'
/
COMMENT ON COLUMN dfn_ntp.V31_RESTRICTION.V31_TYPE IS '1 - Trading | 2 - Cash | 3 - Trading Symbol | 4 - Trading InstrumentType | 5 - Trading Channel | 6 - POA | 7 - Channel'
/

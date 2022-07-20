CREATE TABLE dfn_ntp.m159_offline_symbol_sessions
(
    m159_id                   NUMBER (20, 0) NOT NULL,
    m159_file_name            VARCHAR2 (50 BYTE) NOT NULL,
    m159_uploaded_by_id_u17   NUMBER (5, 0) NOT NULL,
    m159_uploaded_date        DATE NOT NULL,
    m159_custom_type          VARCHAR2 (50 BYTE),
    m159_institute_id_m02     NUMBER (3, 0)
)
/
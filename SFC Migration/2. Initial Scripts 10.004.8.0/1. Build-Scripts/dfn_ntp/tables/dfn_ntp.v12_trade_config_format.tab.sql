CREATE TABLE dfn_ntp.v12_trade_config_format
(
    v12_id                 NUMBER (4, 0) NOT NULL,
    v12_code               VARCHAR2 (15 BYTE) NOT NULL,
    v12_description        VARCHAR2 (50 BYTE),
    v12_description_lang   VARCHAR2 (50 BYTE),
    v12_type               VARCHAR2 (10 BYTE),
    v12_report_name        VARCHAR2 (100 BYTE)
)
/

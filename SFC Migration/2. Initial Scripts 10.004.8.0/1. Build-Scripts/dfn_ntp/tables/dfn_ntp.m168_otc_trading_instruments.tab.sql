CREATE TABLE dfn_ntp.m168_otc_trading_instruments
(
    m168_id                         NUMBER (5, 0) NOT NULL,
    m168_instrument_type_id_v01     NUMBER (5, 0) NOT NULL,
    m168_code                       VARCHAR2 (50 BYTE) NOT NULL,
    m168_description                VARCHAR2 (50 BYTE) NOT NULL,
    m168_short_name                 VARCHAR2 (50 BYTE) NOT NULL,
    m168_issuer_name                VARCHAR2 (50 BYTE) NOT NULL,
    m168_sub_asset_type_id_v08      NUMBER (2, 0) NOT NULL,
    m168_security_domicile_id_m05   NUMBER (5, 0) NOT NULL,
    m168_security_currency_id_m03   NUMBER (5, 0) NOT NULL,
    m168_industry_id_v24            NUMBER (1, 0) NOT NULL,
    m168_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m168_created_date               DATE NOT NULL,
    m168_status_id_v01              NUMBER (5, 0) NOT NULL,
    m168_modified_by_id_u17         NUMBER (10, 0),
    m168_modified_date              DATE,
    m168_status_changed_by_id_u17   NUMBER (10, 0),
    m168_status_changed_date        DATE,
    m168_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    m168_institute_id_m02           NUMBER (3, 0),
    m168_price_update_code_id_v23   NUMBER (2, 0)
)
/

ALTER TABLE dfn_ntp.m168_otc_trading_instruments
ADD PRIMARY KEY (m168_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m168_otc_trading_instruments.m168_instrument_type_id_v01 IS
    'Type = 65'
/
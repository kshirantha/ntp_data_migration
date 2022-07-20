CREATE TABLE dfn_ntp.m503_top_holding_sector_b
(
    m503_id                 NUMBER (10, 0),
    m503_type               NUMBER (1, 0),
    m503_fund_code          VARCHAR2 (100 BYTE),
    m503_stock_name         VARCHAR2 (200 BYTE),
    m503_stock_name_lang    VARCHAR2 (200 BYTE),
    m503_sector_name        VARCHAR2 (200 BYTE),
    m503_sector_name_lang   VARCHAR2 (200 BYTE),
    m503_aum_per            NUMBER (18, 5 )
)
/

ALTER TABLE dfn_ntp.m503_top_holding_sector_b
ADD CONSTRAINT m503_pk PRIMARY KEY (m503_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m503_top_holding_sector_b.m503_type IS '1=TOP HOLDINGS | 2=TOP SECTORS'
/
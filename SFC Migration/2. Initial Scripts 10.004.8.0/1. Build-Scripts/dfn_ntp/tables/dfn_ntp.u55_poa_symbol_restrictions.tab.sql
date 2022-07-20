CREATE TABLE dfn_ntp.u55_poa_symbol_restrictions
(
    u55_id                         NUMBER (5, 0),
    u55_poa_id_u47                 NUMBER (10, 0),
    u55_symbol_id_m20              NUMBER (5, 0),
    u55_trading_account_id_u07     NUMBER (10, 0),
    u55_buy_restrict               NUMBER (1, 0),
    u55_sell_restrict              NUMBER (1, 0),
    u55_status_id_v01              NUMBER (5, 0),
    u55_created_by_id_u17          NUMBER (10, 0),
    u55_modified_by_id_u17         NUMBER (10, 0),
    u55_created_date               DATE,
    u55_modified_date              DATE,
    u55_status_changed_date        DATE,
    u55_symbol_code_m20            VARCHAR2 (255 BYTE),
    u55_status_changed_by_id_u17   NUMBER (10, 0),
    u55_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.u55_poa_symbol_restrictions
ADD PRIMARY KEY (u55_id)
USING INDEX
/

ALTER TABLE dfn_ntp.u55_poa_symbol_restrictions MODIFY (u55_symbol_id_m20 NUMBER (10))
/

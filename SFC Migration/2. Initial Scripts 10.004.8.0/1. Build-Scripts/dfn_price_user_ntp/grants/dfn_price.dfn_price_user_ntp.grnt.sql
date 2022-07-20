GRANT SELECT ON dfn_ntp.m01_exchanges TO dfn_price
/
GRANT SELECT, INSERT, UPDATE ON dfn_ntp.m20_symbol TO dfn_price
/
GRANT UPDATE ON dfn_ntp.m20_symbol TO dfn_price
/
GRANT SELECT ON dfn_ntp.m29_markets TO dfn_price
/
GRANT SELECT ON dfn_ntp.m63_sectors TO dfn_price
/
GRANT SELECT ON dfn_ntp.m03_currency TO dfn_price
/
GRANT SELECT ON dfn_ntp.v34_price_instrument_type TO dfn_price
/
GRANT SELECT ON dfn_ntp.m05_country TO dfn_price
/
GRANT EXECUTE ON dfn_ntp.fn_get_next_sequnce TO dfn_price
/
GRANT SELECT ON dfn_ntp.m150_broker TO dfn_price
/
GRANT SELECT ON dfn_ntp.m54_boards TO dfn_price
/

GRANT SELECT ON dfn_ntp.holding_symbols_v TO dfn_price
/

GRANT SELECT, INSERT, UPDATE ON dfn_ntp.a22_insert_new_symbol_audit TO dfn_price
/

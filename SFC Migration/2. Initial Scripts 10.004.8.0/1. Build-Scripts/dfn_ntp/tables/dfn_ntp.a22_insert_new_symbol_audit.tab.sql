CREATE TABLE dfn_ntp.a22_insert_new_symbol_audit
(
    a22_date              DATE,
    a22_exchange          VARCHAR2 (10),
    a22_symbol            VARCHAR2 (50),
    a22_instrument_type   NUMBER (10),
    a22_currency          VARCHAR2 (4),
    a22_status_id_v01     NUMBER (5)
)
/

GRANT INSERT ON dfn_ntp.a22_insert_new_symbol_audit TO dfn_price
/

ALTER TABLE dfn_ntp.a22_insert_new_symbol_audit
 ADD (
  a22_exception VARCHAR2 (4000)
 )
/

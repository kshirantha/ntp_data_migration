CREATE TABLE dfn_ntp.h101_daily_owned_holding_b
(
    h101_id                  NUMBER (10, 0) NOT NULL,
    h101_exchange_id_m01     NUMBER (5, 0) NOT NULL,
    h101_exchange_code_m01   VARCHAR2 (10 BYTE) NOT NULL,
    h101_symbol_id_m20       NUMBER (10, 0) NOT NULL,
    h101_symbol_code_m20     VARCHAR2 (50 BYTE) NOT NULL,
    h101_holding             NUMBER (20, 0)
)
/

ALTER TABLE dfn_ntp.h101_daily_owned_holding_b
ADD CONSTRAINT h101_pk PRIMARY KEY (h101_id)
USING INDEX
/

ALTER TABLE dfn_ntp.h101_daily_owned_holding_b
ADD CONSTRAINT h101_sym_id_exg_code_uk UNIQUE (h101_exchange_code_m01,
  h101_symbol_id_m20)
USING INDEX
/

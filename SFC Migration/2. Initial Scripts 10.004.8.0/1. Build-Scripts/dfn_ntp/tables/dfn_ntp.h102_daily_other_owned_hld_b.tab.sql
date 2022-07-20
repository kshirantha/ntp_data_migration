CREATE TABLE dfn_ntp.h102_daily_other_owned_hld_b
(
    h102_id                    NUMBER (10, 0) NOT NULL,
    h102_daily_owned_id_h101   NUMBER (10, 0) NOT NULL,
    h102_exchange_id_m01       NUMBER (5, 0) NOT NULL,
    h102_exchange_code_m01     VARCHAR2 (10 BYTE) NOT NULL,
    h102_symbol_id_m20         NUMBER (10, 0) NOT NULL,
    h102_symbol_code_m20       VARCHAR2 (50 BYTE) NOT NULL,
    h102_holding               NUMBER (20, 0)
)
/

ALTER TABLE dfn_ntp.h102_daily_other_owned_hld_b
ADD CONSTRAINT h102_pk PRIMARY KEY (h102_id)
USING INDEX
/


ALTER TABLE dfn_ntp.h102_daily_other_owned_hld_b
ADD CONSTRAINT h102_fk FOREIGN KEY (h102_daily_owned_id_h101)
REFERENCES dfn_ntp.h101_daily_owned_holding_b (h101_id)
/

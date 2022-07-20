-- Table DFN_NTP.M76_STOCK_CONC_SYMBOL_DETAILS

CREATE TABLE dfn_ntp.m76_stock_conc_symbol_details
(
    m76_id                      NUMBER (18, 0),
    m76_stock_conc_grp_id_m75   NUMBER (5, 0),
    m76_symbol_code_m20         VARCHAR2 (50),
    m76_symbol_id_m20           NUMBER (5, 0),
    m76_percentage              NUMBER (18, 5),
    m76_sell_allowed            NUMBER (1, 0) DEFAULT 0,
    m76_buy_allowed             NUMBER (1, 0) DEFAULT 0,
    m76_exchange_id_m01         NUMBER (5, 0),
    m76_exchange_code_m01       VARCHAR2 (10),
    m76_created_by_id_u17       NUMBER (5, 0),
    m76_created_date            DATE,
    m76_modified_by_id_u17      NUMBER (5, 0),
    m76_modified_date           DATE
)
/

-- Constraints for  DFN_NTP.M76_STOCK_CONC_SYMBOL_DETAILS


  ALTER TABLE dfn_ntp.m76_stock_conc_symbol_details MODIFY (m76_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m76_stock_conc_symbol_details MODIFY (m76_stock_conc_grp_id_m75 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m76_stock_conc_symbol_details MODIFY (m76_symbol_id_m20 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m76_stock_conc_symbol_details MODIFY (m76_exchange_id_m01 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M76_STOCK_CONC_SYMBOL_DETAILS

COMMENT ON COLUMN dfn_ntp.m76_stock_conc_symbol_details.m76_stock_conc_grp_id_m75 IS
    'fk m75'
/
COMMENT ON COLUMN dfn_ntp.m76_stock_conc_symbol_details.m76_symbol_id_m20 IS
    'fk m20'
/
COMMENT ON COLUMN dfn_ntp.m76_stock_conc_symbol_details.m76_created_by_id_u17 IS
    'fk u17'
/
COMMENT ON COLUMN dfn_ntp.m76_stock_conc_symbol_details.m76_modified_by_id_u17 IS
    'fk u17'
/
-- End of DDL Script for Table DFN_NTP.M76_STOCK_CONC_SYMBOL_DETAILS

alter table dfn_ntp.M76_STOCK_CONC_SYMBOL_DETAILS
	add M76_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m76_stock_conc_symbol_details
    ADD (m76_global_concentration_pct NUMBER (3) DEFAULT 100)
/

ALTER TABLE dfn_ntp.m76_stock_conc_symbol_details
    DROP COLUMN m76_global_concentration_pct;

ALTER TABLE dfn_ntp.m76_stock_conc_symbol_details MODIFY (m76_symbol_id_m20 NUMBER (10))
/

-- Table DFN_NTP.M142_CORP_ACT_HOLD_ADJUSTMENTS

CREATE TABLE dfn_ntp.m142_corp_act_hold_adjustments
(
    m142_id                      NUMBER (15, 0),
    m142_cust_corp_act_id_m141   NUMBER (10, 0),
    m142_type                    NUMBER (1, 0),
    m142_exchange_id_m01         NUMBER (5, 0),
    m142_exchange_code_m01       VARCHAR2 (10),
    m142_symbol_id_m20           NUMBER (10, 0),
    m142_symbol_code_m20         VARCHAR2 (10),
    m142_from_ratio              NUMBER (8, 5),
    m142_to_ratio                NUMBER (8, 5),
    m142_old_par_value           NUMBER (18, 5),
    m142_new_par_value           NUMBER (18, 5),
    m142_narration               VARCHAR2 (200),
    m142_adj_mode                NUMBER (1, 0)
)
/



-- Comments for  DFN_NTP.M142_CORP_ACT_HOLD_ADJUSTMENTS

COMMENT ON COLUMN dfn_ntp.m142_corp_act_hold_adjustments.m142_type IS
    '1 - Base Symbol Holdings Adjustment | 2 - New Symbol Holdings Payment'
/
COMMENT ON COLUMN dfn_ntp.m142_corp_act_hold_adjustments.m142_adj_mode IS
    '1 - Pay | 2 - Deduct'
/
-- End of DDL Script for Table DFN_NTP.M142_CORP_ACT_HOLD_ADJUSTMENTS

ALTER TABLE dfn_ntp.m142_corp_act_hold_adjustments ADD (m142_impact_quantity NUMBER(18,0) DEFAULT 0)
/

alter table dfn_ntp.M142_CORP_ACT_HOLD_ADJUSTMENTS
	add M142_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m142_corp_act_hold_adjustments
    MODIFY (m142_symbol_code_m20 VARCHAR2 (25 BYTE))
/
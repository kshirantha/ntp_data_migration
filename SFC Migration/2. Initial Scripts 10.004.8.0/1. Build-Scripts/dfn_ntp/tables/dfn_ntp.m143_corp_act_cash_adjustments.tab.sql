-- Table DFN_NTP.M143_CORP_ACT_CASH_ADJUSTMENTS

CREATE TABLE dfn_ntp.m143_corp_act_cash_adjustments
(
    m143_id                      NUMBER (15, 0),
    m143_cust_corp_act_id_m141   NUMBER (10, 0),
    m143_type                    NUMBER (1, 0),
    m143_adj_mode                NUMBER (1, 0),
    m143_amount                  NUMBER (18, 5),
    m143_per_stock               NUMBER (5, 0),
    m143_tax_percentage          NUMBER (8, 5),
    m143_narration               VARCHAR2 (200)
)
/



-- Comments for  DFN_NTP.M143_CORP_ACT_CASH_ADJUSTMENTS

COMMENT ON COLUMN dfn_ntp.m143_corp_act_cash_adjustments.m143_type IS
    '1 - Charge | 2 - Cash Adjustment'
/
COMMENT ON COLUMN dfn_ntp.m143_corp_act_cash_adjustments.m143_adj_mode IS
    '1 - Pay | 2 - Deduct'
/
-- End of DDL Script for Table DFN_NTP.M143_CORP_ACT_CASH_ADJUSTMENTS

ALTER TABLE dfn_ntp.m143_corp_act_cash_adjustments ADD (m143_impact_balance NUMBER(18,5) DEFAULT 0)
/

alter table dfn_ntp.M143_CORP_ACT_CASH_ADJUSTMENTS
	add M143_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m143_corp_act_cash_adjustments ADD CONSTRAINT pk_m143_id
  PRIMARY KEY (
  m143_id
)
/

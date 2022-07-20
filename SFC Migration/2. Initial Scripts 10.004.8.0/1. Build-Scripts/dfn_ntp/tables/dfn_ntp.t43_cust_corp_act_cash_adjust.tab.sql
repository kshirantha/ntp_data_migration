-- Table DFN_NTP.T43_CUST_CORP_ACT_CASH_ADJUST

CREATE TABLE dfn_ntp.t43_cust_corp_act_cash_adjust
(
    t43_id                         NUMBER (20, 0),
    t43_cust_distr_id_t41          NUMBER (15, 0),
    t43_corp_act_adj_id_m143       NUMBER (15, 0),
    t43_cash_account_id_u06        NUMBER (10, 0),
    t43_adj_mode                   NUMBER (1, 0),
    t43_amnt_in_txn_currency       NUMBER (18, 5),
    t43_fx_rate                    NUMBER (18, 5),
    t43_amnt_in_stl_currency       NUMBER (18, 5),
    t43_status_id_v01              NUMBER (5, 0),
    t43_status_changed_by_id_u17   NUMBER (10, 0),
    t43_status_changed_date        DATE,
    t43_narration                  VARCHAR2 (500)
)
/



-- Comments for  DFN_NTP.T43_CUST_CORP_ACT_CASH_ADJUST

COMMENT ON COLUMN dfn_ntp.t43_cust_corp_act_cash_adjust.t43_adj_mode IS
    '1 - Charge | 2 - Refund'
/
-- End of DDL Script for Table DFN_NTP.T43_CUST_CORP_ACT_CASH_ADJUST

COMMENT ON COLUMN dfn_ntp.t43_cust_corp_act_cash_adjust.t43_adj_mode IS
    '1 - Withdraw (Deduct) | 2 - Deposit (Pay)'
/

ALTER TABLE dfn_ntp.t43_cust_corp_act_cash_adjust ADD (t43_created_by_id_u17 NUMBER(5,0))
/
ALTER TABLE dfn_ntp.t43_cust_corp_act_cash_adjust ADD (t43_created_date DATE)
/
ALTER TABLE dfn_ntp.t43_cust_corp_act_cash_adjust ADD (t43_modified_by_id_u17 NUMBER(5,0))
/
ALTER TABLE dfn_ntp.t43_cust_corp_act_cash_adjust ADD (t43_modified_date DATE)
/
ALTER TABLE dfn_ntp.t43_cust_corp_act_cash_adjust ADD (t43_cust_corp_act_id_m141 NUMBER(15,0))
/
ALTER TABLE dfn_ntp.t43_cust_corp_act_cash_adjust ADD (t43_tax_amount NUMBER(18,5))
/

alter table dfn_ntp.T43_CUST_CORP_ACT_CASH_ADJUST
	add T43_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.t43_cust_corp_act_cash_adjust
 ADD (
  t43_institute_id_m02 NUMBER (3, 0) DEFAULT 1
 )
/

CREATE INDEX dfn_ntp.idx_t43_corp_act_adj_id_m143
    ON dfn_ntp.t43_cust_corp_act_cash_adjust (t43_corp_act_adj_id_m143)
/

CREATE INDEX dfn_ntp.idx_t43_cust_corp_act_id_m141
    ON dfn_ntp.t43_cust_corp_act_cash_adjust (t43_cust_corp_act_id_m141)
/

ALTER TABLE dfn_ntp.T43_CUST_CORP_ACT_CASH_ADJUST 
 ADD (
  T43_REJECT_REASON VARCHAR2 (4000 BYTE)
 )
/

CREATE INDEX dfn_ntp.idx_t43_id
    ON dfn_ntp.t43_cust_corp_act_cash_adjust (t43_id ASC)
/

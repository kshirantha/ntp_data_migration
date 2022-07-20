-- Table DFN_NTP.T42_CUST_CORP_ACT_HOLD_ADJUST

CREATE TABLE dfn_ntp.t42_cust_corp_act_hold_adjust
(
    t42_id                         NUMBER (20, 0),
    t42_cust_distr_id_t41          NUMBER (15, 0),
    t42_corp_act_adj_id_m142       NUMBER (15, 0),
    t42_trading_acc_id_u07         NUMBER (10, 0),
    t42_adj_mode                   NUMBER (1, 0),
    t42_exchange_id_m01            NUMBER (5, 0),
    t42_exchange_code_m01          VARCHAR2 (10),
    t42_symbol_id_m20              NUMBER (10, 0),
    t42_symbol_code_m20            VARCHAR2 (10),
    t42_from_ratio                 NUMBER (8, 5),
    t42_to_ratio                   NUMBER (8, 5),
    t42_eligible_quantity          NUMBER (18, 0),
    t42_approved_quantity          NUMBER (18, 0),
    t42_avg_cost                   NUMBER (18, 5),
    t42_narration                  VARCHAR2 (500),
    t42_status_id_v01              NUMBER (5, 0),
    t42_status_changed_by_id_u17   NUMBER (10, 0),
    t42_status_changed_date        DATE
)
/



-- Comments for  DFN_NTP.T42_CUST_CORP_ACT_HOLD_ADJUST

COMMENT ON COLUMN dfn_ntp.t42_cust_corp_act_hold_adjust.t42_adj_mode IS
    '1 - Pay | 2 - Deduct'
/
-- End of DDL Script for Table DFN_NTP.T42_CUST_CORP_ACT_HOLD_ADJUST


ALTER TABLE dfn_ntp.t42_cust_corp_act_hold_adjust
 ADD (
  t42_custodian_id_m26 NUMBER (5, 0)
 )
/


ALTER TABLE dfn_ntp.t42_cust_corp_act_hold_adjust
 MODIFY (
  t42_eligible_quantity NUMBER (18, 5)
 )
/

ALTER TABLE dfn_ntp.t42_cust_corp_act_hold_adjust ADD (t42_created_by_id_u17 NUMBER(5,0))
/
ALTER TABLE dfn_ntp.t42_cust_corp_act_hold_adjust ADD (t42_created_date DATE)
/
ALTER TABLE dfn_ntp.t42_cust_corp_act_hold_adjust ADD (t42_modified_by_id_u17 NUMBER(5,0))
/
ALTER TABLE dfn_ntp.t42_cust_corp_act_hold_adjust ADD (t42_modified_date DATE)
/
ALTER TABLE dfn_ntp.t42_cust_corp_act_hold_adjust ADD (t42_cust_corp_act_id_m141 NUMBER(15,0))
/

alter table dfn_ntp.T42_CUST_CORP_ACT_HOLD_ADJUST
	add T42_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.t42_cust_corp_act_hold_adjust
 ADD (
  t42_institute_id_m02 NUMBER (3, 0) DEFAULT 1
 )
/

ALTER TABLE dfn_ntp.t42_cust_corp_act_hold_adjust
    MODIFY (t42_symbol_code_m20 VARCHAR2 (25 BYTE))
/

CREATE INDEX dfn_ntp.idx_t42_cust_corp_act_id_m141
    ON dfn_ntp.t42_cust_corp_act_hold_adjust (t42_cust_corp_act_id_m141)
/

ALTER TABLE dfn_ntp.T42_CUST_CORP_ACT_HOLD_ADJUST 
 ADD (
  T42_REJECT_REASON VARCHAR2 (4000 BYTE)
 )
/

CREATE INDEX dfn_ntp.idx_t42_holdings
    ON dfn_ntp.t42_cust_corp_act_hold_adjust (t42_trading_acc_id_u07 ASC,
                                              t42_custodian_id_m26 ASC,
                                              t42_exchange_code_m01 ASC,
                                              t42_symbol_code_m20 ASC)
/

CREATE INDEX dfn_ntp.idx_t42_cust_distr_id_t41
    ON dfn_ntp.t42_cust_corp_act_hold_adjust (t42_cust_distr_id_t41 ASC)
/

CREATE INDEX dfn_ntp.idx_t42_id
    ON dfn_ntp.t42_cust_corp_act_hold_adjust (t42_id ASC)
/
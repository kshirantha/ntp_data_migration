-- Table DFN_NTP.T41_CUST_CORP_ACT_DISTRIBUTION

CREATE TABLE dfn_ntp.t41_cust_corp_act_distribution
(
    t41_id                         NUMBER (15, 0),
    t41_cust_corp_act_id_m141      NUMBER (10, 0),
    t41_trading_acc_id_u07         NUMBER (10, 0),
    t41_status_id_v01              NUMBER (5, 0),
    t41_status_changed_by_id_u17   NUMBER (10, 0),
    t41_status_changed_date        DATE,
    t41_hold_on_ex_date            NUMBER (18, 0),
    t41_avg_cost_on_ex_date        NUMBER (18, 5),
    t41_is_notified                NUMBER (1, 0),
    t41_reinvest                   NUMBER (1, 0),
    t41_customer_id_u01            NUMBER (10, 0)
)
/



-- Comments for  DFN_NTP.T41_CUST_CORP_ACT_DISTRIBUTION

COMMENT ON COLUMN dfn_ntp.t41_cust_corp_act_distribution.t41_is_notified IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.t41_cust_corp_act_distribution.t41_reinvest IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.t41_cust_corp_act_distribution.t41_customer_id_u01 IS
    'U01_ID'
/
-- End of DDL Script for Table DFN_NTP.T41_CUST_CORP_ACT_DISTRIBUTION

ALTER TABLE dfn_ntp.t41_cust_corp_act_distribution
RENAME COLUMN t41_hold_on_ex_date TO t41_hold_on_rec_date
/

ALTER TABLE dfn_ntp.t41_cust_corp_act_distribution ADD (t41_cash_acc_id_u06 NUMBER(10,0))
/
ALTER TABLE dfn_ntp.t41_cust_corp_act_distribution ADD (t41_created_by_id_u17 NUMBER(5,0))
/
ALTER TABLE dfn_ntp.t41_cust_corp_act_distribution ADD (t41_created_date DATE)
/
ALTER TABLE dfn_ntp.t41_cust_corp_act_distribution ADD (t41_modified_by_id_u17 NUMBER(5,0))
/
ALTER TABLE dfn_ntp.t41_cust_corp_act_distribution ADD (t41_modified_date DATE)
/
ALTER TABLE dfn_ntp.t41_cust_corp_act_distribution ADD (t41_pending_adjustment NUMBER(1,0) DEFAULT 0)
/

alter table dfn_ntp.T41_CUST_CORP_ACT_DISTRIBUTION
	add T41_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.t41_cust_corp_act_distribution
 ADD (
  t41_institute_id_m02 NUMBER (3, 0) DEFAULT 1
 )
/

CREATE INDEX dfn_ntp.idx_t41_cust_corp_act_id_m141
    ON dfn_ntp.t41_cust_corp_act_distribution (t41_cust_corp_act_id_m141)
/

CREATE INDEX dfn_ntp.idx_t41_id
    ON dfn_ntp.t41_cust_corp_act_distribution (t41_id ASC)
/


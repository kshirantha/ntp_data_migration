CREATE TABLE dfn_ntp.t79_custody_excb_cash_acnt_log
(
    t79_id                       NUMBER (18, 0),
    t79_id_t78                   NUMBER (18, 0),
    t79_institute_id_m02         NUMBER (3, 0),
    t79_custodian_id_m26         NUMBER (18, 0),
    t79_cash_acc_id_m185         NUMBER (10, 0),
    t79_txn_id_m97               NUMBER (5, 0),
    t79_txn_code_m97             VARCHAR2 (50 BYTE),
    t79_amnt_in_stl_currency     NUMBER (18, 5),
    t79_amnt_in_txn_currency     NUMBER (18, 5),
    t79_fx_rate                  NUMBER (18, 5),
    t79_txn_date                 DATE,
    t79_txn_currency_code_m03    VARCHAR2 (50 BYTE),
    t79_stl_currency_code_m03    VARCHAR2 (50 BYTE),
    t79_created_by_u17           NUMBER (10, 0),
    t79_created_date             DATE,
    t79_status_id_v01            NUMBER (5, 0) DEFAULT 1,
    t79_status_change_by_u17     NUMBER (10, 0),
    t79_status_change_date       DATE,
    t79_custom_type              VARCHAR2 (50 BYTE) DEFAULT 1,
    t79_current_approval_level   NUMBER (3, 0),
    t79_id_t83                   NUMBER (18, 0)
)
/



ALTER TABLE dfn_ntp.t79_custody_excb_cash_acnt_log
    ADD CONSTRAINT t79_pk PRIMARY KEY (t79_id) USING INDEX
/
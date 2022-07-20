CREATE TABLE dfn_ntp.t07_nastro_account_log
(
    t07_id                      NUMBER (10, 0),
    t07_institute_id_m02        NUMBER (3, 0),
    t07_custodian_id_m26        NUMBER (18, 0),
    t07_nastro_acc_id_m72       NUMBER (10, 0),
    t07_txn_id_m97              NUMBER (5, 0),
    t07_txn_code_m97            VARCHAR2 (50 BYTE),
    t07_amnt_in_stl_currency    NUMBER (18, 5),
    t07_amnt_in_txn_currency    NUMBER (18, 5),
    t07_fx_rate                 NUMBER (18, 5),
    t07_txn_date                DATE,
    t07_txn_currency_code_m03   VARCHAR2 (50 BYTE),
    t07_stl_currency_code_m03   VARCHAR2 (50 BYTE),
    t07_trans_activity_id_v01   NUMBER (5, 0),
    t07_custom_type             VARCHAR2 (50 BYTE) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.t07_nastro_account_log
ADD CONSTRAINT t07_pk PRIMARY KEY (t07_id)
USING INDEX
/
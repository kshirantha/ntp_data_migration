CREATE TABLE dfn_ntp.t502_change_account_requests_c
(
    t502_id                        NUMBER (18, 0),
    t502_from_trading_acc_id_u07   NUMBER (18, 0),
    t502_from_cash_acc_id_u06      NUMBER (18, 0),
    t502_target_cash_acc_id_u06    NUMBER (18, 0),
    t502_status_id_v01             NUMBER (5, 0),
    t502_institute_id_m02          NUMBER (5, 0),
    t502_entered_by_id_u17         NUMBER (10, 0),
    t502_entered_date              DATE,
    t502_last_changed_by_id_u17    NUMBER (10, 0),
    t502_last_changed_date         DATE,
    t502_current_approval_level    NUMBER (3, 0),
    t502_custom_type               VARCHAR2 (50 BYTE)
)
/



ALTER TABLE dfn_ntp.t502_change_account_requests_c
    ADD CONSTRAINT t502_id_pk PRIMARY KEY (t502_id) USING INDEX
/
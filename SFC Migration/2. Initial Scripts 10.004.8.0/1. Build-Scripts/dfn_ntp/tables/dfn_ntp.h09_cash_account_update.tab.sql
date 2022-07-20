-- Table DFN_NTP.H09_CASH_ACCOUNT_UPDATE

CREATE TABLE dfn_ntp.h09_cash_account_update
(
    h09_cash_acc_id_u06   NUMBER (18, 0),
    h09_investor_acc_no   VARCHAR2 (75),
    h09_client_id_u01     NUMBER (9, 0),
    h09_account_balance   NUMBER (25, 6),
    h09_date              DATE
)
/



-- Indexes for  DFN_NTP.H09_CASH_ACCOUNT_UPDATE


CREATE INDEX dfn_ntp.idx_h09_cassh_acc_id
    ON dfn_ntp.h09_cash_account_update (h09_cash_acc_id_u06)
/

CREATE INDEX dfn_ntp.idx_h09_date
    ON dfn_ntp.h09_cash_account_update (h09_date)
/


-- End of DDL Script for Table DFN_NTP.H09_CASH_ACCOUNT_UPDATE

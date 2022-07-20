-- Table DFN_NTP.U43_USER_CASH_ACCOUNTS

CREATE TABLE dfn_ntp.u43_user_cash_accounts
(
    u43_id                    NUMBER,
    u43_user_id_u17           NUMBER,
    u43_cash_account_id_u06   NUMBER,
    u43_assigned_by_id_u17    NUMBER,
    u43_assigned_date         DATE
)
/



-- End of DDL Script for Table DFN_NTP.U43_USER_CASH_ACCOUNTS

alter table dfn_ntp.U43_USER_CASH_ACCOUNTS
	add U43_CUSTOM_TYPE varchar2(50) default 1
/

CREATE INDEX dfn_ntp.idx_u43_user_id_u17
    ON dfn_ntp.u43_user_cash_accounts (u43_user_id_u17)
/

CREATE INDEX dfn_ntp.idx_u43_cash_account_id_u06
    ON dfn_ntp.u43_user_cash_accounts (u43_cash_account_id_u06)
/

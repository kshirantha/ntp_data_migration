CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_user_cash_accounts
(
    u43_id,
    u43_user_id_u17,
    u43_cash_account_id_u06,
    u43_assigned_by_id_u17,
    u43_assigned_date,
    assigned_by_full_name,
    u06_display_name,
    u06_display_name_u01,
    u06_customer_no_u01
)
AS
    SELECT a.u43_id,
           a.u43_user_id_u17,
           a.u43_cash_account_id_u06,
           a.u43_assigned_by_id_u17,
           a.u43_assigned_date,
           u17.u17_full_name AS assigned_by_full_name,
           u06.u06_display_name,
           u06.u06_display_name_u01,
           u06.u06_customer_no_u01
      FROM u43_user_cash_accounts a
           LEFT JOIN u17_employee u17
               ON u17.u17_id = a.u43_assigned_by_id_u17
           LEFT JOIN u06_cash_account u06
               ON u06.u06_id = a.u43_cash_account_id_u06;
/

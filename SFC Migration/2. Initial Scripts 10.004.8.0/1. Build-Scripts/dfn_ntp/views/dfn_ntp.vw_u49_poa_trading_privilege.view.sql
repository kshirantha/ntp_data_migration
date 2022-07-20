CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u49_poa_trading_privilege
(
    u49_poa_id_u47,
    u49_trading_account_id_u07,
    u49_issue_date,
    u49_poa_expiry_date,
    u49_buy_restrict,
    u49_sell_restrict,
    u49_stock_deposit_restrict,
    u49_stock_withdraw_restrict,
    u49_stock_transfer_restrict,
    u49_deposit_restrict,
    u49_withdraw_restrict,
    u49_transfer_restrict
)
AS
      SELECT MAX (u49_poa_id_u47) AS u49_poa_id_u47,
             u49_trading_account_id_u07,
             MAX (u49_issue_date) AS u49_issue_date,
             MAX (u49_poa_expiry_date) AS u49_poa_expiry_date,
             MAX (buy) AS u49_buy_restrict,
             MAX (sell) AS u49_sell_restrict,
             MAX (stock_deposit) AS u49_stock_deposit_restrict,
             MAX (stock_withdraw) AS u49_stock_withdraw_restrict,
             MAX (stock_transfer) AS u49_stock_transfer_restrict,
             MAX (deposit) AS u49_deposit_restrict,
             MAX (withdraw) AS u49_withdraw_restrict,
             MAX (tansfer) AS u49_transfer_restrict
        FROM (SELECT u49_poa_id_u47,
                     u49_trading_account_id_u07,
                     u49_issue_date,
                     u49_poa_expiry_date,
                     CASE
                         WHEN u49_privilege_type_id_v31 = 1 THEN 1
                         WHEN u49_privilege_type_id_v31 = 3 THEN 1
                         ELSE 0
                     END
                         AS buy,
                     CASE
                         WHEN u49_privilege_type_id_v31 = 2 THEN 1
                         WHEN u49_privilege_type_id_v31 = 3 THEN 1
                         ELSE 0
                     END
                         AS sell,
                     CASE WHEN u49_privilege_type_id_v31 = 6 THEN 1 ELSE 0 END
                         AS stock_deposit,
                     CASE WHEN u49_privilege_type_id_v31 = 7 THEN 1 ELSE 0 END
                         AS stock_withdraw,
                     CASE WHEN u49_privilege_type_id_v31 = 8 THEN 1 ELSE 0 END
                         AS stock_transfer,
                     CASE WHEN u49_privilege_type_id_v31 = 9 THEN 1 ELSE 0 END
                         AS deposit,
                     CASE WHEN u49_privilege_type_id_v31 = 10 THEN 1 ELSE 0 END
                         AS withdraw,
                     CASE WHEN u49_privilege_type_id_v31 = 11 THEN 1 ELSE 0 END
                         AS tansfer
                FROM u49_poa_trading_privileges)
    GROUP BY u49_trading_account_id_u07;
/

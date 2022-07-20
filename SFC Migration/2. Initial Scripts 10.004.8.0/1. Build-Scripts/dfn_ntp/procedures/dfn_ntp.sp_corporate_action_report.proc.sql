CREATE OR REPLACE PROCEDURE dfn_ntp.sp_corporate_action_report (
    p_view              OUT SYS_REFCURSOR,
    prows               OUT NUMBER,
    p_cash_account_id       NUMBER,
    p_d1                    DATE,
    p_d2                    DATE)
IS
BEGIN
    OPEN p_view FOR
        SELECT u07.u07_customer_id_u01,
               u07.u07_customer_no_u01,
               u07.u07_display_name_u01,
               u07.u07_id,
               u07.u07_display_name,
               m20.m20_symbol_code,
               (m20.m20_symbol_code || ' ' || '-' || ' ' || m20.m20_isincode)
                   AS security_name,
               (  t23.t23_file_current_balance
                - t23.t23_current_balance_difference)
                   AS previoushld,
               t23.t23_file_current_balance AS newhld,
               m20.m20_short_description,
               m20.m20_long_description,
               t23.t23_last_trade_price,
               t23.t23_exchange_id_m01,
               t23.t23_position_date,
               t23.t23_changed_date,
               t23.t23_upload_date,
               u07.u07_cash_account_id_u06,
               m20.m20_isincode
          FROM t23_share_txn_requests t23,
               u07_trading_account u07,
               m20_symbol m20
         WHERE     t23.t23_trading_acc_id_u07 = u07.u07_id
               AND t23.t23_symbol_id_m20 = m20.m20_id
               AND u07.u07_cash_account_id_u06 = p_cash_account_id
               AND TRUNC (t23.t23_position_date) BETWEEN TRUNC (
                                                             TO_DATE (p_d1))
                                                     AND   TRUNC (
                                                               TO_DATE (p_d2))
                                                         + 0.9999
               AND t23.t23_status_id_v01 NOT IN (3) ;
END;
/
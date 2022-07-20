CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_ca_eligible_customers (
    p_view               OUT SYS_REFCURSOR,
    p_record_date     IN     VARCHAR,
    p_exchange_code   IN     VARCHAR,
    p_symbol_id       IN     INT,
    p_custodian_id    IN     INT)
IS
BEGIN
    OPEN p_view FOR
        SELECT ROWNUM AS id,
               h01_date AS record_date,
               h01_exchange_code_m01 AS exchange_code,
               h01_symbol_id_m20 AS symbol_id,
               h01_custodian_id_m26 AS custodian_id,
               h01.h01_trading_acnt_id_u07 AS trading_acnt_id,
               h01.h01_net_holding AS net_holding,
               h01.h01_avg_cost AS avg_cost,
               u07.u07_customer_id_u01 AS customer_id,
               u07.u07_cash_account_id_u06 AS cash_account_id,
               u07.u07_institute_id_m02 AS institute_id
          FROM     vw_h01_holding_summary h01
               INNER JOIN
                   u07_trading_account u07
               ON h01.h01_trading_acnt_id_u07 = u07.u07_id
         WHERE     h01.h01_date = TO_DATE (p_record_date, 'dd-MM-yyyy')
               AND h01.h01_exchange_code_m01 = p_exchange_code
               AND h01.h01_symbol_id_m20 = p_symbol_id
               AND h01.h01_custodian_id_m26 = p_custodian_id
               AND h01.h01_net_holding > 0;
END;
/

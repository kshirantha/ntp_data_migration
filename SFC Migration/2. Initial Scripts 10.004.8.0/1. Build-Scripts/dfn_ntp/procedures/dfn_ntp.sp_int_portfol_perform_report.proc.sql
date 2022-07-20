CREATE OR REPLACE PROCEDURE dfn_ntp.sp_int_portfol_perform_report (
    p_view      OUT SYS_REFCURSOR,
    prows       OUT NUMBER,
    pfromdate       DATE DEFAULT SYSDATE,
    ptodate         DATE DEFAULT SYSDATE,
    pcurrency       VARCHAR2 DEFAULT 'SAR')
IS
BEGIN
    prows := 0;

    OPEN p_view FOR
        SELECT 1   AS type_id,
               NULL AS type_description,
               MAX (v09.v09_code) AS inst_type_code,
               MAX (UPPER (v09.v09_description)) AS inst_type_description,
               SUM (buy_count) AS buy_count,
               SUM (buy_amount) AS buy_amount,
               SUM (sell_count) AS sell_count,
               SUM (sell_amount) AS sell_amount,
               NULL AS region
        FROM (SELECT t02.t02_cash_acnt_id_u06,
                     t02.t02_order_no,
                     t02.t02_symbol_id_m20,
                     t02.t02_txn_code,
                     CASE WHEN t02.t02_txn_code = 'STLBUY' THEN 1 ELSE 0 END
                         AS buy_count,
                     CASE
                         WHEN t02.t02_txn_code = 'STLBUY'
                         THEN
                             SUM (
                                   ABS (t02.t02_amnt_in_txn_currency)
                                 -   ABS (t02.t02_commission_adjst)
                                   * NVL (m04.m04_rate, 1))
                         ELSE
                             0
                     END
                         AS buy_amount,
                     CASE WHEN t02.t02_txn_code = 'STLSEL' THEN 1 ELSE 0 END
                         AS sell_count,
                     CASE
                         WHEN t02.t02_txn_code = 'STLSEL'
                         THEN
                             SUM (
                                   ABS (t02.t02_amnt_in_txn_currency)
                                 -   ABS (t02.t02_commission_adjst)
                                   * NVL (m04.m04_rate, 1))
                         ELSE
                             0
                     END
                         AS sell_amount
              FROM t02_transaction_log_order_all t02
                   LEFT JOIN m04_currency_rate m04
                       ON t02.t02_settle_currency =
                          m04.m04_from_currency_code_m03
                   LEFT JOIN m01_exchanges m01
                       ON t02.t02_exchange_code_m01 = m01.m01_exchange_code
              WHERE     t02.t02_trade_process_stat_id_v01 = 25
                    AND t02.t02_gl_posted_status = 1
                    AND m01.m01_is_local <> 1
                    AND t02.t02_cash_settle_date BETWEEN pfromdate
                                                     AND ptodate + .99999
                    AND t02.t02_create_date BETWEEN   pfromdate
                                                    - fn_get_max_txn_stl_date_diff
                                                AND ptodate + 0.99999
                    AND m04.m04_to_currency_code_m03 = pcurrency
              GROUP BY t02.t02_cash_acnt_id_u06,
                       t02.t02_order_no,
                       t02.t02_symbol_id_m20,
                       t02.t02_txn_code) t02,
             m20_symbol m20,
             v09_instrument_types v09
        WHERE     t02.t02_symbol_id_m20 = m20.m20_id
              AND m20_instrument_type_code_v09 = v09.v09_code
        GROUP BY v09.v09_id
        UNION ALL
        SELECT 2   AS TYPE,
               'Region wise distribution' AS type_description,
               MAX (v09.v09_code) AS inst_type_code,
               MAX (UPPER (v09.v09_description)) AS inst_type_description,
               NULL AS buy_count,
               SUM (buy_amount + sell_amount) AS buy_amount,
               NULL AS sell_count,
               NULL AS sell_amount,
               NVL (v01.v01_description, TO_CHAR ('Rest of the World')) AS region
        FROM (SELECT t02.t02_cash_acnt_id_u06,
                     t02.t02_order_no,
                     t02.t02_symbol_id_m20,
                     MAX (t02.t02_exchange_code_m01)
                         AS t02_exchange_code_m01,
                     t02.t02_txn_code,
                     CASE WHEN t02.t02_txn_code = 'STLBUY' THEN 1 ELSE 0 END
                         AS buy_count,
                     CASE
                         WHEN t02.t02_txn_code = 'STLBUY'
                         THEN
                             SUM (
                                   ABS (t02.t02_amnt_in_txn_currency)
                                 -   ABS (t02.t02_commission_adjst)
                                   * NVL (m04.m04_rate, 1))
                         ELSE
                             0
                     END
                         AS buy_amount,
                     CASE WHEN t02.t02_txn_code = 'STLSEL' THEN 1 ELSE 0 END
                         AS sell_count,
                     CASE
                         WHEN t02.t02_txn_code = 'STLSEL'
                         THEN
                             SUM (
                                   ABS (t02.t02_amnt_in_txn_currency)
                                 -   ABS (t02.t02_commission_adjst)
                                   * NVL (m04.m04_rate, 1))
                         ELSE
                             0
                     END
                         AS sell_amount
              FROM t02_transaction_log_order_all t02
                   LEFT JOIN m04_currency_rate m04
                       ON t02.t02_settle_currency =
                          m04.m04_from_currency_code_m03
                   LEFT JOIN m01_exchanges m01
                       ON t02.t02_exchange_code_m01 = m01.m01_exchange_code
              WHERE     t02.t02_trade_process_stat_id_v01 = 25
                    AND t02.t02_gl_posted_status = 1
                    AND m01.m01_is_local <> 1
                    AND t02.t02_cash_settle_date BETWEEN pfromdate
                                                     AND ptodate + .99999
                    AND t02.t02_create_date BETWEEN   pfromdate
                                                    - fn_get_max_txn_stl_date_diff
                                                AND ptodate + 0.99999
                    AND m04.m04_to_currency_code_m03 = pcurrency
              GROUP BY t02.t02_cash_acnt_id_u06,
                       t02.t02_order_no,
                       t02.t02_symbol_id_m20,
                       t02.t02_txn_code) t02,
             m20_symbol m20,
             v09_instrument_types v09,
             m01_exchanges m01,
             m05_country m05,
             v01_system_master_data v01
        WHERE     t02.t02_symbol_id_m20 = m20.m20_id
              AND m20_instrument_type_code_v09 = v09.v09_code
              AND t02.t02_exchange_code_m01 = m01.m01_exchange_code
              AND m01.m01_country_id_m05 = m05.m05_id
              AND m05.m05_access_level_id_v01 = v01.v01_id
              AND v01.v01_type = 1
        GROUP BY v09.v09_id, v01.v01_description
        UNION ALL
        SELECT 3   AS TYPE,
               'Nationality wise distribution' AS type_description,
               MAX (v09.v09_code) AS inst_type_code,
               MAX (UPPER (v09.v09_description)) AS inst_type_description,
               COUNT (u01.u01_id) AS buy_count,
               SUM (buy_amount) AS buy_amount,
               NULL AS sell_count,
               NULL AS sell_amount,
               MAX (m05.m05_name) AS region
        FROM (SELECT t02.t02_cash_acnt_id_u06,
                     t02.t02_customer_id_u01,
                     t02.t02_order_no,
                     t02.t02_symbol_id_m20,
                     MAX (t02.t02_exchange_code_m01)
                         AS t02_exchange_code_m01,
                     t02.t02_txn_code,
                     CASE WHEN t02.t02_txn_code = 'STLBUY' THEN 1 ELSE 0 END
                         AS buy_count,
                     CASE
                         WHEN t02.t02_txn_code = 'STLBUY'
                         THEN
                             SUM (
                                   ABS (t02.t02_amnt_in_txn_currency)
                                 -   ABS (t02.t02_commission_adjst)
                                   * NVL (m04.m04_rate, 1))
                         ELSE
                             0
                     END
                         AS buy_amount,
                     CASE WHEN t02.t02_txn_code = 'STLSEL' THEN 1 ELSE 0 END
                         AS sell_count,
                     CASE
                         WHEN t02.t02_txn_code = 'STLSEL'
                         THEN
                             SUM (
                                   ABS (t02.t02_amnt_in_txn_currency)
                                 -   ABS (t02.t02_commission_adjst)
                                   * NVL (m04.m04_rate, 1))
                         ELSE
                             0
                     END
                         AS sell_amount
              FROM t02_transaction_log_order_all t02
                   LEFT JOIN m04_currency_rate m04
                       ON t02.t02_settle_currency =
                          m04.m04_from_currency_code_m03
                   LEFT JOIN m01_exchanges m01
                       ON t02.t02_exchange_code_m01 = m01.m01_exchange_code
              WHERE     t02.t02_trade_process_stat_id_v01 = 25
                    AND t02.t02_gl_posted_status = 1
                    AND m01.m01_is_local <> 1
                    AND t02.t02_cash_settle_date BETWEEN pfromdate
                                                     AND ptodate + .99999
                    AND t02.t02_create_date BETWEEN   pfromdate
                                                    - fn_get_max_txn_stl_date_diff
                                                AND ptodate + 0.99999
                    AND m04.m04_to_currency_code_m03 = pcurrency
              GROUP BY t02.t02_cash_acnt_id_u06,
                       t02.t02_order_no,
                       t02.t02_symbol_id_m20,
                       t02.t02_txn_code,
                       t02.t02_customer_id_u01) t02,
             m20_symbol m20,
             v09_instrument_types v09,
             m01_exchanges m01,
             u01_customer u01,
             m05_country m05
        WHERE     t02.t02_symbol_id_m20 = m20.m20_id
              AND m20_instrument_type_code_v09 = v09.v09_code
              AND t02.t02_exchange_code_m01 = m01.m01_exchange_code
              AND m01.m01_country_id_m05 = m05.m05_id
              AND u01.u01_id = t02.t02_customer_id_u01
        GROUP BY v09.v09_id, m05.m05_id
        UNION ALL
        SELECT 4   AS TYPE,
               'Gross Commission' AS type_description,
               MAX (v09.v09_code) AS inst_type_code,
               MAX (UPPER (v09.v09_description)) AS inst_type_description,
               NULL AS buy_count,
               SUM (buy_commission + sell_commission) AS buy_amount,
               NULL AS sell_count,
               NULL AS sell_amount,
               NULL AS region
        FROM (SELECT t02.t02_cash_acnt_id_u06,
                     t02.t02_order_no,
                     t02.t02_symbol_id_m20,
                     t02.t02_txn_code,
                     CASE WHEN t02.t02_txn_code = 'STLBUY' THEN 1 ELSE 0 END
                         AS buy_count,
                     CASE
                         WHEN t02.t02_txn_code = 'STLBUY'
                         THEN
                             SUM (
                                   ABS (t02.t02_commission_adjst)
                                 * NVL (m04.m04_rate, 1))
                         ELSE
                             0
                     END
                         AS buy_commission,
                     CASE WHEN t02.t02_txn_code = 'STLSEL' THEN 1 ELSE 0 END
                         AS sell_count,
                     CASE
                         WHEN t02.t02_txn_code = 'STLSEL'
                         THEN
                             SUM (
                                   ABS (t02.t02_commission_adjst)
                                 * NVL (m04.m04_rate, 1))
                         ELSE
                             0
                     END
                         AS sell_commission
              FROM t02_transaction_log_order_all t02
                   LEFT JOIN m04_currency_rate m04
                       ON t02.t02_settle_currency =
                          m04.m04_from_currency_code_m03
                   LEFT JOIN m01_exchanges m01
                       ON t02.t02_exchange_code_m01 = m01.m01_exchange_code
              WHERE     t02.t02_trade_process_stat_id_v01 = 25
                    AND t02.t02_gl_posted_status = 1
                    AND m01.m01_is_local <> 1
                    AND t02.t02_cash_settle_date BETWEEN pfromdate
                                                     AND ptodate + .99999
                    AND t02.t02_create_date BETWEEN   pfromdate
                                                    - fn_get_max_txn_stl_date_diff
                                                AND ptodate + 0.99999
                    AND m04.m04_to_currency_code_m03 = pcurrency
              GROUP BY t02.t02_cash_acnt_id_u06,
                       t02.t02_order_no,
                       t02.t02_symbol_id_m20,
                       t02.t02_txn_code) t02,
             m20_symbol m20,
             v09_instrument_types v09
        WHERE     t02.t02_symbol_id_m20 = m20.m20_id
              AND m20_instrument_type_code_v09 = v09.v09_code
        GROUP BY v09.v09_id;
END;
/
CREATE OR REPLACE PROCEDURE dfn_ntp.sp_cash_statement (
    p_view              OUT SYS_REFCURSOR,
    prows               OUT NUMBER,
    p_cash_account_id       NUMBER,
    p_d1                    DATE,
    p_d2                    DATE,
    p_decimals              NUMBER DEFAULT 5,
    ptype                   NUMBER DEFAULT 1 --1 - by Settlement Date | 2 - by Transaction Date
                                            )
IS
    lcount     NUMBER;
    lformat    VARCHAR (100);
    l_status   NUMBER;
BEGIN
    lformat := '9,999';
    lcount := 0;

    IF (p_decimals > 0)
    THEN
        lformat := lformat || '.';

        WHILE (lcount < p_decimals)
        LOOP
            lformat := lformat || '9';
            lcount := lcount + 1;
        END LOOP;
    END IF;

    OPEN p_view FOR
        SELECT 0 AS rownumber,
               0 AS id,
               TO_NUMBER (NULL) AS dr,
               TO_NUMBER (NULL) AS cr,
               p_d1 AS transaction_date,
               p_d1 AS settlement_date,
               p_d1 - 5 AS timestamp,
               NULL AS t_2,
               ' ' AS action,
               'Opening Balance' AS description,
               NULL AS description_ar,
               ROUND (
                   (  h02_balance
                    + h02.h02_payable_blocked
                    - h02.h02_receivable_amount),
                   2)
                   AS amount,
               0 AS availableamt,
               0 AS commission,
               'OPENBAL' AS code,
               '' AS symbol,
               0 AS orderqty,
               0 AS lastpx,
               '' AS orderno,
               '' exchange,
               NULL AS cash_txn_ref,
               NULL AS from_acc,
               NULL AS to_acc,
               NULL AS transaction_id,
               '' AS short_description_lang,
               '' AS short_description,
               NULL AS reference_doc_no,
               NULL AS reference_doc_narration,
               NULL AS payment_method,
               NULL AS pay_method,
               NULL AS cheque_no,
               u06.u06_institute_id_m02 AS institute_id,
               0 AS totalvat,
               NULL AS isincode,
               h02_loan_amount AS loan_balance
          FROM (  SELECT MAX (h02_date) AS h02_date,
                         SUM (h02_balance) AS h02_balance,
                         SUM (h02_payable_blocked) AS h02_payable_blocked,
                         SUM (h02_receivable_amount) AS h02_receivable_amount,
                         h02_cash_account_id_u06,
                         SUM (h02_loan_amount) AS h02_loan_amount
                    FROM (SELECT h02.h02_date,
                                 h02_balance,
                                 h02.h02_payable_blocked,
                                 h02.h02_receivable_amount,
                                 h02.h02_cash_account_id_u06,
                                 h02.h02_loan_amount
                            FROM vw_h02_cash_account_summary h02
                           WHERE     h02.h02_date = TRUNC (p_d1 - 1)
                                 AND h02.h02_cash_account_id_u06 =
                                         p_cash_account_id
                          UNION ALL
                          SELECT p_d1 - 1,
                                 0,
                                 0,
                                 0,
                                 p_cash_account_id,
                                 0
                            FROM DUAL)
                GROUP BY h02_cash_account_id_u06) h02,
               u06_cash_account u06
         WHERE     h02.h02_date = TRUNC (p_d1 - 1)
               AND h02.h02_cash_account_id_u06 = p_cash_account_id
               AND u06.u06_id = p_cash_account_id
        UNION ALL
        SELECT 0 AS rownumber,
               0 AS id,
               ROUND (dr, p_decimals) AS dr,
               ROUND (cr, p_decimals) AS cr,
               TRUNC (t02.t02_create_date) AS transaction_date,
               t02.t02_cash_settle_date AS settlement_date,
               t02.t02_txn_time AS timestamp,
               NULL AS t_2,
               action,
               TO_CHAR (t02.t02_narration) AS description,
               --TODO  Need to discuss
               NVL (t02.t02_narration_lang, TO_CHAR (t02.t02_narration))
                   AS description_ar,
               --TODO  Need to discuss
               ROUND (t02.t02_amnt_in_stl_currency, p_decimals) AS amount,
               0 AS availableamt,
               ROUND (t02.commission, p_decimals) AS commission,
               t02.t02_txn_code AS code,
               t02.t02_symbol_code_m20 AS symbol,
               t02.t02_ordqty AS orderqty,
               ROUND (t02.t02_last_price, p_decimals) AS lastpx,
               t02.t02_order_no AS orderno,
               t02.t02_exchange_code_m01 AS exchange,
               NULL AS cash_txn_ref,
               NULL AS from_acc, -- t02.from_acc, TODO  Need to discuss
               NULL AS to_acc, --t02.to_acc, TODO  Need to discuss
               t02.transaction_id,
               t02.m20_short_description_lang AS short_description_lang,
               t02.m20_short_description AS short_description,
               NULL AS reference_doc_no, --TODO need to add reference_doc_no
               NULL AS reference_doc_narration,
               t02.t02_pay_method AS payment_method,
               CASE t02.t02_pay_method
                   WHEN '1' THEN 'Cash'
                   WHEN '2' THEN 'Cheque'
                   WHEN '3' THEN 'Transfer'
                   ELSE 'Cash'
               END
                   AS pay_method,
               NULL AS cheque_no,
               t02.t02_inst_id_m02 AS institute_id,
               NVL (t02.t02_broker_vat, 0) + NVL (t02.t02_exchange_vat, 0)
                   AS totalvat, -- TODO Need To Finalize about vat
               t02.m20_isincode AS isincode,
               0 AS loan_balance
          FROM (  SELECT MAX (t02.t02_order_no) AS transaction_id,
                         MAX (t02.t02_create_date) AS t02_create_date,
                         MIN (t02.t02_txn_time) AS t02_txn_time,
                         t02.t02_cash_acnt_id_u06,
                         t02.t02_cash_settle_date,
                         MAX (t02.t02_inst_id_m02) AS t02_inst_id_m02,
                         MAX (t02.t02_exchange_code_m01)
                             AS t02_exchange_code_m01,
                         MAX (t02.t02_symbol_code_m20) AS t02_symbol_code_m20,
                         MAX (m20.m20_short_description)
                             AS m20_short_description,
                         MAX (m20.m20_short_description_lang)
                             AS m20_short_description_lang,
                         MAX (m20.m20_isincode) AS m20_isincode,
                         t02.t02_txn_code,
                         MAX (m97.m97_description) AS action,
                         MAX (m97.m97_description_lang) AS action_lang,
                         MAX (t02.t02_pay_method) AS t02_pay_method,
                         SUM (t02.t02_amnt_in_stl_currency)
                             AS t02_amnt_in_stl_currency,
                         SUM (t02.t02_broker_tax) AS t02_broker_vat,
                         SUM (t02.t02_exchange_tax) AS t02_exchange_vat,
                         CASE
                             WHEN SUM (t02.t02_amnt_in_stl_currency) >= 0
                             THEN
                                 SUM (t02.t02_amnt_in_stl_currency)
                             ELSE
                                 0
                         END
                             AS cr,
                         CASE
                             WHEN SUM (t02.t02_amnt_in_stl_currency) < 0
                             THEN
                                 ABS (SUM (t02.t02_amnt_in_stl_currency))
                             ELSE
                                 0
                         END
                             AS dr,
                         t02.t02_order_no,
                         SUM (t02.t02_last_shares) AS t02_ordqty,
                         ROUND (AVG (t02.t02_last_price),
                                MAX (m03.m03_decimal_places))
                             AS t02_last_price,
                         MAX (t02.t02_cum_commission) AS commission,
                         MAX (m20.m20_exchange_id_m01) AS exchange_id,
                         MAX (t02.t02_narration) AS t02_narration,
                         MAX (t02.t02_narration_lang) AS t02_narration_lang
                    FROM t02_transaction_log_cash_arc t02
                         JOIN m20_symbol m20
                             ON t02.t02_symbol_id_m20 = m20.m20_id
                         JOIN m03_currency m03
                             ON t02.t02_txn_currency = m03.m03_code
                         JOIN vw_m97_cash_txn_codes_base m97
                             ON t02.t02_txn_code = m97.m97_code
                   WHERE     t02.t02_update_type = 1
                         AND t02.t02_create_date BETWEEN TRUNC (
                                                               p_d1
                                                             - CASE
                                                                   WHEN ptype =
                                                                            2 --1 - by Settlement Date | 2 - by Transaction Date
                                                                   THEN
                                                                       0
                                                                   ELSE
                                                                       fn_get_max_txn_stl_date_diff
                                                               END)
                                                     AND TRUNC (p_d2) + 0.99999
                         AND t02.t02_cash_settle_date BETWEEN TRUNC (p_d1)
                                                          AND   TRUNC (
                                                                      p_d2
                                                                    + CASE
                                                                          WHEN ptype =
                                                                                   2 --1 - by Settlement Date | 2 - by Transaction Date
                                                                          THEN
                                                                              fn_get_max_txn_stl_date_diff
                                                                          ELSE
                                                                              0
                                                                      END)
                                                              + 0.99999
                GROUP BY t02.t02_cash_acnt_id_u06,
                         t02.t02_order_no,
                         t02.t02_txn_code,
                         t02.t02_cash_settle_date,
                         t02.t02_symbol_id_m20
                UNION ALL
                SELECT    NVL (t02.t02_cashtxn_id, t02.t02_txn_refrence_id)
                       || ''
                           AS transaction_id,
                       t02.t02_create_date,
                       t02.t02_txn_time,
                       t02.t02_cash_acnt_id_u06,
                       t02.t02_cash_settle_date,
                       t02.t02_inst_id_m02,
                       t02.t02_exchange_code_m01,
                       t02.t02_symbol_code_m20 AS t02_symbol_code_m20,
                       m20.m20_short_description,
                       m20.m20_short_description_lang,
                       m20.m20_isincode,
                       t02.t02_txn_code,
                       m97.m97_description,
                       m97.m97_description_lang,
                       t02.t02_pay_method,
                       t02.t02_amnt_in_stl_currency,
                       t02.t02_broker_tax,
                       t02.t02_exchange_tax,
                       CASE
                           WHEN t02.t02_amnt_in_stl_currency >= 0
                           THEN
                               t02.t02_amnt_in_stl_currency
                           ELSE
                               0
                       END
                           AS dr,
                       CASE
                           WHEN t02.t02_amnt_in_stl_currency < 0
                           THEN
                               ABS (t02.t02_amnt_in_stl_currency)
                           ELSE
                               0
                       END
                           AS cr,
                       NULL AS t02_order_no,
                       NULL AS t02_ordqty,
                       NULL AS t02_last_price,
                       NULL AS t02_cum_commission,
                       m20.m20_exchange_id_m01 AS exchange_id,
                       t02.t02_narration AS t02_narration,
                       t02.t02_narration_lang AS t02_narration_lang
                  FROM t02_transaction_log_cash_arc t02
                       JOIN vw_m97_cash_txn_codes_base m97
                           ON t02.t02_txn_code = m97.m97_code
                       LEFT JOIN m20_symbol m20
                           ON t02.t02_symbol_id_m20 = m20.m20_id
                 WHERE     t02.t02_update_type IN (2, 6)
                       AND t02.t02_create_date BETWEEN TRUNC (
                                                             p_d1
                                                           - CASE
                                                                 WHEN ptype =
                                                                          2 --1 - by Settlement Date | 2 - by Transaction Date
                                                                 THEN
                                                                     0
                                                                 ELSE
                                                                     fn_get_max_txn_stl_date_diff
                                                             END)
                                                   AND TRUNC (p_d2) + 0.99999
                       AND t02.t02_cash_settle_date BETWEEN TRUNC (p_d1)
                                                        AND   TRUNC (
                                                                    p_d2
                                                                  + CASE
                                                                        WHEN ptype =
                                                                                 2 --1 - by Settlement Date | 2 - by Transaction Date
                                                                        THEN
                                                                            fn_get_max_txn_stl_date_diff
                                                                        ELSE
                                                                            0
                                                                    END)
                                                            + 0.99999) t02,
               m01_exchanges m01
         WHERE     t02.t02_cash_acnt_id_u06 = p_cash_account_id
               AND t02.exchange_id = m01.m01_id(+)
               AND t02_txn_code NOT IN ('REVBTD', 'REVSTD', 'REVADJ', 'FTB')
        --  AND (   (    t02_txn_code IN ('STLBUY', 'STLSEL')
        --           AND m01.m01_is_local = 1) -- TODO  Need to discuss about t02_stl_approved_status
        --      OR t02.t02_txn_code NOT IN ('STLBUY', 'STLSEL'))
        ORDER BY settlement_date, timestamp;
END;
/
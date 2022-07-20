CREATE OR REPLACE PROCEDURE dfn_ntp.sp_cma_monthly_disclosures_rpt (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    pcurrency             VARCHAR2 DEFAULT 'SAR',
    plocalcurrency        VARCHAR2 DEFAULT 'SAR',
    pinstid               NUMBER DEFAULT 1)
IS
    l_date                  DATE;
    l_local_ytd_trade_val   NUMBER (25, 8);
    l_intl_ytd_trade_val    NUMBER (25, 8);
    l_local_cash_held       NUMBER (25, 8);
    l_intl_cash_held        NUMBER (25, 8);
BEGIN
    IF pfromdate > TRUNC (SYSDATE)
    THEN
        l_date := TRUNC (SYSDATE);
    ELSE
        l_date := TRUNC (pfromdate);
    END IF;


    SELECT SUM (
               CASE
                   WHEN m01.m01_is_local = 1
                   THEN
                       ABS (t02_amnt_in_txn_currency)
                   ELSE
                       0
               END),
           SUM (
               CASE
                   WHEN m01.m01_is_local = 0
                   THEN
                       ABS (t02_amnt_in_txn_currency)
                   ELSE
                       0
               END)
      INTO l_local_ytd_trade_val, l_intl_ytd_trade_val
      FROM     (SELECT *
                  FROM t02_transaction_log_order_all
                 WHERE     t02_create_date = l_date
                       AND t02_txn_currency = pcurrency) t02
           JOIN
               m01_exchanges m01
           ON m01.m01_id = t02.t02_exchange_id_m01
     WHERE m01.m01_institute_id_m02 = pinstid;


    SELECT SUM (CASE
                    WHEN cash.u06_currency_code_m03 = plocalcurrency
                    THEN
                          ABS (cash.cash_balance)
                        * get_exchange_rate (pinstid,
                                             u06_currency_code_m03,
                                             pcurrency,
                                             'R',
                                             l_date)
                    ELSE
                        0
                END),
           SUM (CASE
                    WHEN cash.u06_currency_code_m03 <> plocalcurrency
                    THEN
                          ABS (cash.cash_balance)
                        * get_exchange_rate (pinstid,
                                             u06_currency_code_m03,
                                             pcurrency,
                                             'R',
                                             l_date)
                    ELSE
                        0
                END)
      INTO l_local_cash_held, l_intl_cash_held
      FROM (SELECT u06_id,
                   u06.u06_currency_code_m03,
                   (  u06.u06_balance
                    + u06.u06_payable_blocked
                    - u06.u06_net_receivable)
                       AS cash_balance
              FROM u06_cash_account u06
             WHERE     u06_institute_id_m02 = pinstid
                   AND TRUNC (SYSDATE) = l_date
            UNION
            SELECT h02_cash_account_id_u06 AS u06_id,
                   h02.h02_currency_code_m03 AS u06_currency_code_m03,
                   (  h02.h02_balance
                    + h02.h02_payable_blocked
                    - h02.h02_net_receivable)
                       AS cash_balance
              FROM     vw_h02_cash_account_summary h02
                   JOIN
                       u06_cash_account u06
                   ON h02.h02_cash_account_id_u06 = u06.u06_id
             WHERE     u06_institute_id_m02 = pinstid
                   AND h02_date BETWEEN l_date AND l_date + 0.99999) cash;


    OPEN p_view FOR
        SELECT local_trad_acc_count,
               intl_trad_acc_count,
               local_trad_acc_count + intl_trad_acc_count AS trad_acc_count,
               local_trad_acc_count_with_stk,
               intl_trad_acc_count_with_stk,
               local_trad_acc_count_with_stk + intl_trad_acc_count_with_stk
                   AS trad_acc_count_with_stk,
               TRIM (
                   TO_CHAR (NVL (local_ytd_trade_val, 0),
                            '999,999,999,999,999,999,990.00'))
                   AS local_ytd_trade_val,
               TRIM (
                   TO_CHAR (NVL (intl_ytd_trade_val, 0),
                            '999,999,999,999,999,999,990.00'))
                   AS intl_ytd_trade_val,
               TRIM (
                   TO_CHAR (
                       NVL (local_ytd_trade_val + intl_ytd_trade_val, 0),
                       '999,999,999,999,999,999,990.00'))
                   AS ytd_trade_val,
               TRIM (
                   TO_CHAR (NVL (local_portfolio_value, 0),
                            '999,999,999,999,999,999,990.00'))
                   AS local_portfolio_value,
               TRIM (
                   TO_CHAR (NVL (intl_portfolio_value, 0),
                            '999,999,999,999,999,999,990.00'))
                   AS intl_portfolio_value,
               TRIM (
                   TO_CHAR (
                       NVL (local_portfolio_value + intl_portfolio_value, 0),
                       '999,999,999,999,999,999,990.00'))
                   AS portfolio_value,
               TRIM (
                   TO_CHAR (NVL (local_bond_portfolio_value, 0),
                            '999,999,999,999,999,999,990.00'))
                   local_bond_portfolio_value,
               TRIM (
                   TO_CHAR (NVL (intl_bond_portfolio_value, 0),
                            '999,999,999,999,999,999,990.00'))
                   intl_bond_portfolio_value,
               TRIM (
                   TO_CHAR (
                       NVL (
                             local_bond_portfolio_value
                           + intl_bond_portfolio_value,
                           0),
                       '999,999,999,999,999,999,990.00'))
                   AS bond_portfolio_value,
               TRIM (
                   TO_CHAR (NVL (local_cash_held, 0),
                            '999,999,999,999,999,999,990.00'))
                   local_cash_held,
               TRIM (
                   TO_CHAR (NVL (intl_cash_held, 0),
                            '999,999,999,999,999,999,990.00'))
                   intl_cash_held,
               TRIM (
                   TO_CHAR (NVL (local_cash_held + intl_cash_held, 0),
                            '999,999,999,999,999,999,990.00'))
                   AS cash_held,
               TRIM (
                   TO_CHAR (
                       NVL (
                             local_portfolio_value
                           + local_bond_portfolio_value
                           + local_cash_held,
                           0),
                       '999,999,999,999,999,999,990.00'))
                   AS local_assets,
               TRIM (
                   TO_CHAR (
                       NVL (
                             intl_portfolio_value
                           + intl_bond_portfolio_value
                           + intl_cash_held,
                           0),
                       '999,999,999,999,999,999,990.00'))
                   AS intl_assets
          FROM (  SELECT   COUNT (
                               DISTINCT (CASE
                                             WHEN     m01.m01_is_local = 1
                                                  AND u06.u06_currency_code_m03 =
                                                          plocalcurrency
                                             THEN
                                                 u07_id
                                             ELSE
                                                 0
                                         END))
                         - 1
                             AS local_trad_acc_count,
                           COUNT (
                               DISTINCT (CASE
                                             WHEN     m01.m01_is_local = 0
                                                  AND u06.u06_currency_code_m03 <>
                                                          plocalcurrency
                                             THEN
                                                 u07_id
                                             ELSE
                                                 0
                                         END))
                         - 1
                             AS intl_trad_acc_count,
                           COUNT (
                               DISTINCT (CASE
                                             WHEN     m01.m01_is_local = 1
                                                  AND u06.u06_currency_code_m03 =
                                                          plocalcurrency
                                             THEN
                                                 h01_trading_acnt_id_u07
                                             ELSE
                                                 0
                                         END))
                         - 1
                             AS local_trad_acc_count_with_stk,
                           COUNT (
                               DISTINCT (CASE
                                             WHEN     m01.m01_is_local = 0
                                                  AND u06.u06_currency_code_m03 <>
                                                          plocalcurrency
                                             THEN
                                                 h01_trading_acnt_id_u07
                                             ELSE
                                                 0
                                         END))
                         - 1
                             AS intl_trad_acc_count_with_stk,
                         l_local_ytd_trade_val AS local_ytd_trade_val,
                         l_intl_ytd_trade_val AS intl_ytd_trade_val,
                         l_local_cash_held AS local_cash_held,
                         l_intl_cash_held AS intl_cash_held,
                         SUM (
                             CASE
                                 WHEN     m20.m20_instrument_type_code_v09 IN
                                              ('CS', 'REIT', 'ETF', 'RHT')
                                      AND m01.m01_is_local = 1
                                 THEN
                                     NVL (
                                           (  h01.h01_net_holding
                                            + h01.h01_payable_holding
                                            - h01.h01_receivable_holding)
                                         * (CASE
                                                WHEN TRUNC (SYSDATE) = l_date
                                                THEN
                                                    m20_lasttradeprice
                                                ELSE
                                                    h01.h01_todays_closed
                                            END)
                                         * m20.m20_lot_size
                                         * m20.m20_price_ratio
                                         * get_exchange_rate (
                                               pinstid,
                                               h01.h01_currency_code_m03,
                                               pcurrency,
                                               'R',
                                               l_date),
                                         0)
                                 ELSE
                                     0
                             END)
                             AS local_portfolio_value,
                         SUM (
                             CASE
                                 WHEN     m20.m20_instrument_type_code_v09 =
                                              'BN'
                                      AND m01.m01_is_local = 1
                                 THEN
                                     NVL (
                                           (  h01.h01_net_holding
                                            + h01.h01_payable_holding
                                            - h01.h01_receivable_holding)
                                         * (CASE
                                                WHEN TRUNC (SYSDATE) = l_date
                                                THEN
                                                    m20_lasttradeprice
                                                ELSE
                                                    h01.h01_todays_closed
                                            END)
                                         * m20.m20_lot_size
                                         * m20.m20_price_ratio
                                         * get_exchange_rate (
                                               pinstid,
                                               h01.h01_currency_code_m03,
                                               pcurrency,
                                               'R',
                                               l_date),
                                         0)
                                 ELSE
                                     0
                             END)
                             AS local_bond_portfolio_value,
                         SUM (
                             CASE
                                 WHEN     m20.m20_instrument_type_code_v09 IN
                                              ('CS', 'REIT', 'ETF', 'RHT')
                                      AND m01.m01_is_local = 0
                                 THEN
                                     NVL (
                                           (  h01.h01_net_holding
                                            + h01.h01_payable_holding
                                            - h01.h01_receivable_holding)
                                         * (CASE
                                                WHEN TRUNC (SYSDATE) = l_date
                                                THEN
                                                    m20_lasttradeprice
                                                ELSE
                                                    h01.h01_todays_closed
                                            END)
                                         * m20.m20_lot_size
                                         * m20.m20_price_ratio
                                         * get_exchange_rate (
                                               pinstid,
                                               h01.h01_currency_code_m03,
                                               pcurrency,
                                               'R',
                                               l_date),
                                         0)
                                 ELSE
                                     0
                             END)
                             AS intl_portfolio_value,
                         SUM (
                             CASE
                                 WHEN     m20.m20_instrument_type_code_v09 =
                                              'BN'
                                      AND m01.m01_is_local = 0
                                 THEN
                                     NVL (
                                           (  h01.h01_net_holding
                                            + h01.h01_payable_holding
                                            - h01.h01_receivable_holding)
                                         * (CASE
                                                WHEN TRUNC (SYSDATE) = l_date
                                                THEN
                                                    m20_lasttradeprice
                                                ELSE
                                                    h01.h01_todays_closed
                                            END)
                                         * m20.m20_lot_size
                                         * m20.m20_price_ratio
                                         * get_exchange_rate (
                                               pinstid,
                                               h01.h01_currency_code_m03,
                                               pcurrency,
                                               'R',
                                               l_date),
                                         0)
                                 ELSE
                                     0
                             END)
                             AS intl_bond_portfolio_value
                    FROM u07_trading_account u07
                         LEFT JOIN (SELECT h01_net_holding,
                                           h01_payable_holding,
                                           h01_receivable_holding,
                                           h01_todays_closed,
                                           h01_trading_acnt_id_u07,
                                           h01_symbol_id_m20,
                                           h01_currency_code_m03
                                      FROM vw_h01_holding_summary
                                     WHERE h01_date = l_date
                                    UNION ALL
                                    SELECT u24_net_holding AS h01_net_holding,
                                           u24_payable_holding
                                               AS h01_payable_holding,
                                           u24_receivable_holding
                                               AS h01_receivable_holding,
                                           0 AS h01_todays_closed,
                                           u24_trading_acnt_id_u07
                                               AS h01_trading_acnt_id_u07,
                                           u24_symbol_id_m20
                                               AS h01_symbol_id_m20,
                                           u24_currency_code_m03
                                               AS h01_currency_code_m03
                                      FROM u24_holdings
                                     WHERE TRUNC (SYSDATE) = l_date) h01
                             ON u07.u07_id = h01.h01_trading_acnt_id_u07
                         JOIN u06_cash_account u06
                             ON u07.u07_cash_account_id_u06 = u06.u06_id
                         LEFT JOIN m20_symbol m20
                             ON h01.h01_symbol_id_m20 = m20.m20_id
                         JOIN m01_exchanges m01
                             ON u07.u07_exchange_id_m01 = m01.m01_id
                   WHERE     u07.u07_institute_id_m02 = pinstid
                         AND u07.u07_created_date <= l_date + 0.99999
                GROUP BY u07.u07_institute_id_m02);
END;
/
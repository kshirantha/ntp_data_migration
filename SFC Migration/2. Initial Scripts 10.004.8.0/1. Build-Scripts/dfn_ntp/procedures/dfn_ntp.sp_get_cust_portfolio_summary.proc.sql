CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_cust_portfolio_summary (
    p_view           OUT SYS_REFCURSOR,
    prows            OUT NUMBER,
    pcustomerid   IN     NUMBER,
    pcurrency     IN     VARCHAR2)
IS
    status   NUMBER;
BEGIN
    status := 0;

    OPEN p_view FOR
        SELECT b.*,
               (b.VALUE * NVL (m04.m04_rate, 1)) AS display_value,
               pcurrency AS display_currency
          FROM (SELECT 'Holdings Summary' AS section,
                       TO_CHAR (
                              u24.u24_symbol_code_m20
                           || '-'
                           || u24.short_description
                           || ' ('
                           || u24.u07_display_name
                           || ')')
                           AS description,
                       TO_CHAR (
                              u24.u24_symbol_code_m20
                           || '-'
                           || u24.short_description_lang
                           || ' ('
                           || u24.u07_display_name
                           || ')')
                           AS description_lang,
                       u24.currency,
                       NVL (
                             u24.last_trade_price
                           * u24.tot_holdings_with_unsettles,
                           0)
                           AS VALUE,
                       u24.last_trade_price AS last_price,
                       u24.avg_cost,
                       u24.tot_holdings_with_unsettles AS quantity,
                       u24.profit AS gain_loss
                  FROM vw_u24_holdings_all u24
                 WHERE     u24_trading_acnt_id_u07 IN
                               (SELECT u07_id
                                  FROM u07_trading_account
                                 WHERE u07_customer_id_u01 = pcustomerid)
                       AND u24.tot_holdings_with_unsettles > 0
                UNION
                SELECT 'Cash Accounts Summary' AS section,
                       u06.u06_display_name AS description,
                       u06.u06_display_name AS description_lang,
                       u06.u06_currency_code_m03 AS currency,
                       (  u06.u06_balance
                        + u06.u06_payable_blocked
                        - u06.u06_receivable_amount)
                           AS VALUE,
                       NULL AS last_price,
                       NULL AS avg_cost,
                       NULL AS quantity,
                       NULL AS gain_loss
                  FROM vw_u06_cash_account_base u06
                 WHERE u06_customer_id_u01 = pcustomerid) b,
               (SELECT *
                  FROM m04_currency_rate
                 WHERE m04_to_currency_code_m03 = pcurrency) m04
         WHERE b.currency = m04.m04_from_currency_code_m03(+);
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        status := -2;
    WHEN OTHERS
    THEN
        status := -3;
END;
/
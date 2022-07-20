CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_customer_grades
IS
    l_portfolio_value    NUMBER (30, 10);
    l_cust_grade_count   NUMBER (30, 10);
    l_grade              CHAR;
BEGIN
    UPDATE u01_customer
       SET u01_grade = NULL;

    FOR i
        IN (  SELECT u07.u07_customer_id_u01,
                     ROUND (
                         NVL (
                             SUM (
                                   (  u24.u24_net_holding
                                    + u24.u24_payable_holding
                                    - u24.u24_receivable_holding
                                    - u24.u24_manual_block)
                                 * price.market_price
                                 * NVL (currency.rate, 1)
                                 * m20.m20_lot_size
                                 * m20.m20_price_ratio),
                             0),
                         8)
                         AS total_portfolio
                FROM u24_holdings u24,
                     u07_trading_account u07,
                     vw_symbol_prices price,
                     m20_symbol m20,
                     (SELECT m04.m04_from_currency_id_m03 AS from_currency_id,
                             m04.m04_to_currency_id_m03 AS to_currency_id,
                             m04.m04_rate AS rate,
                             m04.m04_institute_id_m02 AS m02_id
                        FROM m04_currency_rate m04, m02_institute m02
                       WHERE     m04.m04_institute_id_m02 = m02.m02_id
                             AND m04.m04_to_currency_id_m03 =
                                     m02.m02_display_currency_id_m03
                      UNION ALL
                      SELECT m03.m03_id AS from_currency_id,
                             m03.m03_id AS to_currency_id,
                             1 AS rate,
                             m02.m02_id
                        FROM m03_currency m03, m02_institute m02
                       WHERE m03.m03_id = m02.m02_display_currency_id_m03) currency
               WHERE     u24.u24_trading_acnt_id_u07 = u07.u07_id
                     AND u24.u24_exchange_code_m01 = u07.u07_exchange_code_m01
                     AND u24.u24_symbol_id_m20 = m20.m20_id
                     AND m20.m20_id = price.symbol_id
                     AND u07.u07_institute_id_m02 = currency.m02_id
                     AND m20.m20_currency_id_m03 = currency.from_currency_id
            GROUP BY u07.u07_customer_id_u01)
    LOOP
        BEGIN
            SELECT NVL (COUNT (*), 0)
              INTO l_cust_grade_count
              FROM m28_customer_grade_data m28
             WHERE NVL (i.total_portfolio, 0) BETWEEN m28_from_value
                                                  AND m28_to_value;

            IF (l_cust_grade_count > 0)
            THEN
                SELECT m28_grade_label
                  INTO l_grade
                  FROM m28_customer_grade_data
                 WHERE     NVL (i.total_portfolio, 0) BETWEEN m28_from_value
                                                          AND m28_to_value
                       AND ROWNUM = 1;

                UPDATE u01_customer u01
                   SET u01.u01_grade = l_grade
                 WHERE u01.u01_id = i.u07_customer_id_u01;
            END IF;
        END;
    END LOOP;
END;
/
/

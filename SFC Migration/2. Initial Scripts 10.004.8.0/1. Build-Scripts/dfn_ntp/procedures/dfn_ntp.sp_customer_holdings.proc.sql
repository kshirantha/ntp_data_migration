/* Formatted on 03-May-2019 15:31:11 (QP5 v5.276) */
CREATE OR REPLACE PROCEDURE dfn_ntp.sp_customer_holdings (
    p_view                   OUT SYS_REFCURSOR,
    prows                    OUT NUMBER,
    pu24_trading_ac_id_u07       NUMBER,
    pu24_exchange                VARCHAR2,
    pfrom_date                   DATE,
    pto_date                     DATE,
    pu01_created_by_id_u17       NUMBER DEFAULT 0)
IS
    ptemp_date   DATE;
BEGIN
    ptemp_date := pto_date;

    IF TRUNC (ptemp_date) > TRUNC (SYSDATE)
    THEN
        ptemp_date := SYSDATE;
    END IF;

    /*IF TRUNC (ptemp_date) LIKE TRUNC (SYSDATE)  -- uncomment when archive data is implemented
    THEN*/
    OPEN p_view FOR
        SELECT u01.u01_customer_no,
               u01.u01_id,
               u01.u01_institute_id_m02,
               u01.u01_full_name,
               u24.u24_trading_acnt_id_u07,
               u07.u07_display_name,
               u24.u24_symbol_code_m20,
               u24.u24_exchange_code_m01,
               (u24.tot_holdings_with_unsettles - u24.u24_manual_block)
                   AS net_holdings,
               0 AS prefered_cost_method,
               u24.avg_cost,
               u24.u24_sell_pending,
               u24.u24_pledge_qty,
               u24.u24_buy_pending,
               NVL (m20.m20_short_description, m20_symbol_code)
                   AS symbolshortdescription_1,
               NVL (m20.m20_long_description, m20_symbol_code)
                   AS symbollongdescription_1,
               m20.m20_long_description AS long_description,
               '' AS open_sell_cont,
               '' AS open_buy_cont,
               m20.m20_expire_date AS expiry_date,
               u24.avg_price,
               '' AS margin_due,
               '' AS net_day_holdings,
               u24.availableqty,
               u06.u06_currency_code_m03 AS currancy,
               u24.total_cost,
               u24.last_trade_price,
               u24.previous_closed,
               u24.market_value,
               u24.profit,
               '' AS day_margin_due,
               '' AS margin_holdings,
               '' AS daymargin_holdings,
               u24.market_price,
               u24.profitpercentage,
               u07.u07_exchange_account_no,
               u01.u01_account_category_id_v01,
               m20.m20_instrument_type_code_v09,
               CASE
                   WHEN m20.m20_instrument_type_code_v09 = 'BN' THEN 1
                   ELSE 0
               END
                   AS is_fixed_income,
               '' AS pending_subcribed_qty,
               u24.u24_payable_holding,
               u24.u24_receivable_holding,
               m20.m20_isincode
          FROM vw_u24_holdings_all u24
               INNER JOIN u07_trading_account u07
                   ON u24.u24_trading_acnt_id_u07 = u07.u07_id
               INNER JOIN u01_customer u01 ON u24.customer_id = u01.u01_id
               INNER JOIN m01_exchanges m01
                   ON     u24.u24_exchange_code_m01 = m01.m01_exchange_code
                      AND u24.u07_exchange_id_m01 = m01.m01_id
               INNER JOIN m20_symbol m20
                   ON u24.u24_symbol_id_m20 = m20.m20_id
               --      AND u24.u24_symbol_code_m20 = m20.m20_symbol_code
               --   AND u24.u24_exchange_code_m01 =
               --      m20.m20_exchange_code_m01
               INNER JOIN u06_cash_account u06
                   ON u07.u07_cash_account_id_u06 = u06.u06_id
         WHERE     u07.u07_id = pu24_trading_ac_id_u07
               AND (   ABS (u24.u24_net_holding) > 0
                    OR ABS (u24.u24_pledge_qty) > 0
                    OR ABS (u24.u24_sell_pending) > 0
                    OR ABS (u24.u24_payable_holding) > 0
                    OR ABS (u24.u24_receivable_holding) > 0
                    OR ABS (u24.u24_manual_block) > 0)
               AND u24.u24_exchange_code_m01 = pu24_exchange
        ORDER BY u24.u24_symbol_code_m20;
/*ELSE
    OPEN p_view FOR SELECT NULL FROM DUAL; -- archive data need to implement
END IF;*/
END;
/
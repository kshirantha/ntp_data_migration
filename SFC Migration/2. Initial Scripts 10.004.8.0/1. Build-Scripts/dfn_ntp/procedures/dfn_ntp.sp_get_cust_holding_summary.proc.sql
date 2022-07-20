CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_cust_holding_summary (
    p_view                     OUT SYS_REFCURSOR,
    prows                      OUT NUMBER,
    pcustomerid             IN     NUMBER,
    pcurrency               IN     VARCHAR2,
    puserid                        NUMBER DEFAULT NULL,
    p_user_filter_enabled          NUMBER DEFAULT 0)
IS
    status      NUMBER;
    l_qry       VARCHAR2 (15000);
    userfiler   NUMBER := NULL;
BEGIN
    status := 0;

    IF puserid IS NOT NULL AND p_user_filter_enabled <> 0
    THEN
        userfiler := 1;
    END IF;

    l_qry :=
           'SELECT u24.u07_display_name,
               m26.m26_name,
               u24.u24_symbol_code_m20,
               u24.currency,
               u24.short_description,
               u24.short_description_lang,
               u24.avg_cost,
               u24.tot_holdings_with_unsettles AS quantity,
               u24.last_trade_price,
               u24.profit,
               CASE
                   WHEN m20_instrument_type_code_v09 = ''FUT''
                   THEN
                         u24_maintain_margin_charged
                       + NVL (u24.settlement_price * u24.tot_holdings_with_unsettles,
                              0)
                   ELSE
                       NVL (u24.last_trade_price * u24.tot_holdings_with_unsettles,
                            0)
               END
                   AS VALUE,
               CASE
                   WHEN m20_instrument_type_code_v09 = ''FUT''
                   THEN
                         (  u24_maintain_margin_charged
                          + NVL (
                                  u24.settlement_price
                                * u24.tot_holdings_with_unsettles,
                                0))
                       * NVL (m04.m04_rate, 1)
                   ELSE
                       NVL (
                             u24.last_trade_price
                           * u24.tot_holdings_with_unsettles
                           * NVL (m04.m04_rate, 1),
                           0)
               END
                   AS value_cur
          FROM vw_u24_holdings_all u24
               LEFT JOIN (SELECT *
                            FROM m04_currency_rate
                           WHERE m04_to_currency_code_m03 = '''
        || pcurrency
        || ''') m04
                   ON u24.currency = m04.m04_from_currency_code_m03
               LEFT JOIN m26_executing_broker m26
                   ON u24.u07_custodian_id_m26 = m26.m26_id
               JOIN u07_trading_account u07
                   ON u24.u24_trading_acnt_id_u07 = u07.u07_id'
        || fn_get_trading_acc_filter (
               ptrading_column         => 'u07_id',
               ptab_alies              => 'u07',
               puser_id                => puserid,
               p_user_filter_enabled   => p_user_filter_enabled)
        || ' WHERE u24.tot_holdings_with_unsettles > 0 AND u07.u07_customer_id_u01 = '
        || pcustomerid;

    OPEN p_view FOR l_qry;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        status := -2;
    WHEN OTHERS
    THEN
        status := -3;
END;
/
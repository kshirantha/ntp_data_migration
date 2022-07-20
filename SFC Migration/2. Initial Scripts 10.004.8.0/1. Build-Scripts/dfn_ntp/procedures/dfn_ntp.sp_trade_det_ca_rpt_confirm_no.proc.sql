CREATE OR REPLACE PROCEDURE dfn_ntp.sp_trade_det_ca_rpt_confirm_no(p_view   OUT SYS_REFCURSOR,
                                                                   prows    OUT NUMBER,
                                                                   p_t64_id NUMBER) IS
BEGIN
  OPEN p_view FOR
    SELECT t02.t02_order_no AS trade_number,
           u07.u07_display_name_u06 AS customer_ca_number,
           t02.t02_trade_confirm_no AS confirmation_number,
           t02.t02_exchange_code_m01 AS security,
           t02.t02_symbol_code_m20 AS symbol,
           u07.u07_display_name AS trading_account,
           t02.t02_ordqty AS qty,
           t02.t02_avgprice AS transactional_avg_prices,
           t02.t02_ordqty * t02.t02_avgprice AS transactional_amount,
           t02.t02_broker_commission AS transactional_commision,
           t02.t02_exg_commission AS transactional_levies,
           (t02.t02_ordqty * t02.t02_avgprice) + t02.t02_broker_commission +
           t02.t02_exg_commission AS transactional_net_amount,
           t02.t02_fx_rate AS settlement_fix_rate,
           t02.t02_fx_rate * t02.t02_avgprice AS settlement_price,
           t02.t02_fx_rate * (t02.t02_ordqty * t02.t02_avgprice) AS settlement_amount,
           t02.t02_fx_rate * t02.t02_broker_commission AS settlement_commision,
           t02.t02_fx_rate * t02.t02_exg_commission AS settlement_levies,
           t02.t02_fx_rate *
           ((t02.t02_ordqty * t02.t02_avgprice) + t02.t02_exg_commission +
           t02.t02_broker_commission) AS settlement_net_amount,
           t02.t02_txn_currency AS currency,
           u01.u01_display_name AS customer_name,
           m05.m05_name AS customer_country,
           m06.m06_name AS customer_city,
           u02.u02_mobile AS customer_mobile,
           nvl(u02.u02_telephone, ' ') AS customer_telephone,
           to_char(t02.t02_create_date, 'YYYY-MM-DD') AS trade_date
      FROM t02_transaction_log_order_all t02
      LEFT JOIN u07_trading_account u07
        ON u07.u07_id = t02.t02_trd_acnt_id_u07
      LEFT JOIN u01_customer u01
        ON u01.u01_id = t02.t02_customer_id_u01
      LEFT JOIN u02_customer_contact_info u02
        ON (u02.u02_customer_id_u01 = u01.u01_id AND u02.u02_is_default = 1)
      LEFT JOIN m05_country m05
        ON m05.m05_id = u02.u02_country_id_m05
      LEFT JOIN m06_city m06
        ON m06.m06_id = u02.u02_city_id_m06
      LEFT JOIN t64_trade_confirmation_list t64
        ON t64.t64_trade_confirm_no = t02.t02_trade_confirm_no
     WHERE t64.t64_id = p_t64_id;
END;
/
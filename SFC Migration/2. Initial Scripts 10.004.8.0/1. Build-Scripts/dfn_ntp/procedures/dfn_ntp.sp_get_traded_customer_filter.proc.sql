CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_traded_customer_filter(p_view      OUT SYS_REFCURSOR,
                                                                  prows       OUT NUMBER,
                                                                  p_from_date Date,
                                                                  p_end_date  Date,
                                                                  p_institute NUMBER,
                                                                  p_exchange  VARCHAR2 DEFAULT NULL,
                                                                  p_type      NUMBER DEFAULT NULL) IS
  v_Sql CLob;
BEGIN


    v_Sql := 'SELECT m08.m08_id,
           max(m08.m08_name) m08_name,
           m07.m07_id,
           max(m07.m07_name) m07_name,
           u01.u01_account_category_id_v01,
           CASE
             WHEN u01.u01_account_category_id_v01 = 1 THEN
              ''Individual''
             WHEN u01.u01_account_category_id_v01 = 2 THEN
              ''Corporate''
           END AS u01_account_category_v01,
           t02.t02_symbol_id_m20,
           max(m20.m20_short_description) m20_short_description,
           m95.m95_id,
           max(m95.m95_settlement_name) m95_settlement_name,
           t02.t02_cash_settle_date,
           t02.t02_holding_settle_date
      FROM (select t02_customer_id_u01,
                   t02_trd_acnt_id_u07,
                   t02_exchange_code_m01,
                   t02_settle_cal_conf_id_m95,
                   t02_symbol_id_m20,
                   t02_inst_id_m02,
                   t02_cash_settle_date,
                   t02_holding_settle_date
              from t02_transaction_log_order_all t02
             where (t02.t02_create_date between :p_from_date and
                   (:p_end_date + .99999))';
                   
          IF p_type = 1 THEN -- Generation
               v_Sql := v_Sql || ' AND t02.T02_TRADE_CONFIRM_NO IS NULL';
          END IF;
          
          IF p_type = 2 THEN -- Rollback
            v_Sql := v_Sql || ' AND t02.T02_TRADE_CONFIRM_NO IS NOT NULL';
          END IF;
            v_Sql := v_Sql || ' group by t02_customer_id_u01,
                      t02_trd_acnt_id_u07,
                      t02_exchange_code_m01,
                      t02_settle_cal_conf_id_m95,
                      t02_symbol_id_m20,
                      t02_cash_settle_date,
                      t02_holding_settle_date,
                      t02_inst_id_m02) t02
      LEFT JOIN u01_customer u01
        ON t02.t02_customer_id_u01 = u01.u01_id
      LEFT JOIN u07_trading_account u07
        ON t02.t02_trd_acnt_id_u07 = u07.u07_id
      LEFT JOIN m07_location m07
        ON u01.u01_signup_location_id_m07 = m07.m07_id
      LEFT JOIN m08_trading_group m08
        ON u07.u07_trading_group_id_m08 = m08.m08_id
      LEFT JOIN m95_settlement_calendar_config m95
        ON t02.t02_settle_cal_conf_id_m95 = m95_id
      LEFT JOIN m20_symbol m20
        ON t02.t02_symbol_id_m20 = m20.m20_id
     where t02.t02_inst_id_m02 = :p_institute
       AND t02.t02_exchange_code_m01 = :p_exchange
     group by m08.m08_id,
              m07.m07_id,
              u01.u01_account_category_id_v01,
              t02.t02_symbol_id_m20,
              m95.m95_id,
              t02.t02_cash_settle_date,
              t02.t02_holding_settle_date';
              
       Open p_view For v_Sql using p_from_date, p_end_date, p_institute, p_exchange;
END;
/
CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_traded_customers(p_view                 OUT SYS_REFCURSOR,
                                                            prows                  OUT NUMBER,
                                                            p_from_date            Date,
                                                            p_end_date             Date,
                                                            p_institute            NUMBER,
                                                            p_exchange             VARCHAR2,
                                                            p_settlement           VARCHAR2,
                                                            p_cash_settle_dates    VARCHAR2,
                                                            p_holding_settle_dates VARCHAR2,
                                                            p_customer_type        VARCHAR2,
                                                            p_branches             VARCHAR2,
                                                            p_customer_groups      VARCHAR2,
                                                            p_symbol               VARCHAR2,
                                                            p_type                 NUMBER,
                                                            p_row_num_from         NUMBER,
                                                            p_row_num_end         NUMBER) IS
  v_Sql      CLob;
  v_SqlCount Clob;
  l_rowCount Number;
BEGIN

  v_Sql := ' FROM (select t02_customer_id_u01,
                     t02_trd_acnt_id_u07,
                     MAX(t02_customer_id_u01) AS customer_id_u01
                from t02_transaction_log_order_all t02
                INNER JOIN (select trim(regexp_substr(''' ||
           p_settlement || ''', ''[^,]+'', 1, level)) m95Id
                     from dual
                   connect by regexp_substr(''' || p_settlement ||
           ''', ''[^,]+'', 1, level) is not null) m95
          ON t02.t02_settle_cal_conf_id_m95 = m95.m95Id
          INNER JOIN (select to_date(trim(regexp_substr(''' ||
           p_cash_settle_dates || ''',
                                                     ''[^,]+'',
                                                     1,
                                                     level))) cashSettleDate
                     from dual
                   connect by regexp_substr(''' ||
           p_cash_settle_dates || ''',
                                            ''[^,]+'',
                                            1,
                                            level) is not null) cashSettleDates
          ON t02.t02_cash_settle_date = cashSettleDates.cashSettleDate
          INNER JOIN (select to_date(trim(regexp_substr(''' ||
           p_holding_settle_dates || ''',
                                                     ''[^,]+'',
                                                     1,
                                                     level))) holdingSettleDate
                     from dual
                   connect by regexp_substr(''' ||
           p_holding_settle_dates || ''',
                                            ''[^,]+'',
                                            1,
                                            level) is not null) holdingSettleDates
          ON t02.t02_holding_settle_date =
             holdingSettleDates.holdingSettleDate
             INNER JOIN (select trim(regexp_substr(''' ||
           p_symbol || ''', ''[^,]+'', 1, level)) m20Id
                     from dual
                   connect by regexp_substr(''' || p_symbol ||
           ''', ''[^,]+'', 1, level) is not null) m20
          ON t02.t02_symbol_id_m20 = m20.m20Id
               where (t02.t02_create_date between :p_from_date and
                     (:p_end_date + .99999))
                 AND  t02.t02_inst_id_m02 = :p_institute
         AND t02.t02_exchange_code_m01 = :p_exchange';

         IF p_type = 1 THEN -- Generation
               v_Sql := v_Sql || ' AND t02.T02_TRADE_CONFIRM_NO IS NULL';
          END IF;
          
          IF p_type = 2 THEN -- Rollback
            v_Sql := v_Sql || ' AND t02.T02_TRADE_CONFIRM_NO IS NOT NULL';
          END IF;
          
            v_Sql := v_Sql || ' group by t02_customer_id_u01,
                        t02_trd_acnt_id_u07) t02
       INNER JOIN u01_customer u01
          ON t02.t02_customer_id_u01 = u01.u01_id
       INNER JOIN u07_trading_account u07
          ON t02.t02_trd_acnt_id_u07 = u07.u07_id
        INNER JOIN (select trim(regexp_substr(''' || p_branches ||
           ''' , ''[^,]+'', 1, level)) m07Id
                     from dual
                   connect by regexp_substr(''' || p_branches ||
           ''' , ''[^,]+'', 1, level) is not null) m07
          ON u01.u01_signup_location_id_m07 = m07.m07Id
        INNER JOIN (select trim(regexp_substr(''' ||
           p_customer_groups ||
           '''  ,
                                             ''[^,]+'',
                                             1,
                                             level)) m08Id
                     from dual
                   connect by regexp_substr(''' ||
           p_customer_groups || ''',
                                            ''[^,]+'',
                                            1,
                                            level) is not null) m08
          ON u07.u07_trading_group_id_m08 = m08.m08Id
        
        
        
        
        INNER JOIN (select trim(regexp_substr(''' ||
           p_customer_type || ''',
                                             ''[^,]+'',
                                             1,
                                             level)) pAccTypeId
                     from dual
                   connect by regexp_substr(''' ||
           p_customer_type || ''',
                                            ''[^,]+'',
                                            1,
                                            level) is not null) accountTypeIds
          ON u01.u01_account_category_id_v01 = accountTypeIds.pAccTypeId';

  v_SqlCount := 'SELECT COUNT(*) totalRecords ' || v_Sql || '';
  Execute immediate v_SqlCount
    into l_rowCount
    Using p_from_date, p_end_date, p_institute, p_exchange;

  Open p_view For
    ' SELECT total_records, rownumber, t02_customer_id_u01,u01_display_name, u01_customer_no, u07_id, u07_display_name FROM ( SELECT ' || l_rowCount || ' As total_records, row_number() over (order by u07.u07_id desc) AS rownumber ,
           t02.t02_customer_id_u01,
           u01.u01_display_name,
           u01.u01_customer_no,
           u07.u07_id,
           u07.u07_display_name ' || v_Sql || ') WHERE rownumber >= :p_row_num_from and rownumber <= :p_row_num_end' Using p_from_date, p_end_date, p_institute, p_exchange,p_row_num_from,p_row_num_end;

END;
/

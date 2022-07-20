CREATE OR REPLACE PROCEDURE dfn_ntp.sp_rollback_confirmation_no(p_from_date            DATE,
                                                                p_to_date              DATE,
                                                                p_exchange_id          NUMBER,
                                                                p_exchange_code        VARCHAR2,
                                                                p_institute            NUMBER,
                                                                p_trade_accounts       VARCHAR2,
                                                                p_settlement           VARCHAR2,
                                                                p_cash_settle_dates    VARCHAR2,
                                                                p_holding_settle_dates VARCHAR2,
                                                                p_customer_type        VARCHAR2,
                                                                p_branches             VARCHAR2,
                                                                p_customer_groups      VARCHAR2,
                                                                p_symbol               VARCHAR2,
                                                                p_created_by_u17_id    u17_employee.u17_id%TYPE
                                                                
                                                                ) IS
  l_t63_pkey  NUMBER;
  l_t64_count NUMBER;
  no_data_err EXCEPTION;
BEGIN

  SELECT t63_tc_request_list_seq.nextval INTO l_t63_pkey FROM dual;

  INSERT INTO t63_tc_request_list
    (t63_id,
     t63_from_date,
     t63_to_date,
     t63_institute_id_m02,
     t63_exchange_id_m01,
     t63_exchange_code_m01,
     t63_type,
     t63_created_by_id_u17,
     t63_created_date)
  VALUES
    (l_t63_pkey,
     p_from_date,
     p_to_date,
     p_institute,
     p_exchange_id,
     p_exchange_code,
     2,
     p_created_by_u17_id,
     SYSDATE);

  INSERT INTO t64_trade_confirmation_list
    (t64_id,
     t64_tc_request_id_t63,
     t64_trade_confirm_no,
     t64_type,
     t64_status_id_v01)
    SELECT t64_trade_confirmation_seq.nextval,
           l_t63_pkey,
           t02_trade_confirm_no,
           2,
           1
      FROM (SELECT t02.t02_trade_confirm_no
              FROM t02_transaction_log_order_all t02,
                   u01_customer u01,
                   u07_trading_account u07,
                   m151_trade_confirm_config m151,
                   (SELECT TRIM(regexp_substr(p_trade_accounts,
                                              '[^,]+',
                                              1,
                                              LEVEL)) pu07id
                      FROM dual
                    CONNECT BY regexp_substr(p_trade_accounts,
                                             '[^,]+',
                                             1,
                                             LEVEL) IS NOT NULL) tblu07ids,
                   (SELECT TRIM(regexp_substr(p_symbol, '[^,]+', 1, LEVEL)) pm20id
                      FROM dual
                    CONNECT BY regexp_substr(p_symbol, '[^,]+', 1, LEVEL) IS NOT NULL) symbolids,
                   (SELECT TRIM(regexp_substr(p_branches, '[^,]+', 1, LEVEL)) pm07id
                      FROM dual
                    CONNECT BY regexp_substr(p_branches, '[^,]+', 1, LEVEL) IS NOT NULL) m07ids,
                   (SELECT TRIM(regexp_substr(p_customer_groups,
                                              '[^,]+',
                                              1,
                                              LEVEL)) pm08id
                      FROM dual
                    CONNECT BY regexp_substr(p_customer_groups,
                                             '[^,]+',
                                             1,
                                             LEVEL) IS NOT NULL) m08ids,
                   (SELECT TRIM(regexp_substr(p_customer_type,
                                              '[^,]+',
                                              1,
                                              LEVEL)) pacctypeid
                      FROM dual
                    CONNECT BY regexp_substr(p_customer_type,
                                             '[^,]+',
                                             1,
                                             LEVEL) IS NOT NULL) accounttypeids,
                   (SELECT TRIM(regexp_substr(p_settlement, '[^,]+', 1, LEVEL)) pm95id
                      FROM dual
                    CONNECT BY regexp_substr(p_settlement, '[^,]+', 1, LEVEL) IS NOT NULL) settlementids,
                   
                   (SELECT to_date(TRIM(regexp_substr(p_cash_settle_dates,
                                                      '[^,]+',
                                                      1,
                                                      LEVEL))) cashsettledate
                      FROM dual
                    CONNECT BY regexp_substr(p_cash_settle_dates,
                                             '[^,]+',
                                             1,
                                             LEVEL) IS NOT NULL) cashsettledates,
                   
                   (SELECT to_date(TRIM(regexp_substr(p_holding_settle_dates,
                                                      '[^,]+',
                                                      1,
                                                      LEVEL))) holdingsettledate
                      FROM dual
                    CONNECT BY regexp_substr(p_holding_settle_dates,
                                             '[^,]+',
                                             1,
                                             LEVEL) IS NOT NULL) holdingsettledates
            
             WHERE t02.t02_customer_id_u01 = u01.u01_id
               AND t02.t02_trd_acnt_id_u07 = u07.u07_id
               AND u07.u07_trading_group_id_m08 = m08ids.pm08id
               AND u01.u01_signup_location_id_m07 = m07ids.pm07id
               AND u07_id = tblu07ids.pu07id
               AND t02_create_date BETWEEN p_from_date AND
                   (p_to_date + .99999)
               AND t02_settle_cal_conf_id_m95 = settlementids.pm95id
               AND t02.t02_cash_settle_date = cashsettledates.cashsettledate
               AND t02.t02_holding_settle_date =
                   holdingsettledates.holdingsettledate
               AND t02_symbol_id_m20 = symbolids.pm20id
               AND u01.u01_account_category_id_v01 =
                   accounttypeids.pacctypeid
                  
               AND t02.t02_trade_confirm_no IS NOT NULL
               AND t02.t02_inst_id_m02 = p_institute
               AND t02.t02_exchange_code_m01 = p_exchange_code
             GROUP BY t02_trade_confirm_no);

  SELECT COUNT(*)
    INTO l_t64_count
    FROM t64_trade_confirmation_list
   WHERE t64_tc_request_id_t63 = l_t63_pkey;
  IF l_t64_count = 0 THEN
    RAISE no_data_err;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Error in generating confirmations: ' || SQLERRM);
    RAISE;
END;
/
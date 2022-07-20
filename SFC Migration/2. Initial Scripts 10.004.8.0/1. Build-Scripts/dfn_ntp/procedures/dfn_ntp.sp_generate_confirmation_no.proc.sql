CREATE OR REPLACE PROCEDURE dfn_ntp.sp_generate_confirmation_no(p_from_date            DATE,
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
  TYPE lex_ref_cursor IS REF CURSOR;
  lcur_tc_qualifiers lex_ref_cursor;

  TYPE conf_tradeac IS RECORD(
    u07_id    u07_trading_account.u07_id%TYPE,
    txn_date  VARCHAR2(10),
    clearing  PLS_INTEGER,
    symbol    PLS_INTEGER,
    ord_side  PLS_INTEGER,
    market    PLS_INTEGER,
    custodian PLS_INTEGER);
  ldata_conf    conf_tradeac;
  lvch_conf_no  VARCHAR2(20);
  l_t63_pkey    NUMBER;
  l_t64_pkey    NUMBER;
  l_trans_count NUMBER;
  l_t64_count   NUMBER;
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
     1,
     p_created_by_u17_id,
     SYSDATE);

  OPEN lcur_tc_qualifiers FOR
    SELECT u07_id,
           t02_create_date txn_date,
           decode(m151.m151_is_clearing,
                  1,
                  t02.t02_settle_cal_conf_id_m95,
                  0) clearing,
           decode(m151.m151_is_symbol, 1, t02.t02_symbol_id_m20, 0) symbol,
           0 market,
           decode(m151.m151_is_order_side, 1, t02.t02_side, 0) ord_side,
           decode(m151.m151_is_custodian, 1, t02_custodian_id_m26, 0) custodian
      FROM t02_transaction_log_order_all t02,
           u01_customer u01,
           u07_trading_account u07,
           m151_trade_confirm_config m151,
           (SELECT TRIM(regexp_substr(p_trade_accounts, '[^,]+', 1, LEVEL)) pu07id
              FROM dual
            CONNECT BY regexp_substr(p_trade_accounts, '[^,]+', 1, LEVEL) IS NOT NULL) tblu07ids,
           (SELECT TRIM(regexp_substr(p_symbol, '[^,]+', 1, LEVEL)) pm20id
              FROM dual
            CONNECT BY regexp_substr(p_symbol, '[^,]+', 1, LEVEL) IS NOT NULL) symbolids,
           (SELECT TRIM(regexp_substr(p_branches, '[^,]+', 1, LEVEL)) pm07id
              FROM dual
            CONNECT BY regexp_substr(p_branches, '[^,]+', 1, LEVEL) IS NOT NULL) m07ids,
           (SELECT TRIM(regexp_substr(p_customer_groups, '[^,]+', 1, LEVEL)) pm08id
              FROM dual
            CONNECT BY regexp_substr(p_customer_groups, '[^,]+', 1, LEVEL) IS NOT NULL) m08ids,
           (SELECT TRIM(regexp_substr(p_customer_type, '[^,]+', 1, LEVEL)) pacctypeid
              FROM dual
            CONNECT BY regexp_substr(p_customer_type, '[^,]+', 1, LEVEL) IS NOT NULL) accounttypeids,
           (SELECT TRIM(regexp_substr(p_settlement, '[^,]+', 1, LEVEL)) pm95id
              FROM dual
            CONNECT BY regexp_substr(p_settlement, '[^,]+', 1, LEVEL) IS NOT NULL) settlementids,
           
           (SELECT to_date(TRIM(regexp_substr(p_cash_settle_dates,
                                              '[^,]+',
                                              1,
                                              LEVEL))) cashsettledate
              FROM dual
            CONNECT BY regexp_substr(p_cash_settle_dates, '[^,]+', 1, LEVEL) IS NOT NULL) cashsettledates,
           
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
       AND t02_create_date BETWEEN p_from_date AND (p_to_date + .99999)
       AND t02_settle_cal_conf_id_m95 = settlementids.pm95id
       AND t02.t02_cash_settle_date = cashsettledates.cashsettledate
       AND t02.t02_holding_settle_date =
           holdingsettledates.holdingsettledate
       AND t02_symbol_id_m20 = symbolids.pm20id
       AND u01.u01_account_category_id_v01 = accounttypeids.pacctypeid
          
       AND m151.m151_id =
           nvl(u07.u07_trade_conf_config_id_m151, m151.m151_id)
       AND t02.t02_trade_confirm_no IS NULL
       AND m151.m151_is_default =
           decode(nvl(u07.u07_trade_conf_config_id_m151, 0),
                  0,
                  1,
                  m151.m151_is_default)
       AND m151_institute_id_m02 = p_institute
       AND t02.t02_exchange_code_m01 = p_exchange_code
     GROUP BY u07_id,
              t02_create_date,
              m151.m151_is_clearing,
              t02.t02_settle_cal_conf_id_m95,
              m151.m151_is_symbol,
              t02.t02_symbol_id_m20,
              m151.m151_is_order_side,
              t02.t02_side,
              m151.m151_is_custodian,
              t02_custodian_id_m26;

  LOOP
    FETCH lcur_tc_qualifiers
      INTO ldata_conf;
    EXIT WHEN lcur_tc_qualifiers%NOTFOUND;
  
    SELECT to_char(SYSDATE, 'YYYYMMDD') ||
           lpad(trade_confirmation_no_seq.nextval, 6, '0')
      INTO lvch_conf_no
      FROM dual;
  
    UPDATE t02_transaction_log
       SET t02_trade_confirm_no = to_number(lvch_conf_no)
     WHERE t02_trd_acnt_id_u07 = ldata_conf.u07_id
       AND t02_create_date = ldata_conf.txn_date
       AND t02_symbol_id_m20 =
           decode(ldata_conf.symbol,
                  0,
                  t02_symbol_id_m20,
                  ldata_conf.symbol)
       AND t02_settle_cal_conf_id_m95 =
           decode(ldata_conf.clearing,
                  0,
                  t02_settle_cal_conf_id_m95,
                  ldata_conf.clearing)
       AND t02_side =
           decode(ldata_conf.ord_side, 0, t02_side, ldata_conf.ord_side)
       AND t02_custodian_id_m26 =
           decode(ldata_conf.custodian,
                  0,
                  t02_custodian_id_m26,
                  ldata_conf.custodian)
       AND t02_trade_confirm_no IS NULL
       AND t02_inst_id_m02 = p_institute
       AND t02_update_type IN (1)
       AND t02_holding_net_adjst <> 0
       AND t02_txn_code NOT IN ('REVBUY', 'REVSEL')
       AND t02_txn_entry_status = 0;
  
    SELECT COUNT(*)
      INTO l_trans_count
      FROM t02_transaction_log
     WHERE t02_trade_confirm_no = to_number(lvch_conf_no);
    IF l_trans_count > 0 THEN
    
      SELECT t64_trade_confirmation_seq.nextval INTO l_t64_pkey FROM dual;
    
      INSERT INTO t64_trade_confirmation_list
        (t64_id,
         t64_tc_request_id_t63,
         t64_trade_confirm_no,
         t64_type,
         t64_status_id_v01)
      VALUES
        (l_t64_pkey, l_t63_pkey, to_number(lvch_conf_no), 1, 1);
    END IF;
  
  END LOOP;
  CLOSE lcur_tc_qualifiers;

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
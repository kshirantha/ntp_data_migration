CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_full_vat_report (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2,
    pfromrownumber        NUMBER,
    ptorownumber          NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE,
    ptodate               DATE,
    puserfilter           VARCHAR2 DEFAULT NULL,
    pinstitute            NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT m97.m97_description AS code,
       ABS (a.t02_amnt_in_stl_currency) - a.t02_commission_adjst AS amount,
       a.t02_txn_currency,
       NVL (a.t02_broker_tax, 0) AS broker_vat,
       NVL (a.t02_exchange_tax, 0) AS exchange_vat,
       NVL (a.t02_act_broker_tax, 0) AS act_broker_vat,
       NVL (a.t02_act_exchange_tax, 0) AS act_exchange_vat,
       a.t02_create_datetime as t02_create_date,
       a.t02_order_no,
       a.t02_instrument_type,
       u01.u01_id,
       u01.u01_customer_no,
       u01.u01_external_ref_no,
       u01.u01_display_name AS custname,
       u06.u06_display_name,
       u06.u06_id,
       CASE WHEN u01.u01_vat_waive_off = 1 THEN ''Yes'' ELSE ''No'' END
           u01_vat_waive_off
  FROM t02_transaction_log a
       JOIN u01_customer u01 ON a.t02_customer_id_u01 = u01.u01_id
       JOIN u06_cash_account u06 ON a.t02_cash_acnt_id_u06 = u06.u06_id
       JOIN m97_transaction_codes m97 ON a.t02_txn_code = m97.m97_code
 WHERE     a.t02_update_type IN (1, 2, 3)
       AND a.t02_amnt_in_stl_currency <> 0
       AND a.t02_trade_process_stat_id_v01 = 25
       AND a.t02_txn_code NOT IN (''REVBUY'', ''REVSEL'')
       AND a.t02_txn_entry_status = 0
       AND (( a.t02_broker_tax IS NOT NULL and a.t02_broker_tax <> 0 ) OR
            ( a.t02_exchange_tax IS NOT NULL and a.t02_exchange_tax <> 0))
       AND a.t02_inst_id_m02 =  '
        || pinstitute;

    IF (psearchcriteria IS NOT NULL)
    THEN
        s1 := ' WHERE ' || psearchcriteria;
        s2 :=
               'SELECT COUNT(*) FROM ('
            || l_qry
            || ') WHERE '
            || psearchcriteria;
    ELSE
        s1 := '';
        s2 := 'SELECT COUNT(*) FROM (' || l_qry || ')';
    END IF;

    IF psortby IS NOT NULL
    THEN
        OPEN p_view FOR
               'SELECT t2.*
FROM (SELECT t1.*, rownum rnum
        FROM (SELECT t3.*, row_number() OVER(ORDER BY '
            || psortby
            || ') runm
              FROM ('
            || l_qry
            || ') t3'
            || s1
            || ') t1 WHERE rownum <= '
            || ptorownumber
            || ') t2 WHERE rnum >= '
            || pfromrownumber;
    ELSE
        OPEN p_view FOR
               'SELECT t2.* FROM (SELECT t1.*, rownum rn FROM (
      SELECT * FROM ('
            || l_qry
            || ')'
            || s1
            || ') t1 WHERE rownum <= '
            || ptorownumber
            || ') t2 WHERE rn >= '
            || pfromrownumber;
    END IF;


    EXECUTE IMMEDIATE s2 INTO prows;
END;
/
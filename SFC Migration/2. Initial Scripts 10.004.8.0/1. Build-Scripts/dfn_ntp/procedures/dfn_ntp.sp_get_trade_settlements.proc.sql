CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_trade_settlements (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    psortby                   VARCHAR2 DEFAULT NULL,
    pfromrownumber            NUMBER DEFAULT NULL,
    ptorownumber              NUMBER DEFAULT NULL,
    psearchcriteria           VARCHAR2 DEFAULT NULL,
    pfromdate                 DATE DEFAULT SYSDATE,
    ptodate                   DATE DEFAULT SYSDATE,
    pu01_id                   NUMBER,
    pprimaryinstitution       NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           '  SELECT CASE t02.t02_side WHEN 1 THEN ''Buy'' ELSE ''Sell'' END AS activity_code,
         t02.t02_symbol_code_m20 AS t02_symbol,
         MAX (m20.m20_isincode) AS m20_isincode,
         MAX (m20.m20_short_description) AS m20_short_description,
         MAX (m20.m20_short_description_lang) AS m20_short_description_lang,
         TRUNC (t02.t02_create_datetime) AS t02_date,
         t02.t02_cash_settle_date AS t02_settlement_date,
         ABS (
             ROUND (
                   SUM (t02.t02_last_price * t02.t02_last_shares)
                 / SUM (t02.t02_last_shares),
                 4))
             AS t02_lastpx,
         SUM (t02.t02_last_shares) AS t02_last_shares,
         MAX (m20.m20_currency_code_m03) AS m20_currency,
         CASE t02.t02_side
             WHEN 1
             THEN
                 -1 * ABS (SUM (t02.t02_last_price * t02.t02_last_shares))
             WHEN 2
             THEN
                 ABS (SUM (t02.t02_last_price * t02.t02_last_shares))
         END
             AS t02_ord_value_adjust,
         SUM (t02.t02_commission_adjst) AS t02_commission,
         CASE t02.t02_side
             WHEN 1
             THEN
                   (  (  -1
                       * ABS (SUM (t02.t02_last_price * t02.t02_last_shares)))
                    - SUM (t02.t02_commission_adjst)
                    - SUM (t02.t02_exchange_tax)
                    - SUM (t02_broker_tax))
                 * NVL (m04.m04_rate, 1)
             WHEN 2
             THEN
                   (  ABS (SUM (t02.t02_last_price * t02.t02_last_shares))
                    - SUM (t02.t02_commission_adjst)
                    - SUM (t02.t02_exchange_tax)
                    - SUM (t02_broker_tax))
                 * NVL (m04.m04_rate, 1)
         END
             AS t02_amt_in_settle_currency,
         t02.t02_exchange_code_m01 AS t02_exchange,
         u01.u01_id,
         MAX (u01.u01_customer_no) AS u01_customer_no,
         MAX (u01.u01_id) AS u06_customer_id_u01,
         MAX (u01.u01_external_ref_no) AS u06_external_ref_no,
         MAX (u01.u01_full_name) AS u01_full_name,
         MAX (u01.u01_full_name_lang) AS u01_full_name_lang,
         (SUM (NVL (t02_broker_tax, 0)) + SUM (NVL (t02_exchange_tax, 0)))
             AS vat,
         CASE u07.u07_custodian_type_v01 WHEN 0 THEN ''NO'' ELSE ''YES'' END AS icm
    FROM vw_t02_order_include_icm t02
         JOIN m20_symbol m20
             ON t02.t02_symbol_id_m20 = m20.m20_id
         LEFT JOIN m04_currency_rate m04
             ON     t02.t02_txn_currency = m04.m04_from_currency_code_m03
                AND t02.t02_settle_currency = m04.m04_to_currency_code_m03
                AND m04.m04_institute_id_m02 = '
        || pprimaryinstitution
        || '
         JOIN u07_trading_account u07
             ON t02.t02_trd_acnt_id_u07 = u07.u07_id
         JOIN u01_customer u01
             ON u07.u07_customer_id_u01 = u01.u01_id
   WHERE t02.t02_side IN (1, 2)
         AND u01.u01_id = '
        || pu01_id
        || '
         AND t02.t02_ord_status_v30 IN (''1'', ''2'')
    AND t02.t02_create_datetime BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, ' DD - MM - YYYY ')
        || ''', '' DD - MM - YYYY '')
       AND TO_DATE('''
        || TO_CHAR (ptodate, ' DD - MM - YYYY ')
        || ''', '' DD - MM - YYYY '') + .99999
    GROUP BY TRUNC(T02_CREATE_DATETIME),
      T02_CASH_SETTLE_DATE,
      u01.U01_ID,
      t02.T02_EXCHANGE_CODE_M01,
      t02.T02_SYMBOL_CODE_M20,
      t02.T02_SIDE,
      m04.m04_rate,
      U07_CUSTODIAN_TYPE_V01';

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber);
    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/
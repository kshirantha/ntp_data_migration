CREATE OR REPLACE PROCEDURE dfn_ntp.sp_swap_trade_notification (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT c.*,
       CASE
           WHEN t02_side = 1 THEN close_bal - noofshares
           WHEN t02_side = 2 THEN close_bal + noofshares
       END
           AS opening_bal
  FROM (SELECT b.*, SUM (holding) OVER (PARTITION BY t02_trd_acnt_id_u07, symbol ORDER BY seq) close_bal
          FROM (
          SELECT a.*,
                       CASE
                           WHEN ROWNUM = 1
                           THEN
                               CASE
                                   WHEN t02_side = 1
                                   THEN
                                       h01_net_holding + noofshares
                                   WHEN t02_side = 2
                                   THEN
                                       h01_net_holding - noofshares
                               END
                           ELSE
                               CASE
                                   WHEN t02_side = 1 THEN noofshares
                                   WHEN t02_side = 2 THEN -noofshares
                               END
                       END
                           AS holding,
                      /* ROWNUM AS seq */
                       ROW_NUMBER ()
                       OVER (PARTITION BY t02_trd_acnt_id_u07, symbol
                             ORDER BY t02_create_date)
                           AS seq
                  FROM (

                  SELECT t02.t02_create_date AS ddate,
                                 --TO_CHAR (
                                 --    (a.t11_datetime + m11.m11_gmt_offset / 24),
                                 --    ''HH24:MI:SS'')
                                 --    AS ttime,
                                 t02.t02_trd_acnt_id_u07 AS securityaccountcode,
                                 u07.u07_exchange_account_no AS tradingacno,
                                 t02.t02_symbol_code_m20 AS symbol,
                                 m20.m20_long_description  AS securityname,
                                 m02.m02_name AS instname,
                                 t02.t02_side AS side,
                                 m02.m02_id,
                                 CASE
                                     WHEN t02.t02_side = 1 THEN ''Buy''
                                     WHEN t02.t02_side = 2 THEN ''Sell''
                                 END
                                     AS side_dis,
                                 u01.u01_full_name AS investername,
                                 u01.u01_full_name AS uinvestername,

                                    NVL (u02.u02_po_box, '''')
                                 || CASE
                                        WHEN u02.u02_po_box IS NULL THEN ''''
                                        ELSE '',''
                                    END
                                 || NVL (u02.u02_address_line1, '''')
                                 || CASE
                                        WHEN u02.u02_address_line1
                                                 IS NULL
                                        THEN
                                            ''''
                                        ELSE
                                            '',''
                                    END
                                 || NVL (u02.u02_address_line2, '''')
                                 || CASE
                                        WHEN u02.u02_address_line2
                                                 IS NULL
                                        THEN
                                            ''''
                                        ELSE
                                            '',''
                                    END
                                 || NVL (u02.u02_zip_code, '''')
                                     AS cusaddress,

                                 m02.m02_code,
                                 acctype,
                                 CASE
                                     WHEN acctype = ''Individual''
                                     THEN
                                         acctype
                                     WHEN acctype = ''Corporate''
                                     THEN
                                         u01.client_type
                                 END
                                     AS investertype,
                                 CASE
                                     WHEN acctype = ''Individual''
                                     THEN
                                         c2.m05_name
                                     WHEN acctype = ''Corporate''
                                     THEN
                                         c1.m05_name
                                 END
                                     AS investercountry,
                                 t02.t02_cum_qty AS noofshares,
                                 t02.t02_avgprice AS avgprice,
                                 -- TO_CHAR (TRUNC (t02.t02_create_date), ''DD/MM/YYYY'') AS timestamp,
                                 t02.t02_create_date AS timestamp,
                                 t02.t02_exg_commission AS exchangecomm,
                                 (t02.t02_commission_adjst - t02.t02_exg_commission) as apcomm,
                                 NVL (h01.h01_net_holding, 0) AS h01_net_holding,
                                 ''N'' AS crosstrade,
                                 '''' descriptionofother,
                                 t02.t02_cumord_value AS cumord_value,
                                 t02.t02_create_date,
                                 t02.t02_trd_acnt_id_u07,
                                 t02.t02_side,
                                 u01.u01_full_name,
                                 NVL (h01.h01_net_holding, 0) AS opening_balance,
                                   NVL (h01.h01_net_holding, 0)
                                 + (CASE
                                        WHEN t02.t02_side = 1
                                        THEN
                                            t02.t02_last_shares
                                        WHEN t02.t02_side = 2
                                        THEN
                                            - t02.t02_last_shares
                                    END)
                                     AS closing_balance
                            FROM t02_transaction_log_order t02,
                                 u07_trading_account u07,
                                 m02_institute m02,
                                 m05_country c1,
                                 m05_country c2,
                                 vw_h01_holding_summary h01,
                                 m01_exchanges m01, -- Used to get GMT offset ?
                                 (SELECT CASE
                                             WHEN a.u01_corp_client_type_id_v01 = 1
                                             THEN
                                                 ''Company''
                                             WHEN a.u01_corp_client_type_id_v01 = 2
                                             THEN
                                                 ''Government''
                                             WHEN a.u01_corp_client_type_id_v01 = 3
                                             THEN
                                                 ''Institution''
                                         END
                                             AS client_type,
                                         CASE
                                             WHEN a.u01_account_category_id_v01 = 1
                                             THEN
                                                 ''Individual''
                                             WHEN a.u01_account_category_id_v01 = 2
                                             THEN
                                                 ''Corporate''
                                         END
                                             AS acctype,
                                         a.*
                                    FROM u01_customer a) u01,
                                 u06_cash_account u06,
                                 m20_symbol m20,
                                 u02_customer_contact_info u02
                           WHERE   t02.t02_trd_acnt_id_u07 = u07.u07_id
                                 AND t02.t02_exchange_code_m01 = m01.m01_exchange_code
                                 AND t02.t02_exchange_code_m01 = u07.u07_exchange_code_m01
                                 AND u01.u01_swap_master = 1
                                 AND u07.u07_customer_id_u01 = u01.u01_id
                                 AND u07.u07_exchange_code_m01 = t02.t02_exchange_code_m01
                                 AND u01.u01_institute_id_m02 = m02.m02_id
                                 AND t02.t02_side IN (1, 2)
                                 AND t02.t02_trd_acnt_id_u07 = h01.h01_trading_acnt_id_u07(+)
                                 AND t02.t02_exchange_code_m01 = h01.h01_exchange_code_m01(+)
                                 AND t02.t02_symbol_id_m20 = h01.h01_symbol_id_m20(+)
                                 AND t02.t02_symbol_id_m20 = m20.m20_id
                                 AND TO_CHAR (TO_DATE ('''
        || pfromdate
        || ''') - 1, ''DD-MM-YYYY'') =
                                 h01.h01_date(+)
AND t02.t02_create_date BETWEEN TO_DATE ('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',
                                      ''DD-MM-YYYY'')
                                                      AND   TO_DATE ('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',
                                        ''DD-MM-YYYY'')+ 0.99999

                                 AND u01.u01_birth_country_id_m05 = c1.m05_id(+)
                                 AND u01.u01_id = u06.u06_customer_id_u01(+)
                                 AND u06.u06_id = u07.u07_cash_account_id_u06(+)
                                 AND u01.u01_nationality_id_m05 = c2.m05_id(+)
                                 AND u01.u01_id = u02.u02_customer_id_u01(+)
                                 AND u02.u02_is_default = 1
                        ORDER BY u01.u01_full_name, t02.t02_symbol_code_m20, t02.t02_create_date, t02.t02_trd_acnt_id_u07
                        ) a ) b) c';

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

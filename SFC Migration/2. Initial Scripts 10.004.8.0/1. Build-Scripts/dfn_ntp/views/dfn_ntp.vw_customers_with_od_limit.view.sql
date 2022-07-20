CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_customers_with_od_limit
(
   u01_institute_id_m02,
   m02_code,
   u01_customer_no,
   u01_id,
   custname,
   is_risky,
   service_location,
   realized_gl
)
AS
   (SELECT u01.u01_institute_id_m02,
           c.m02_code,
           u01.u01_customer_no,
           u01.u01_id,
           u01.u01_display_name AS custname,
           CASE WHEN x.risky_accounts > 0 THEN 'YES' ELSE 'NO' END
              AS is_risky,
           NVL (m07.m07_name, 'N/A') AS service_location,
           NVL (rgl.realized_gl, 0) AS realized_gl
      FROM u01_customer u01,
           (SELECT   a.u06_customer_id_u01,
                     SUM (CASE WHEN a.utilization > 0.6 THEN 1 ELSE 0 END)
                        risky_accounts
                FROM vw_trading_limit_utilized a
            GROUP BY a.u06_customer_id_u01) x,
           m02_institute c,
           m07_location m07,
           (SELECT   a.t02_customer_id_u01,
                     NVL (SUM (realized_gl * b.m04_rate), 0) AS realized_gl
                FROM (SELECT   a.t02_inst_id_m02,
                               a.t02_customer_id_u01,
                               a.t02_cash_acnt_id_u06,
                               a.t02_txn_currency,
                               SUM (a.t02_gainloss) AS realized_gl,
                               m02.m02_display_currency_code_m03
                          FROM t02_transact_log_order_arc_all a,
                               m02_institute m02
                         WHERE     a.t02_inst_id_m02 = m02.m02_id
                               AND a.t02_txn_code = 'STLSEL'
                      GROUP BY a.t02_inst_id_m02,
                               a.t02_customer_id_u01,
                               a.t02_cash_acnt_id_u06,
                               a.t02_txn_currency,
                               m02.m02_display_currency_code_m03) a,
                     (SELECT b.m04_from_currency_code_m03 AS c1,
                             b.m04_to_currency_code_m03 AS c2,
                             b.m04_rate,
                             b.m04_institute_id_m02 AS inst_id
                        FROM m04_currency_rate b
                      UNION ALL
                      SELECT a.m03_code AS c1,
                             a.m03_code asc2,
                             1,
                             m02.m02_id AS inst_id
                        FROM m03_currency a, m02_institute m02) b
               WHERE     a.t02_txn_currency = b.c1(+)
                     AND b.c2 = a.m02_display_currency_code_m03
                     AND b.inst_id = a.t02_inst_id_m02
            GROUP BY a.t02_customer_id_u01) rgl
     WHERE     u01.u01_id = x.u06_customer_id_u01
           AND u01.u01_institute_id_m02 = c.m02_id
           AND u01.u01_signup_location_id_m07 = m07.m07_id(+)
           AND u01.u01_id = rgl.t02_customer_id_u01(+))
/
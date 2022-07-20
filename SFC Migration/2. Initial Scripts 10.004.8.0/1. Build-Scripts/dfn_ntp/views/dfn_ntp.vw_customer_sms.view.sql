CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_customer_sms
(
    u01_id,
    u01_customer_no,
    u02_mobile,
    u02_email,
    u01_full_name,
    t01_status_id_v30,
    t01_last_updated_date_time,
    t01_ord_no
)
AS
    SELECT t.u01_id,
           t.u01_customer_no,
           t.u02_mobile,
           t.u02_email,
           t.u01_full_name,
           t.t01_status_id_v30,
           t.t01_last_updated_date_time,
           t.t01_ord_no
      FROM (SELECT u01.u01_id,
                   u01.u01_customer_no,
                   u01.u01_def_mobile AS u02_mobile,
                   u01.u01_def_email AS u02_email,
                   u01.u01_full_name,
                   t01.t01_status_id_v30,
                   t01.t01_last_updated_date_time,
                   t01.t01_ord_no,
                   ROW_NUMBER ()
                   OVER (PARTITION BY u01.u01_id
                         ORDER BY t01.t01_last_updated_date_time DESC)
                       AS rownumber
              FROM     u01_customer u01
                   JOIN
                       t01_order_all t01
                   ON u01.u01_id = t01.t01_customer_id_u01) t
     WHERE t.rownumber = 1
/
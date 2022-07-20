CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_db_margin_customer_status
(
    institute,
    margin_customer_type,
    margin_customer_type_count
)
AS
      SELECT utilized.u01_institute_id_m02 AS institute,
             'UTILIZED' margin_customer_type,
             COUNT (utilized.u23_id) AS margin_customer_type_count
        FROM vw_dc_margin_customers utilized
       WHERE utilized.total_cash_balance < 0
    GROUP BY utilized.u01_institute_id_m02
    UNION
      SELECT enabled.u01_institute_id_m02 AS institute,
             'ENABLED' margin_customer_type,
             COUNT (enabled.u23_id) AS margin_customer_type_count
        FROM vw_dc_margin_customers enabled
       WHERE enabled.u06_margin_enabled = 1
    GROUP BY enabled.u01_institute_id_m02
    UNION
      SELECT expired.u01_institute_id_m02 AS institute,
             'EXPIRED' margin_customer_type,
             COUNT (expired.u23_id) AS margin_customer_type_count
        FROM vw_dc_margin_customers expired
       WHERE expired.u06_margin_enabled = 1
    GROUP BY expired.u01_institute_id_m02
/

DROP VIEW dfn_ntp.vw_db_margin_customer_status
/
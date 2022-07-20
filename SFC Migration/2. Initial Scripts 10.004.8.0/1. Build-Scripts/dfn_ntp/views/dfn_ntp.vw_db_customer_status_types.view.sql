CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_db_customer_status_types
(
    institute,
    cust_type,
    cust_count
)
AS
      SELECT locked.u01_institute_id_m02 AS institute,
             'LOCKED' AS cust_type,
             COUNT (locked.u09_id) AS cust_count
        FROM vw_u09_acc_locked_customer locked
    GROUP BY locked.u01_institute_id_m02
    UNION
      SELECT expired.u01_institute_id_m02 AS institute,
             'EXPIRED' AS cust_type,
             COUNT (expired.u01_id) AS cust_count
        FROM vw_id_expired_customer_list expired
    GROUP BY expired.u01_institute_id_m02
    UNION
      SELECT frozen.u01_institute_id_m02 AS institute,
             'FROZEN' AS cust_type,
             COUNT (frozen.u05_id) AS cust_count
        FROM vw_u05_customer_acc_frozen frozen
    GROUP BY frozen.u01_institute_id_m02
/

DROP VIEW dfn_ntp.vw_db_customer_status_types
/

CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_db_cash_account_status
(
    institute,
    status,
    COUNT
)
AS
      SELECT active.u06_institute_id_m02 AS institute,
             'ACTIVE' AS status,
             COUNT (*) AS COUNT
        FROM u06_cash_account active
       WHERE active.u06_inactive_drmnt_status_v01 = 10
    GROUP BY active.u06_institute_id_m02
    UNION
      SELECT inactive.u06_institute_id_m02 AS institute,
             'INACTIVE' AS status,
             COUNT (*) AS COUNT
        FROM u06_cash_account inactive
       WHERE inactive.u06_inactive_drmnt_status_v01 = 11
    GROUP BY inactive.u06_institute_id_m02
    UNION
      SELECT dormant.u06_institute_id_m02 AS institute,
             'DORMANT' AS status,
             COUNT (*) AS COUNT
        FROM u06_cash_account dormant
       WHERE dormant.u06_inactive_drmnt_status_v01 = 12
    GROUP BY dormant.u06_institute_id_m02
/

DROP VIEW dfn_ntp.vw_db_cash_account_status
/
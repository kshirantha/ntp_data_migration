CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_db_advanced_approvals
(
    institute,
    approval_name,
    approval_count,
    approval_type
)
AS
      SELECT a03.a03_institute_id_m02 AS institute,
             a03.a03_table AS approval_name,
             COUNT (*) approval_count,
             CASE
                 WHEN SUBSTR (a03.a03_table, 1, 1) IN ('M', 'V') THEN 'MASTER'
                 ELSE 'OTHER'
             END
                 AS approval_type
        FROM a03_approval_audit a03
       WHERE a03.a03_status_id_v01 NOT IN (2, 3)
    GROUP BY a03.a03_institute_id_m02, a03.a03_table
/

DROP VIEW dfn_ntp.vw_db_advanced_approvals
/
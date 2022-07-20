CREATE OR REPLACE PROCEDURE dfn_ntp.sp_db_advanced_approvals (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    p_institution_id   IN     NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT a03.*,
               m53.m53_table_description AS title,
               m53.m53_apprvl_entitlement_id_v04 AS entitlement_id,
               m53.m53_id AS table_id,
               m53.m53_approval_type AS approval_type,
               m53.m53_route AS route
          FROM (  SELECT a03.a03_table AS approval_name,
                         COUNT (*) approval_count,
                         CASE
                             WHEN SUBSTR (a03.a03_table, 1, 1) IN ('M', 'V')
                             THEN
                                 1
                             ELSE
                                 0
                         END
                             AS is_master
                    FROM a03_approval_audit_all a03
                   WHERE     a03.a03_status_id_v01 NOT IN (2, 3)
                         AND a03.a03_institute_id_m02 = p_institution_id
                GROUP BY a03.a03_table) a03,
               m53_approval_required_tables m53
         WHERE     m53.m53_table = a03.approval_name
               AND m53.m53_route IS NOT NULL;
END;
/

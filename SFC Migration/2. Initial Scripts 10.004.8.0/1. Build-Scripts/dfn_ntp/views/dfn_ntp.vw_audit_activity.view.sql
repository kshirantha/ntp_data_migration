CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_audit_activity
(
    m82_id,
    m82_activity_name,
    m82_category_id_m81,
    m81_category
)
AS
    SELECT a.m82_id,
           a.m82_activity_name,
           a.m82_category_id_m81,
           m81.m81_category
      FROM     m82_audit_activity a
           LEFT JOIN
               m81_audit_category m81
           ON a.m82_category_id_m81 = m81.m81_id;
/

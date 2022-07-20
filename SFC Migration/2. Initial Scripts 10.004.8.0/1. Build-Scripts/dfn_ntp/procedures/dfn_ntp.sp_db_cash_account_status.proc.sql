CREATE OR REPLACE PROCEDURE dfn_ntp.sp_db_cash_account_status (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    p_institution_id   IN     NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT active.u06_institute_id_m02 AS institute,
               'ACTIVE' AS status,
               COUNT (*) AS COUNT
          FROM u06_cash_account active
         WHERE     active.u06_inactive_drmnt_status_v01 = 10
               AND active.u06_institute_id_m02 = p_institution_id
        UNION
        SELECT inactive.u06_institute_id_m02 AS institute,
               'INACTIVE' AS status,
               COUNT (*) AS COUNT
          FROM u06_cash_account inactive
         WHERE     inactive.u06_inactive_drmnt_status_v01 = 11
               AND inactive.u06_institute_id_m02 = p_institution_id
        UNION
        SELECT dormant.u06_institute_id_m02 AS institute,
               'DORMANT' AS status,
               COUNT (*) AS COUNT
          FROM u06_cash_account dormant
         WHERE     dormant.u06_inactive_drmnt_status_v01 = 12
               AND dormant.u06_institute_id_m02 = p_institution_id;
END;
/


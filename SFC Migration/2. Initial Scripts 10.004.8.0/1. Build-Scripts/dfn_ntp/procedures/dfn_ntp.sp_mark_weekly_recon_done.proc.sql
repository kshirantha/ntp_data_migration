CREATE OR REPLACE PROCEDURE dfn_ntp.sp_mark_weekly_recon_done (
    p_status                      OUT NUMBER,
    p_updated_by               IN     NUMBER,
    p_primary_institution_id   IN     NUMBER DEFAULT 1)
IS
    l_pending_count   NUMBER;
BEGIN
    p_status := 18;

    SELECT COUNT (*)
      INTO l_pending_count
      FROM t23_share_txn_requests t23
     WHERE     t23.t23_status_id_v01 IN
                   (1, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110)
           AND t23.t23_type = 2
           AND t23.t23_primary_institute_id_m02 = p_primary_institution_id;

    IF l_pending_count = 0
    THEN
        p_status := 17;

        UPDATE u53_process_detail
           SET u53_status_id_v01 = 17,
               u53_failed_reason = NULL,
               u53_updated_by_id_u17 = p_updated_by,
               u53_updated_date_time = SYSDATE
         WHERE     u53_code = 'WEEKLY'
               AND u53_primary_institute_id_m02 = p_primary_institution_id;
    END IF;
END;
/

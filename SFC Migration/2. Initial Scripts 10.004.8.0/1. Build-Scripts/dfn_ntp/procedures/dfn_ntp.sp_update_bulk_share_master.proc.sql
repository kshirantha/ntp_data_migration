CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_bulk_share_master (
    p_updated_by        IN NUMBER,
    p_share_master_id   IN VARCHAR2)
IS
    l_pending_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_pending_count
      FROM t12_share_transaction t12
     WHERE     t12.t12_status_id_v01 IN
                   (1, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110)
           AND t12.t12_bulk_master_id_t61 = p_share_master_id;		   

    IF l_pending_count > 0
    THEN
        UPDATE t61_bulk_share_transactions t61
           SET t61.t61_status_id_v01 = 18,
               t61.t61_status_changed_by_id_u17 = p_updated_by,
               t61.t61_status_changed_date = SYSDATE
         WHERE t61.t61_id = p_share_master_id;
    ELSE
        UPDATE t61_bulk_share_transactions t61
           SET t61.t61_status_id_v01 = 17,
               t61.t61_status_changed_by_id_u17 = p_updated_by,
               t61.t61_status_changed_date = SYSDATE
         WHERE t61.t61_id = p_share_master_id;
    END IF;
END;
/

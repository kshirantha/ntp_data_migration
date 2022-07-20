CREATE OR REPLACE PROCEDURE dfn_ntp.sp_ca_bulk_l1_approve (
    p_file_type                IN NUMBER,
    p_file_date                IN VARCHAR2,
    p_updated_by               IN NUMBER,
    p_primary_institution_id   IN NUMBER DEFAULT 1)
IS
BEGIN
    --  This procedure is added temporary for demo purpose to bulk approve l1. Need to introduce proper solution
    UPDATE t23_share_txn_requests t23
       SET t23.t23_status_id_v01 = 101,
           t23.t23_status_changed_by_id_u17 = p_updated_by,
           t23.t23_status_changed_date = SYSDATE,
           t23.t23_current_approval_level = t23.t23_current_approval_level + 1,
           t23.t23_next_status = 102
     WHERE     t23.t23_type = p_file_type
           AND t23.t23_primary_institute_id_m02 = p_primary_institution_id
           AND t23.t23_status_id_v01 NOT IN (2, 3, 17) -- 17 Can not be. But for IPO it gets 17. it should be either 2 or 3
           AND t23.t23_status_id_v01 <> 101 -- Discard which are already in L1 Status
           AND t23.t23_position_date = TO_DATE (p_file_date, 'dd/mm/yyyy');
END;
/

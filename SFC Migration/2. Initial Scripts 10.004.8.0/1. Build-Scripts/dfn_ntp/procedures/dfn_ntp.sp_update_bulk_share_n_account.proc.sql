CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_bulk_share_n_account (
    p_updated_by              IN NUMBER,
    p_share_master_id         IN VARCHAR2,
    p_change_account_req_id   IN NUMBER DEFAULT 0)
IS
    l_pending_count   NUMBER := 0;
    l_u07_from_id     NUMBER;
BEGIN
    sp_update_bulk_share_master (p_updated_by        => p_updated_by,
                                 p_share_master_id   => p_share_master_id
                                );
								

    IF p_change_account_req_id != 0
    THEN
        UPDATE t502_change_account_requests_c b
           SET b.t502_status_id_v01 = 102
         WHERE b.t502_id = p_change_account_req_id;

        SELECT a.t502_from_trading_acc_id_u07
          INTO l_u07_from_id
          FROM t502_change_account_requests_c a
         WHERE a.t502_id = p_change_account_req_id;

        UPDATE u07_trading_account a
           SET a.u07_status_id_v01 = 5,
               a.u07_status_changed_by_id_u17 = p_updated_by,
               a.u07_status_changed_date = SYSDATE,
               a.u07_external_ref_no = NULL,
               a.u07_display_name = NULL,
               a.u07_exchange_account_no = NULL
         WHERE u07_id = l_u07_from_id;
    END IF;
END;
/
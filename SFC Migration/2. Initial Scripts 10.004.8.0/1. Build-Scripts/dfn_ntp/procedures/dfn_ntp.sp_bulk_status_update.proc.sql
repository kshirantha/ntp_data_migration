CREATE OR REPLACE 
PROCEDURE dfn_ntp.sp_bulk_status_update (impact_code    IN NUMBER,
                                 action_type    IN VARCHAR,
                                 reference_id   IN NUMBER,
                                 approved_by    IN VARCHAR)
IS
BEGIN
    IF impact_code = 2
    THEN
        IF action_type = 'T43' --International Corporate Action Cash Adjuestment Changes
        THEN
            UPDATE t43_cust_corp_act_cash_adjust
               SET t43_status_id_v01 = 17,
                   t43_status_changed_date = SYSDATE,
                   t43_status_changed_by_id_u17 = approved_by
             WHERE t43_id = TO_NUMBER (reference_id);
		ELSIF action_type = 'T87' --Bulk Cash Adjustment
        THEN
            UPDATE t87_bulk_cash_adjustments
               SET t87_status_id_v01 = 17
             WHERE t87_id = TO_NUMBER (reference_id);
        END IF;
    ELSIF impact_code = 3
    THEN
        IF action_type = 'T23' -- CA Process + Weekly Corporate Status Update
        THEN
            UPDATE t23_share_txn_requests
               SET t23_status_id_v01 = 17
             WHERE t23_id = TO_NUMBER (reference_id);
        ELSIF action_type = 'T42' -- International Corporate Action Holding Adjuestment Status Update
        THEN
            UPDATE t42_cust_corp_act_hold_adjust
               SET t42_status_id_v01 = 17,
                   t42_status_changed_date = SYSDATE,
                   t42_status_changed_by_id_u17 = approved_by
             WHERE t42_id = TO_NUMBER (reference_id);
        ELSIF action_type = 'T25' -- B-File Status Update
        THEN
            UPDATE t25_stock_transfer
               SET t25_status = 17,
                   t25_last_updated = SYSDATE,
                   t25_approved_by = TO_CHAR(approved_by)
             WHERE t25_id = TO_NUMBER (reference_id);
        END IF;
    END IF;
END;
/


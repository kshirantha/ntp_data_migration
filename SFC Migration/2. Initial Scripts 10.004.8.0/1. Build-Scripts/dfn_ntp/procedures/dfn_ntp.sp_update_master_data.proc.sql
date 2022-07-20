CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_master_data
IS
    l_sysdate            DATE := func_get_eod_date;
    l_sysdate_plus_one   DATE := func_get_eod_date + 1;
    l_time               VARCHAR2 (10);
BEGIN
    -- Activate Deactivate Commission Discount Rate
    BEGIN
        UPDATE m25_commission_discount_slabs
           SET m25_is_active = 1
         WHERE     l_sysdate >= TRUNC (m25_starting_date)
               AND l_sysdate <= TRUNC (m25_ending_date);

        UPDATE m25_commission_discount_slabs
           SET m25_is_active = 0
         WHERE NOT (    l_sysdate >= TRUNC (m25_starting_date)
                    AND l_sysdate <= TRUNC (m25_ending_date));

        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            RAISE;
    END;
END;
/
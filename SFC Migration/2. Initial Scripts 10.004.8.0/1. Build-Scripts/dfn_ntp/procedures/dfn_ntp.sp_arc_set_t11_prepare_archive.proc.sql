CREATE OR REPLACE PROCEDURE dfn_ntp.sp_arc_set_t11_prepare_archive (
    pdate     IN     DATE,
    pstatus      OUT NUMBER)
IS
    l_status   NUMBER;
BEGIN
    UPDATE t11_block_amount_details
       SET t11_is_archive_ready = 1
     WHERE     t11_status IN (2, 3)
           AND t11_value_date <=
                     TO_DATE (TO_CHAR (pdate, 'DD-MM-YYYY'), 'DD-MM-YYYY')
                   + .99999;

    l_status := 1;
    pstatus := l_status;
EXCEPTION
    WHEN OTHERS
    THEN
        l_status := 2;
        pstatus := l_status;
END;
/

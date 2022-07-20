CREATE OR REPLACE PROCEDURE dfn_ntp.sp_arc_set_t06_prepare_archive (
    pdate IN DATE)
IS
BEGIN
    UPDATE t06_cash_transaction
       SET t06_is_archive_ready = 1
     WHERE t06_status_id IN (2, 3) AND t06_date <= pdate + 0.99999;
END;
/

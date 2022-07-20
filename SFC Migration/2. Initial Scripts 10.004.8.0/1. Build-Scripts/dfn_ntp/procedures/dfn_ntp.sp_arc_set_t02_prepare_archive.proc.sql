CREATE OR REPLACE PROCEDURE dfn_ntp.sp_arc_set_t02_prepare_archive (
    pdate IN DATE)
IS
BEGIN
    MERGE INTO t02_transaction_log
         USING DUAL
            ON (    t02_create_date <= TRUNC (pdate) + 0.99999
                AND t02_update_type = 1
                AND t02_ord_status_v30 NOT IN
                        ('0',
                         '1',
                         '5',
                         '6',
                         'A',
                         'a',
                         'c',
                         'E',
                         'K',
                         'M',
                         'O',
                         'P',
                         'Q',
                         'T',
                         'Z',
                         'D',
                         'N',
                         'H'))
    WHEN MATCHED
    THEN
        UPDATE SET t02_is_archive_ready = 1;

    MERGE INTO t02_transaction_log
         USING DUAL
            ON (    t02_create_date <= TRUNC (pdate) + 0.99999
                AND t02_update_type <> 1)
    WHEN MATCHED
    THEN
        UPDATE SET t02_is_archive_ready = 1;
END;
/

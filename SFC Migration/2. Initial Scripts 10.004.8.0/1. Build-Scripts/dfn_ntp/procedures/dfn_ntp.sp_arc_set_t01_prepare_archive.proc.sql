CREATE OR REPLACE PROCEDURE dfn_ntp.sp_arc_set_t01_prepare_archive (
    pdate IN DATE)
IS
BEGIN
    MERGE INTO t01_order
         USING DUAL
            ON (    t01_status_id_v30 NOT IN
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
                         'Z',
                         'D',
                         'N',
                         'H')
                AND t01_date <= TRUNC (pdate) + 0.99999)
    WHEN MATCHED
    THEN
        UPDATE SET t01_is_archive_ready = 1;
END;
/

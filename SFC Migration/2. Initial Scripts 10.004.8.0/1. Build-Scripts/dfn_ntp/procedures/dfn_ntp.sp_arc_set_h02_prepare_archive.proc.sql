CREATE OR REPLACE PROCEDURE dfn_ntp.sp_arc_set_h02_prepare_archive (
    pdate IN DATE)
IS
BEGIN
    FOR i IN (  SELECT h02_cash_account_id_u06, MAX (h02_date) AS h02_date
                  FROM h02_cash_account_summary
                 WHERE h02_date <= TRUNC (pdate) + 0.99999
              GROUP BY h02_cash_account_id_u06)
    LOOP
        UPDATE h02_cash_account_summary
           SET h02_is_archive_ready = 1
         WHERE     h02_cash_account_id_u06 = i.h02_cash_account_id_u06
               AND h02_date < i.h02_date;
    END LOOP;
END;
/
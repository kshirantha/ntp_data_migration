CREATE OR REPLACE PROCEDURE dfn_ntp.sp_expire_direct_dealing
IS
BEGIN
    UPDATE u01_customer
       SET u01_direct_dealing_enabled = 0,                  --0 - No | 1 - Yes
           u01_dd_reference_no = NULL,
           u01_dd_from_date = NULL,
           u01_dd_to_date = NULL
     WHERE u01_dd_to_date <= func_get_eod_date + 0.99999;
END;
/

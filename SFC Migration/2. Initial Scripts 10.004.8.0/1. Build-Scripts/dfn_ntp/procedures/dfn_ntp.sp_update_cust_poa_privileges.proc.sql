CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_cust_poa_privileges
IS
BEGIN
    UPDATE u49_poa_trading_privileges u49
       SET u49.u49_is_active = 0
     WHERE TRUNC (u49.u49_poa_expiry_date) <= func_get_eod_date;
END;
/
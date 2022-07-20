CREATE OR REPLACE PROCEDURE dfn_ntp.set_trd_acc_status_by_cash_acc (
    pu06_id                  IN NUMBER,
    pu06_status_id           IN NUMBER,
    pu06_status_changed_by   IN NUMBER)
IS
    l_count   NUMBER;
BEGIN
    FOR i IN (SELECT u07.u07_id
                FROM u07_trading_account u07
               WHERE u07.u07_cash_account_id_u06 = pu06_id)
    LOOP
        UPDATE u07_trading_account u07
           SET u07.u07_status_id_v01 = pu06_status_id,
               u07.u07_status_changed_by_id_u17 = pu06_status_changed_by,
               u07.u07_status_changed_date = SYSDATE
         WHERE u07.u07_id = i.u07_id;
    END LOOP;
END;
/
/

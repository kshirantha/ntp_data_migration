CREATE OR REPLACE PROCEDURE dfn_ntp.u07_set_trading (
    --  pkey                             OUT VARCHAR,
    pu07_id                       IN NUMBER,
    pu07_exchange_id_m01          IN NUMBER,
    ptrading                      IN NUMBER,
    pu07_trading_enabled_by          NUMBER DEFAULT NULL,
    pu07_trading_disable_reason      VARCHAR2 DEFAULT NULL)
IS
    l_count   NUMBER;
    zcustid   NUMBER;
BEGIN
    SELECT u07.u07_customer_id_u01
      INTO zcustid
      FROM u07_trading_account u07
     WHERE u07.u07_id = pu07_id;

    SELECT COUNT (*)
      INTO l_count
      FROM u07_trading_account u07
     WHERE u07.u07_id = pu07_id AND u07.u07_trading_enabled_date IS NULL;

    UPDATE u07_trading_account u07
       SET u07.u07_trading_enabled = ptrading
     WHERE u07.u07_id = pu07_id;

    IF ptrading = 1 AND l_count = 1
    THEN
        UPDATE u07_trading_account u07
           SET u07.u07_trading_enabled_date = SYSDATE
         WHERE u07.u07_id = pu07_id;
    END IF;

    SELECT COUNT (u07.u07_trading_enabled)
      INTO l_count
      FROM u07_trading_account u07
     WHERE u07.u07_customer_id_u01 = zcustid AND u07.u07_trading_enabled = 1;

    IF l_count <> 0
    THEN
        l_count := 1;
    END IF;

    UPDATE u01_customer u01
       SET u01_trading_enabled = l_count
     WHERE u01.u01_id = zcustid;
END;
/
/

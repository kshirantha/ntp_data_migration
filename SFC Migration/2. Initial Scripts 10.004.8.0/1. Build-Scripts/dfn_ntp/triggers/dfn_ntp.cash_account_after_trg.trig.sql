CREATE OR REPLACE TRIGGER dfn_ntp.cash_account_after_trg
    AFTER UPDATE OF u06_display_name
    ON dfn_ntp.u06_cash_account
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
DECLARE
    p_u06_id             NUMBER;
    p_u06_display_name   VARCHAR2 (250);
BEGIN
    IF (:new.u06_display_name <> :old.u06_display_name)
    THEN
        p_u06_id := NVL (:new.u06_id, 0);
        p_u06_display_name := NVL (:new.u06_display_name, 0);

        UPDATE u07_trading_account
           SET u07_display_name_u06 = p_u06_display_name
         WHERE u07_cash_account_id_u06 = p_u06_id;
    END IF;
END;
/
ALTER TRIGGER dfn_ntp.cash_account_after_trg ENABLE;
/
CREATE OR REPLACE TRIGGER dfn_ntp.customer_after_update_trg
    AFTER UPDATE
    ON dfn_ntp.u01_customer
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
DECLARE
    p_u01_id              NUMBER;
    p_u01_customer_no     VARCHAR2 (50);
    p_u01_display_name    VARCHAR2 (1000);
    p_u01_default_id_no   VARCHAR2 (20);
BEGIN
    p_u01_id := NVL (:new.u01_id, 0);
    p_u01_customer_no := NVL (:new.u01_customer_no, 0);
    p_u01_display_name := NVL (:new.u01_display_name, 0);
    p_u01_default_id_no := NVL (:new.u01_default_id_no, 0);

    UPDATE u06_cash_account
       SET u06_customer_no_u01 = p_u01_customer_no,
           u06_display_name_u01 = p_u01_display_name,
           u06_default_id_no_u01 = p_u01_default_id_no
     WHERE u06_customer_id_u01 = p_u01_id;

    UPDATE u07_trading_account
       SET u07_customer_no_u01 = p_u01_customer_no,
           u07_display_name_u01 = p_u01_display_name,
           u07_default_id_no_u01 = p_u01_default_id_no
     WHERE u07_customer_id_u01 = p_u01_id;
END;
/
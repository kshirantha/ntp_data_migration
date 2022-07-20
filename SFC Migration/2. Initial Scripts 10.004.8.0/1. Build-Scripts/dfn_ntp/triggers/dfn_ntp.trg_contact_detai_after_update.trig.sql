CREATE OR REPLACE TRIGGER dfn_ntp.trg_contact_detai_after_update
    AFTER INSERT OR UPDATE OF u02_email, u02_mobile
    ON dfn_ntp.u02_customer_contact_info
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
    WHEN (new.u02_is_default = 1)
DECLARE
    p_u02_customer_id_u01   u02_customer_contact_info.u02_customer_id_u01%TYPE;
    p_u02_email             u02_customer_contact_info.u02_email%TYPE;
    p_u02_mobile            u02_customer_contact_info.u02_mobile%TYPE;
BEGIN
    p_u02_customer_id_u01 := NVL (:new.u02_customer_id_u01, 0);
    p_u02_email := :new.u02_email;
    p_u02_mobile := :new.u02_mobile;

    UPDATE u01_customer u01
       SET u01.u01_def_mobile = p_u02_mobile, u01.u01_def_email = p_u02_email
     WHERE u01.u01_id = p_u02_customer_id_u01;
END;
/

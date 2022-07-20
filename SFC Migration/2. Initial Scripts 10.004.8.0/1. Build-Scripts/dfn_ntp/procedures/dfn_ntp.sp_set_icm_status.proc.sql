CREATE OR REPLACE PROCEDURE dfn_ntp.sp_set_icm_status (
    p_status            OUT NUMBER,
    p_cl_order_id    IN     VARCHAR2,
    p_order_no       IN     VARCHAR2,
    p_order_status   IN     VARCHAR2,
    p_icm_status     IN     NUMBER,
    p_user_id        IN     NUMBER,
    p_inst_id        IN     NUMBER DEFAULT 1)
IS
    l_next_t22_id   NUMBER;
BEGIN
    UPDATE t01_order t01
       SET t01.t01_fail_mngmnt_status = p_icm_status
     WHERE t01.t01_cl_ord_id = p_cl_order_id;

    UPDATE t02_transaction_log t02
       SET t02.t02_fail_management_status = p_icm_status
     WHERE t02.t02_cliordid_t01 = p_cl_order_id;

    SELECT seq_t22_order_audit.NEXTVAL INTO l_next_t22_id FROM DUAL;

    INSERT INTO t22_order_audit (t22_id,
                                 t22_cl_ord_id_t01,
                                 t22_ord_no_t01,
                                 t22_date_time,
                                 t22_status_id_v30,
                                 t22_exchange_message_id,
                                 t22_performed_by_id_u17,
                                 t22_tenant_code,
                                 t22_institution_id_m02)
         VALUES (
                    l_next_t22_id,
                    p_cl_order_id,
                    p_order_no,
                    SYSDATE,
                    p_order_status,
                       '-1 | Fail Management Status Set to '
                    || DECODE (p_icm_status,
                               1, 'ICM Reeject',
                               2, 'ICM Settle',
                               3, 'ICM Buy In',
                               4, 'ICM Fail Chain',
                               5, 'Recapture ICM Reject'),
                    p_user_id,
                    'DEFAULT_TENANT',
                    p_inst_id);

    p_status := 1;
EXCEPTION
    WHEN OTHERS
    THEN
        p_status := -1;
END;
/

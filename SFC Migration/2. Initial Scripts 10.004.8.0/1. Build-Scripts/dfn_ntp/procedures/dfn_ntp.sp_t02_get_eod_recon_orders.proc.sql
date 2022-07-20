CREATE OR REPLACE PROCEDURE dfn_ntp.sp_t02_get_eod_recon_orders (
    p_view          OUT SYS_REFCURSOR,
    prows           OUT NUMBER,
    p_date       IN     t02_transaction_log.t02_create_date%TYPE,
    p_exchange   IN     t02_transaction_log.t02_exchange_code_m01%TYPE,
    p_inst_id    IN     t02_transaction_log.t02_inst_id_m02%TYPE)
IS
BEGIN
    OPEN p_view FOR
        SELECT t01.t01_ord_no, t01.t01_cl_ord_id, t01.t01_status_id_v30
          FROM t01_order t01
         WHERE t01.t01_date BETWEEN p_date AND p_date + 0.99999;
END;
/
/

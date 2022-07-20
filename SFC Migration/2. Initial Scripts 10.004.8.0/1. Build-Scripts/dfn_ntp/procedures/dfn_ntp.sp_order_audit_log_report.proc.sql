CREATE OR REPLACE PROCEDURE dfn_ntp.sp_order_audit_log_report (
    p_view           OUT SYS_REFCURSOR,
    prows            OUT NUMBER,
    p_order_no    IN     NUMBER,
    p_from_date   IN     DATE,
    p_to_date     IN     DATE)
IS
BEGIN
    OPEN p_view FOR
          SELECT    t22.t22_cl_ord_id_t01
                 || '-'
                 || LPAD (
                        ROW_NUMBER ()
                        OVER (PARTITION BY t22_cl_ord_id_t01 ORDER BY t22_id),
                        4,
                        '0')
                     AS t22_event_id,
                 t22.t22_cl_ord_id_t01,
                 t22.t22_ord_no_t01,
                 t22.t22_date_time,
                 t22.order_status_description,
                 t22.order_status_description_lang,
                 t22.t22_exchange_message_id,
                 t22.performed_by,
                 v29.v29_description,
                 v01_side.v01_description AS side,
                 v01_side.v01_description_lang AS side_lang,
                 u17.u17_full_name,
                 t01.t01_date,
                 t01.t01_exchange_ord_id,
                 t01.t01_symbol_code_m20,
                 t01.t01_trading_acntno_u07,
                 u01.u01_display_name,
                 u01.u01_display_name_lang,
                 t01.t01_quantity,
                 t01.t01_cum_quantity,
                 t01.t01_quantity - t01.t01_cum_quantity AS pending_qty,
                 v30.v30_description,
                 v30.v30_description_lang
            FROM t01_order_all t01
                 JOIN vw_t22_order_audit_trail t22
                     ON t01.t01_cl_ord_id = t22.t22_cl_ord_id_t01
                 JOIN v29_order_channel v29
                     ON t01.t01_ord_channel_id_v29 = v29.v29_id
                 JOIN (SELECT *
                         FROM v01_system_master_data
                        WHERE v01_type = 15) v01_side
                     ON t01.t01_side = v01_side.v01_id
                 LEFT JOIN u17_employee u17
                     ON t01.t01_dealer_id_u17 = u17.u17_id
                 JOIN u01_customer u01
                     ON t01.t01_customer_id_u01 = u01.u01_id
                 JOIN v30_order_status v30
                     ON t01.t01_status_id_v30 = v30.v30_status_id
           WHERE     t01.t01_date BETWEEN TRUNC (p_from_date)
                                      AND TRUNC (p_to_date) + 0.99999
                 AND t01.t01_ord_no = p_order_no
        ORDER BY t22_id;
END;
/

/* Formatted on 12-Jan-2021 17:43:36 (QP5 v5.206) */
DECLARE
BEGIN
    UPDATE dfn_ntp.app_seq_store
       SET app_seq_value = 0
     WHERE app_seq_name = 'M30_EX_BOARD_PERMISSIONS';

    COMMIT;

    DELETE dfn_ntp.m30_ex_board_permissions;

    FOR i IN (SELECT * FROM dfn_ntp.m59_exchange_board_status)
    LOOP
        FOR j IN (SELECT *
                    FROM dfn_ntp.m54_boards
                   WHERE m54_exchange_code_m01 = i.m59_exchange_code_m01)
        LOOP
            INSERT
              INTO dfn_ntp.m30_ex_board_permissions (
                       m30_id,
                       m30_code_m54,
                       m30_exg_brd_status_id_v19,
                       m30_exchange_code_m01,
                       m30_exchange_id_m01,
                       m30_cancel_order_allowed,
                       m30_amend_order_allowed,
                       m30_create_order_allowed,
                       m30_exchange_status_id_m59,
                       m30_custom_type)
            VALUES (dfn_ntp.fn_get_next_sequnce ('M30_EX_BOARD_PERMISSIONS'),
                    j.m54_code,
                    i.m59_board_status_id_v19,
                    i.m59_exchange_code_m01,
                    i.m59_exchange_id_m01,
                    1,
                    1,
                    1,
                    i.m59_id,
                    '1');
        END LOOP;
    END LOOP;
END;
/
commit;

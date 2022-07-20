/* Formatted on 1/12/2021 12:21:19 AM (QP5 v5.206) */
DECLARE
BEGIN
    DELETE dfn_ntp.m30_ex_board_permissions;

    COMMIT;

    UPDATE dfn_ntp.app_seq_store
       SET app_seq_value = 0
     WHERE app_seq_name = 'M30_EX_BOARD_PERMISSIONS';

    COMMIT;

    FOR j IN (SELECT m59_exchange_code_m01,
                     m59_board_status_id_v19,
                     m59_id,
                     m59_exchange_id_m01
                FROM dfn_ntp.m59_exchange_board_status
               WHERE m59_exchange_code_m01 <> 'TDWL')
    LOOP
        INSERT
          INTO dfn_ntp.m30_ex_board_permissions (m30_id,
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
                'ALL',
                j.m59_board_status_id_v19,
                j.m59_exchange_code_m01,
                j.m59_exchange_id_m01,
                1,
                1,
                1,
                j.m59_id,
                '1');
    END LOOP;


    FOR j IN (SELECT m59_exchange_code_m01,
                     m59_board_status_id_v19,
                     m59_id,
                     m59_exchange_id_m01
                FROM dfn_ntp.m59_exchange_board_status
               WHERE m59_exchange_code_m01 = 'TDWL')
    LOOP
        INSERT
          INTO dfn_ntp.m30_ex_board_permissions (m30_id,
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
                'SAEQ',
                j.m59_board_status_id_v19,
                j.m59_exchange_code_m01,
                j.m59_exchange_id_m01,
                1,
                1,
                1,
                j.m59_id,
                '1');
    END LOOP;

    FOR j IN (SELECT m59_exchange_code_m01,
                     m59_board_status_id_v19,
                     m59_id,
                     m59_exchange_id_m01
                FROM dfn_ntp.m59_exchange_board_status
               WHERE m59_exchange_code_m01 = 'TDWL')
    LOOP
        INSERT
          INTO dfn_ntp.m30_ex_board_permissions (m30_id,
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
                'SADF',
                j.m59_board_status_id_v19,
                j.m59_exchange_code_m01,
                j.m59_exchange_id_m01,
                1,
                1,
                1,
                j.m59_id,
                '1');
    END LOOP;
END;
/
commit;

/* Formatted on 1/12/2021 12:02:43 AM (QP5 v5.206) */
DECLARE
BEGIN
    DELETE dfn_ntp.m32_ex_board_status_tif;


    UPDATE dfn_ntp.app_seq_store
       SET app_seq_value = 0
     WHERE app_seq_name = 'M32_EX_BOARD_STATUS_TIF';

    COMMIT;


    FOR i IN (SELECT * FROM dfn_ntp.m54_boards)
    LOOP
        FOR j IN (SELECT *
                    FROM dfn_ntp.m58_exchange_tif
                   WHERE m58_exchange_id_m01 = i.m54_exchange_id_m01)
        LOOP
            FOR k IN (SELECT * FROM dfn_ntp.v19_board_status)
            LOOP
                INSERT
                  INTO dfn_ntp.m32_ex_board_status_tif (
                           m32_id,
                           m32_tif_type_id_v10,
                           m32_status_id_m30,
                           m32_order_type_id_v06,
                           m32_board_code_m54,
                           m32_brd_status_id_v19,
                           m32_exchange_code_m01,
                           m32_exchange_id_m01,
                           m32_exchange_order_type_id_m57,
                           m32_custom_type)
                VALUES (
                           dfn_ntp.fn_get_next_sequnce (
                               'M32_EX_BOARD_STATUS_TIF'),
                           j.m58_tif_id_v10,
                           2,
                           1,
                           i.m54_code,
                           k.v19_id,
                           i.m54_exchange_code_m01,
                           i.m54_exchange_id_m01,
                           1,
                           '1');

                INSERT
                  INTO dfn_ntp.m32_ex_board_status_tif (
                           m32_id,
                           m32_tif_type_id_v10,
                           m32_status_id_m30,
                           m32_order_type_id_v06,
                           m32_board_code_m54,
                           m32_brd_status_id_v19,
                           m32_exchange_code_m01,
                           m32_exchange_id_m01,
                           m32_exchange_order_type_id_m57,
                           m32_custom_type)
                VALUES (
                           dfn_ntp.fn_get_next_sequnce (
                               'M32_EX_BOARD_STATUS_TIF'),
                           j.m58_tif_id_v10,
                           2,
                           2,
                           i.m54_code,
                           k.v19_id,
                           i.m54_exchange_code_m01,
                           i.m54_exchange_id_m01,
                           2,
                           '1');
            END LOOP;
        END LOOP;
    END LOOP;
END;
/

COMMIT;
